# The MIT License (MIT)
#
# Copyright (c) 2014 Louis Marchand
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

import environment_vim as environment
import eiffel_ide
import string


def get_class_from_buffer(a_project):
    """
    Get the name of the class being edited in the current buffer.

    a_project is the current openned eiffel project.
    """
    if environment.evaluate("bufname('%')") ==\
            environment.get_global_variable("eiffel_tools_buffer_name"):
        try:
            l_class =\
                environment.get_buffer_variable("eiffel_tools_buffer_class")
        except:
            l_class = ""
    else:
        l_buffer_text = environment.buffer_to_text()
        l_class = a_project.class_name_from_text(l_buffer_text)
    return l_class


def set_class_and_info(a_info_name, a_class_name):
    """
        Set the `a_info_name' for the tools buffer information type and the
        `a_class_name' as the tools buffer class name.
    """
    environment.set_buffer_variable("eiffel_tools_buffer_info_type",
                                    a_info_name)
    environment.set_buffer_variable("eiffel_tools_buffer_class",
                                    a_class_name)


def unset_class_and_info():
    """
        Remove the tools buffer information type and class name.
    """
    environment.set_buffer_variable("eiffel_tools_buffer_info_type", None)
    environment.set_buffer_variable("eiffel_tools_buffer_class", None)


def class_execute(a_project, a_name, a_routine, a_class_name=None):
    """Tool routine for all class information functionnalities

    a_project: The current openned eiffel project
    a_name: The name of the functionnality (Text to print in the status bar)
    a_routine: The lambda routine that get/print information
    a_class_name: The class name to get information (optionnal)

    Return: None
    """
    if a_class_name:
        l_class = a_class_name
        if l_class == "%":
            l_class = get_class_from_buffer(a_project)
    else:
        l_class = environment.word_under_the_cursor()
        if not l_class:
            l_class = get_class_from_buffer(a_project)
    if l_class:
        eiffel_ide.launch_process(a_project,
                                  lambda window: a_routine(l_class, window),
                                  "Getting " + a_name.lower() + " of class " +
                                  l_class, a_name + " of class " + l_class,
                                  False, True,
                                  lambda: set_class_and_info(a_name, l_class))
        environment.execute("setlocal filetype=eiffel")


def flat(a_project, *arguments):
    """
    The flat view displays all the features for the current class, i.e.
    including both written-in and inherited features

    a_project: The current openned eiffel project
    arguments: A tuple that optionnaly contain the class name as first element

    See: https://docs.eiffel.com/book/eiffelstudio/class-formatters-flat-view
    """
    l_class_name = None
    if arguments:
        l_class_name = arguments[0]
    class_execute(a_project, "Flat view",
                  lambda a_class, a_buffer:
                      a_project.fetch_class_flat(a_class, a_buffer),
                  l_class_name)
    environment.eiffel_fold()


def ancestors(a_project, *arguments):
    """
    The ancestors view displays all the classes from which the current
    class inherits, directly or not, using a tree-like indented layout.

    a_project: The current openned eiffel project
    arguments: A tuple that optionnaly contain the class name as first element

    See: https://docs.eiffel.com/book/eiffelstudio/ancestors
    """
    l_class_name = None
    if arguments:
        l_class_name = arguments[0]
    class_execute(a_project, "Ancestors",
                  lambda a_class, a_buffer:
                      a_project.fetch_class_ancestors(a_class, a_buffer),
                  l_class_name)


def attributes(a_project, *arguments):
    """
    The attributes view displays all the attributes of the current class,
    including inherited attributes.

    a_project: The current openned eiffel project
    arguments: A tuple that optionnaly contain the class name as first element

    See: https://docs.eiffel.com/book/eiffelstudio/attributes
    """
    l_class_name = None
    if arguments:
        l_class_name = arguments[0]
    class_execute(a_project, "Attributes",
                  lambda a_class, a_buffer:
                      a_project.fetch_class_attributes(a_class, a_buffer),
                  l_class_name)


