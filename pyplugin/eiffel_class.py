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


def get_class_from_buffer(a_project):
    """
    Get the name of the class being edited in the current buffer.

    a_project is the current openned eiffel project.
    """
    if environment.evaluate("bufname('%')") ==\
            environment.get_global_variable("eiffel_tools_buffer_name"):
        l_class =\
            environment.get_buffer_variable("eiffel_tools_buffer_class")
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