def clients(a_project, *arguments):
    """
    The clients view displays all the classes which are using features
    of the current class, and thus rely on its interface.

    a_project: The current openned eiffel project
    arguments: A tuple that optionnaly contain the class name as first element

    See: https://docs.eiffel.com/book/eiffelstudio/clients
    """
    l_class_name = None
    if arguments:
        l_class_name = arguments[0]
    class_execute(a_project, "Clients",
                  lambda a_class, a_buffer:
                      a_project.fetch_class_clients(a_class, a_buffer),
                  l_class_name)


def deferred(a_project, *arguments):
    """
    The deferred view displays all the deferred features of a class.

    a_project: The current openned eiffel project
    arguments: A tuple that optionnaly contain the class name as first element

    See: https://docs.eiffel.com/book/eiffelstudio/deferred-features
    """
    l_class_name = None
    if arguments:
        l_class_name = arguments[0]
    class_execute(a_project, "Deferred features",
                  lambda a_class, a_buffer:
                      a_project.fetch_class_deferred(a_class, a_buffer),
                  l_class_name)


def descendants(a_project, *arguments):
    """
    The descendants view displays all the classes which inherit from the
    current class,directly or not, using a tree-like indented layout.

    a_project: The current openned eiffel project
    arguments: A tuple that optionnaly contain the class name as first element

    See: https://docs.eiffel.com/book/eiffelstudio/descendants
    """
    l_class_name = None
    if arguments:
        l_class_name = arguments[0]
    class_execute(a_project, "Descendants",
                  lambda a_class, a_buffer:
                      a_project.fetch_class_descendants(a_class, a_buffer),
                  l_class_name)


def exported(a_project, *arguments):
    """
    The exported view displays all the features of the current class that
    all other classes may call.

    a_project: The current openned eiffel project
    arguments: A tuple that optionnaly contain the class name as first element

    See: https://docs.eiffel.com/book/eiffelstudio/exported-features
    """
    l_class_name = None
    if arguments:
        l_class_name = arguments[0]
    class_execute(a_project, "Exported features",
                  lambda a_class, a_buffer:
                      a_project.fetch_class_exported(a_class, a_buffer),
                  l_class_name)


def externals(a_project, *arguments):
    """
    The external view displays all the external features of the current class.

    a_project: The current openned eiffel project
    arguments: A tuple that optionnaly contain the class name as first element

    See: https://docs.eiffel.com/book/eiffelstudio/
                                            class-formatters-external-features
    """
    l_class_name = None
    if arguments:
        l_class_name = arguments[0]
    class_execute(a_project, "External features",
                  lambda a_class, a_buffer:
                      a_project.fetch_class_externals(a_class, a_buffer),
                  l_class_name)


def flatshort(a_project, *arguments):
    """
    The Flat Contract view displays the contracts of all written-in and
    inherited features of the current class.

    a_project: The current openned eiffel project
    arguments: A tuple that optionnaly contain the class name as first element

    See: https://docs.eiffel.com/book/eiffelstudio/flat-contract-view
    """
    l_class_name = None
    if arguments:
        l_class_name = arguments[0]
    class_execute(a_project, "Flat contract view",
                  lambda a_class, a_buffer:
                      a_project.fetch_class_flatshort(a_class, a_buffer),
                  l_class_name)
    environment.eiffel_fold()


def once(a_project, *arguments):
    """
    The once view displays all the routines declared as once and the
    constant attributes in the current class (or in its ancestors).

    a_project: The current openned eiffel project
    arguments: A tuple that optionnaly contain the class name as first element

    See: https://docs.eiffel.com/book/eiffelstudio/once-routines-and-constants
    """
    l_class_name = None
    if arguments:
        l_class_name = arguments[0]
    class_execute(a_project, "Once features",
                  lambda a_class, a_buffer:
                      a_project.fetch_class_once(a_class, a_buffer),
                  l_class_name)


def invariants(a_project, *arguments):
    """
    The invariants view displays all the invariants of the current class.

    a_project: The current openned eiffel project
    arguments: A tuple that optionnaly contain the class name as first element

    See: https://docs.eiffel.com/book/eiffelstudio/invariants
    """
    l_class_name = None
    if arguments:
        l_class_name = arguments[0]
    class_execute(a_project, "Invariants",
                  lambda a_class, a_buffer:
                      a_project.fetch_class_invariants(a_class, a_buffer),
                  l_class_name)


def routines(a_project, *arguments):
    """
    The routines view displays all the routine signatures of the current
    class, including inherited routines.

    a_project: The current openned eiffel project
    arguments: A tuple that optionnaly contain the class name as first element

    See: https://docs.eiffel.com/book/eiffelstudio/routines
    """
    l_class_name = None
    if arguments:
        l_class_name = arguments[0]
    class_execute(a_project, "Routines",
                  lambda a_class, a_buffer:
                      a_project.fetch_class_routines(a_class, a_buffer),
                  l_class_name)


def creators(a_project, *arguments):
    """
     The creators view displays all the creation procedure signatures of the
     current class.

    a_project: The current openned eiffel project
    arguments: A tuple that optionnaly contain the class name as first element

    See: https://docs.eiffel.com/book/eiffelstudio/creators
    """
    l_class_name = None
    if arguments:
        l_class_name = arguments[0]
    class_execute(a_project, "Creators",
                  lambda a_class, a_buffer:
                      a_project.fetch_class_creators(a_class, a_buffer),
                  l_class_name)


def short(a_project, *arguments):
    """
    The contract view displays the contracts of all written-in features of the
    current class.

    a_project: The current openned eiffel project
    arguments: A tuple that optionnaly contain the class name as first element

    See: https://docs.eiffel.com/book/eiffelstudio/contract-view
    """
    l_class_name = None
    if arguments:
        l_class_name = arguments[0]
    class_execute(a_project, "Contract View",
                  lambda a_class, a_buffer:
                      a_project.fetch_class_short(a_class, a_buffer),
                  l_class_name)
    environment.eiffel_fold()


def suppliers(a_project, *arguments):
    """
    The suppliers view displays all the classes from which the current
    class is calling features.

    a_project: The current openned eiffel project
    arguments: A tuple that optionnaly contain the class name as first element

    See: https://docs.eiffel.com/book/eiffelstudio/suppliers
    """
    l_class_name = None
    if arguments:
        l_class_name = arguments[0]
    class_execute(a_project, "Suppliers",
                  lambda a_class, a_buffer:
                      a_project.fetch_class_suppliers(a_class, a_buffer),
                  l_class_name)


def text(a_project, *arguments):
    """
    Show the original text source code of the class.

    a_project: The current openned eiffel project
    arguments: A tuple that optionnaly contain the class name as first element

    See: https://docs.eiffel.com/book/eiffelstudio/
                                              class-formatters-basic-text-view
    """
    l_class_name = None
    if arguments:
        l_class_name = arguments[0]
    class_execute(a_project, "Text View",
                  lambda a_class, a_buffer:
                      a_project.fetch_class_text(a_class, a_buffer),
                  l_class_name)
    environment.eiffel_fold()


def _edit_command_and_flag(is_split, is_vertical, is_tab, force_edit):
    """
        Return the command and flags to use in the `edit' procedure.

        is_split:       The command must execute a split window
        is_vertical:    if `is_split' is set, the vertical `flags' will be set
        is_tab:         If `is_split' is not set, command must execute a new
                        tab
        force_edit:     if `is_split' and `is_tab' are not set, command must
                        overrite the current window content event if it is
                        modified.

        Return:         a tuple containing the appropriete command and flags.
    """
    flags = ""
    if is_split:
        command = "split"
        if is_vertical:
            flags = "vertical"
    elif is_tab:
        command = "tabedit"
    else:
        command = "edit"
        if force_edit:
            command = command + "!"
    return (command, flags)


def edit(a_project, is_split=False, is_vertical=False, is_tab=False,
         force_edit=False, *argument):
    """
        Open the class in an editing window.

        a_project:      The currently open Eiffel project.
        is_split:       Open in another split window
        is_vertical:    if `is_split' is set, use a vertical split
        is_tab:         if `is_split' is not set, open window in a new tab
        force_edit:     if `is_split' and `is_tab' is not set, must overrite
                        the current window content event if it is modified.
        argument:       Optionnaly the class_name to edit. If not set, use
                        the word under the cursor.
    """
    has_error = False
    if argument:
        class_name = argument[0]
    else:
        class_name = environment.word_under_the_cursor()
    if class_name:
        class_path = a_project.file_path_from_class_name(class_name)
    else:
        class_path = None
    if class_path:
        (command, flags) = _edit_command_and_flag(is_split, is_vertical,
                                                  is_tab, force_edit)
        if not is_split and not is_tab and not force_edit:
            if int(environment.get_option("modified")):
                print("No write since last change (add F to override)")
                has_error = True
        if not has_error:
            environment.execute(flags + " " + command + " " + class_path)


def complete_start():
    """ Get the first character of the class/feature name under the cursor."""
    result = -3
    col = environment.get_cursor_column()
    row = environment.get_cursor_row()
    if col != 0:
        start = environment.start_column_of_word(row, col - 1)
        if start < 0:
            result = col
        else:
            result = start
    else:
        result = 0
    return result


def match_list_feature(a_list, a_base):
    """
        Every element of `a_list' that start with the same character of
        `a_base'.
    """
    result = []
    for element in a_list:
        if a_base.upper() == element[0][:len(a_base)].upper():
            result.append(element[0])
    return result


def get_local_variable(a_project):
    """
        A list of local variables declared in the previous local section.
    """
    do_regex = a_project.get_tools_regex("extract_do_keywork")
    deferred_regex = a_project.get_tools_regex("extract_deferred_keywork")
    local_regex = a_project.get_tools_regex("extract_local_keywork")
    require_regex = a_project.get_tools_regex("extract_require_keywork")
    ensure_regex = a_project.get_tools_regex("extract_ensure_keywork")
    text_list = environment.text_list()
    i = environment.get_cursor_row()
    is_cancel_syntax_founded = False
    do_row = -1
    l_result = []
    while not is_cancel_syntax_founded and do_row < 0 and i >= 0:
        if require_regex.search(text_list[i]) or\
                deferred_regex.search(text_list[i]):
            is_cancel_syntax_founded = True
        elif do_regex.search(text_list[i]):
            do_row = i
        i = i - 1
    while not is_cancel_syntax_founded and i >= 0 and not\
            local_regex.search(text_list[i]):
        if require_regex.search(text_list[i]) or\
                do_regex.search(text_list[i]) or\
                ensure_regex.search(text_list[i]):
            l_result = []
            is_cancel_syntax_founded = True
        else:
            l_variables = get_variable_from_line(a_project, text_list[i])
            if l_variables:
                l_result.extend(l_variables)
        i = i - 1
    return l_result


def complete_class_match(a_project, a_base):
    """
        A Vim compatible list of the classes of `a_project' that start with
        the characters in `a_base'
    """
    matches = eiffel_ide.match_list_class(a_project.class_list(), a_base)
    return str(matches)


def is_cursor_on_client_call():
    """True if the cursor is on a client type call"""
    l_start = complete_start() - 1
    row = environment.get_cursor_row()
    l_previous_white = environment.previous_non_white_character_in_row(row,
                                                                       l_start)
    result = False
    if l_previous_white >= 0:
        result = environment.text_list()[row][l_previous_white] == "."
    return result


def get_associated_bracket_position(a_row, a_col):
    """
        The openning position of the bracket closing at position
        (`a_row',`a_col')
    """
    l_text = environment.text_list()[a_row]
    l_character = l_text[a_col]
    l_result = a_col
    if l_character in ("(", "[", "{"):
        l_incrementation = 1
        l_search = (")", "]", "}")[("(", "[", "{").index(l_character)]
    elif l_character in (")", "]", "}"):
        l_incrementation = -1
        l_search = ("(", "[", "{")[(")", "]", "}").index(l_character)]
    else:
        l_incrementation = 0
    if l_incrementation != 0:
        l_result = l_result + l_incrementation
        while l_result >= 0 and l_result < len(l_text) and\
                l_text[l_result] != l_search:
            if l_text[l_result] == l_character:
                l_result = get_associated_bracket_position(a_row, l_result)
            l_result = l_result + l_incrementation
    if l_result > len(l_text):
        l_result = 0
    return l_result


def create_row_object_stack():
    """Extract every stacking object in a client call"""
    l_row = environment.get_cursor_row()
    non_splittable_characters = string.ascii_letters + string.digits + "_"
    l_col = complete_start() - 1
    l_col = environment.previous_non_white_character_in_row(l_row, l_col)
    l_text = environment.text_of_cursor_row()
    l_result = []
    while l_col > 0 and l_text[l_col] == ".":
        l_col = l_col - 1
        l_col = environment.previous_non_white_character_in_row(l_row, l_col)
        while l_col >= 0 and l_text[l_col] in (")", "]"):
            l_col = get_associated_bracket_position(l_row, l_col)
            if l_col < 0:
                l_result = []
            l_col = environment.previous_non_white_character_in_row(l_row,
                                                                    l_col - 1)
        if l_col >= 0 and l_text[l_col] in non_splittable_characters:
            l_new_col = environment.start_column_of_word(l_row, l_col)
            if l_text[l_new_col] in string.digits:
                l_result = []
                l_col = -1
            else:
                l_result.append(l_text[l_new_col:l_col+1])
                l_col = l_new_col
                l_col = environment.previous_non_white_character_in_row(
                    l_row, l_col - 1)
        else:
            l_col = -1
    return l_result


def retreive_value_from_pair(a_key, a_pair_list):
    """
        Retreive the value (`a_pair_list[i][1]') assoiate with
        the key (`a_pair_list[i][0]') in the list of pair ``a_pair_list'.
    """
    l_result = None
    i = 0
    while i >= 0 and a_pair_list[i][0] != a_key:
        i = i + 1
    if i >= 0:
        l_result = a_pair_list[i][1]
    return l_result


def index_of_key_in_pair(a_key, a_pair_list):
    """
        Retreive the index i where `a_pair_list[i][0]' is equal to `a_key`.
    """
    i = len(a_pair_list) - 1
    while i >= 0 and a_pair_list[i][0] != a_key:
        i = i - 1
    return i


def translate_generics_to_class(a_class_generics, a_object_generics,
                                a_class_name):
    """
        Retreive the class name associate to the generic `a_class_name'.
        The Generics of the class is `a_class_generics' and the classes
        associate to the generics are in `a_object_generics'.
    """
    l_object_generics = a_object_generics.replace(" ", "").\
        replace("\t", "").split(",")
    l_result = None
    i = 0
    while i < len(a_class_generics) and a_class_generics[i] != a_class_name:
        i = i + 1
    l_result = None
    if i < len(l_object_generics):
        l_result = l_object_generics[i]
    return l_result


def get_variable_from_line(a_project, a_variable_line):
    """
        Parse a variable declaration line (like "a, b, c:INTEGER")
        and return a list of tuple containing 0: variable name,
        1: Type, 2: Generic, 3: Empty string (those feature are not
        obsolete)
    """
    l_variable_regex = a_project.get_tools_regex("extract_local_variable")
    l_variable_values = l_variable_regex.findall(a_variable_line)
    l_result = []
    if l_variable_values:
        l_variable_names = l_variable_values[0][0].replace(" ", "").\
            replace("\t", "").split(",")
        for name in l_variable_names:
            l_result.append((name, l_variable_values[0][1],
                            l_variable_values[0][2], ""))
    return l_result


def get_arguments_from_lines(a_project, a_arguments_line):
    """
        Parse an argument declaration line
        (like "a, b, c:INTEGER; d, e:STRING")
        and return a list of tuple containing 0: variable name,
        1: Type, 2: Generic, 3: Empty string (those feature are not
        obsolete)
    """
    l_type_list = a_arguments_line.split(";")
    l_argument_list = []
    for element in l_type_list:
        l_variables = get_variable_from_line(a_project, element)
        if l_variables:
            l_argument_list.extend(l_variables)
    return l_argument_list


def get_result_and_arguments(a_project):
    """
        Found the signature of the current routine and return a list
        of tuple for Result and arguments containing 0: variable name,
        1: Type, 2: Generic, 3: Empty string (those feature are not
        obsolete)
    """
    l_signature_row = eiffel_ide.find_last_routine_header(a_project)
    l_signature_regex = a_project.get_tools_regex("extract_signature")
    l_signature_values =\
        l_signature_regex.findall(environment.text_list()[l_signature_row])
    l_result = []
    if l_signature_values[0][1]:
        l_result.append(("Result", l_signature_values[0][1],
                         l_signature_values[0][2], ""))
    l_result.extend(get_arguments_from_lines(a_project,
                                             l_signature_values[0][0]))
    return l_result


def class_and_features_of_client_call(a_project):
    """
        Retreive the name of the class under the current cursor context and
        the list or features of this class. The cursor context must be a
        client call.
    """
    l_features = a_project.feature_list(get_class_from_buffer(a_project))
    l_features.extend(get_local_variable(a_project))
    l_features.extend(get_result_and_arguments(a_project))
    l_stack = create_row_object_stack()
    l_old_class = None
    l_class = None
    l_generics = None
    l_index = -1
    i = len(l_stack) - 1
    l_abort = False
    while i >= 0 and not l_abort:
        l_index = index_of_key_in_pair(l_stack[i], l_features)
        if l_index >= 0:
            l_old_class = l_class
            l_class = l_features[l_index][1]
            l_old_generics = l_generics
            l_generics = l_features[l_index][2]
            if l_class:
                l_features = a_project.exported_feature_list(l_class)
                if not l_features and l_old_class and l_old_generics:
                    l_class_generics = a_project.class_generic(l_old_class)
                    if l_class_generics:
                        l_new_class =\
                            translate_generics_to_class(l_class_generics,
                                                        l_old_generics,
                                                        l_class)
                        if l_new_class:
                            l_class = l_new_class
                            l_features =\
                                a_project.exported_feature_list(l_class)
            else:
                l_features = []
                l_abort = True
        else:
            l_features = []
            l_abort = True
        i = i - 1
    return (l_class, l_features)


def complete_feature_match(a_project, a_base):
    """
        A string list of the feature of `a_project' that match
        `a_base' in the current code context
    """
    matches = []
    if is_cursor_on_client_call():
        l_list = class_and_features_of_client_call(a_project)[1]
        l_not_obsolete_feature = []
        for element in l_list:
            if not element[3]:
                l_not_obsolete_feature.append(element)
        if l_not_obsolete_feature:
            matches = match_list_feature(l_not_obsolete_feature, a_base)
    else:
        l_list = a_project.feature_list(get_class_from_buffer(a_project))
        l_list.extend(get_local_variable(a_project))
        l_list.extend(get_result_and_arguments(a_project))
        matches = match_list_feature(l_list, a_base)
    matches.sort(key=lambda mbr: mbr.lower())
    result = "["
    is_first = True
    for match in matches:
        if is_first:
            result = result + "\"" + match + "\""
            is_first = False
        else:
            result = result + ",\"" + match + "\""
    result = result + "]"
    return result


def complete_creator_match(a_project, a_base):
    """
        A string list of the creator of `a_project' that match
        `a_base' in the current code context
    """
    matches = []
    if is_cursor_on_client_call():
        l_features = a_project.feature_list(get_class_from_buffer(a_project))
        l_features.extend(get_local_variable(a_project))
        l_features.extend(get_result_and_arguments(a_project))
        l_stack = create_row_object_stack()
        if l_stack:
            l_index = index_of_key_in_pair(l_stack[0], l_features)
            if l_index >= 0:
                l_class = l_features[l_index][1]
                if l_class:
                    matches = match_list_feature(
                        a_project.creators_list(l_class), a_base)
    matches.sort(key=lambda mbr: mbr.lower())
    result = "["
    is_first = True
    for match in matches:
        if is_first:
            result = result + "\"" + match + "\""
            is_first = False
        else:
            result = result + ",\"" + match + "\""
    result = result + "]"
    return result
