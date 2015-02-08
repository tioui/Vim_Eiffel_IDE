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
import eiffel_class


def get_feature_from_current_buffer_and_pos(a_project):
    """
        Get the name of the feature being edited in the current buffer

        a_project is the current openned eiffel project
    """
    pass


def get_feature_under_the_cursor(a_project):
    """
        Get the feature name of the word under the cursor and it's assoriate
        class name.
    """
    if eiffel_class.is_cursor_on_client_call():
        l_class = eiffel_class.class_and_features_of_client_call(a_project)[0]
    else:
        l_class = eiffel_class.get_class_from_buffer(a_project)
    return (l_class, environment.word_under_the_cursor())


def set_feature_class_and_info(a_info_name, a_class_name, a_feature_name):
    """
        Set the `a_info_name' for the tools buffer information type and the
        `a_class_name' as the tools buffer class name and `a_feature_name' as
        the tools buffer feature name.
    """
    eiffel_class.set_class_and_info(a_info_name, a_class_name)
    environment.set_buffer_variable("eiffel_tools_buffer_feature",
                                    a_feature_name)


def unset_feature_class_and_info():
    """
        Remove the tools buffer information type, class name and feature name.
    """
    eiffel_class.unset_class_and_info()
    environment.set_buffer_variable("eiffel_tools_buffer_feature", None)


def feature_execute(a_project, a_name, a_routine, a_class_name=None,
                    a_feature_name=None):
    """Tool routine for all feature information functionnalities

    a_project: The current openned eiffel project
    a_name: The name of the functionnality (Text to print in the status bar)
    a_routine: The lambda routine that get/print information
    a_class_name: The class name to get information (optionnal)
    a_feature_name: The feture name to get information (optionnal)

    Return: None
    """
    if not a_class_name and not a_feature_name:
        (l_class, l_feature) = get_feature_under_the_cursor(a_project)
    else:
        if a_class_name:
            l_class = a_class_name
            if l_class == "%":
                l_class = eiffel_class.get_class_from_buffer(a_project)
        else:
            l_class = eiffel_class.get_class_from_buffer(a_project)
        if a_feature_name:
            l_feature = a_feature_name
            if l_feature == "%":
                l_feature = get_feature_from_current_buffer_and_pos(a_project)
        else:
            l_feature = environment.word_under_the_cursor()
            if not l_feature:
                l_feature = get_feature_from_current_buffer_and_pos(a_project)
    if l_class and l_feature:
        eiffel_ide.launch_process(a_project,
                                  lambda window: a_routine(l_class, l_feature,
                                                           window),
                                  "Getting " + a_name.lower() +
                                  " of feature " + l_feature + " of class " +
                                  l_class, a_name + " of feature " +
                                  l_feature + " of class " + l_class, False,
                                  True,
                                  lambda: set_feature_class_and_info(
                                      a_name, l_class, l_feature
                                  ))
        environment.execute("setlocal filetype=eiffel")


def ancestors(a_project, *arguments):
    """
        The ancestor versions view displays all the features which the feature
        is redefining.

        a_project: The current openned eiffel project
        arguments: A tuple that optionnaly contain the class name as first
        element and the feature name as the second

        See: https://docs.eiffel.com/book/eiffelstudio/
                                        feature-formatters-ancestor-versions
    """
    l_class_name = None
    l_feature_name = None
    if arguments:
        if len(arguments) == 1:
            l_feature_name = arguments[0]
        else:
            l_class_name = arguments[0]
            l_feature_name = arguments[1]
    feature_execute(a_project, "Ancestors",
                    lambda a_class, a_feature, a_buffer:
                        a_project.fetch_feature_ancestors(a_class, a_feature,
                                                          a_buffer),
                    l_class_name, l_feature_name)


def callers(a_project, *arguments):
    """
        The callers view displays all the features which use the feature in any
        way.

        a_project: The current openned eiffel project
        arguments: A tuple that optionnaly contain the class name as first
        element and the feature name as the second

        See: https://docs.eiffel.com/book/eiffelstudio/
                                                   feature-formatters-callers
    """
    l_class_name = None
    l_feature_name = None
    if arguments:
        if len(arguments) == 1:
            l_feature_name = arguments[0]
        else:
            l_class_name = arguments[0]
            l_feature_name = arguments[1]
    feature_execute(a_project, "Callers",
                    lambda a_class, a_feature, a_buffer:
                        a_project.fetch_feature_callers(a_class, a_feature,
                                                        a_buffer),
                    l_class_name, l_feature_name)


def creators(a_project, *arguments):
    """
        The creators view shows all features in which the current feature
        appears as the target of a creation instruction. The creators view will
        be empty for any feature which is not an attribute.

        a_project: The current openned eiffel project
        arguments: A tuple that optionnaly contain the class name as first
        element and the feature name as the second

        See: https://docs.eiffel.com/book/eiffelstudio/
                                                   feature-formatters-creators
    """
    l_class_name = None
    l_feature_name = None
    if arguments:
        if len(arguments) == 1:
            l_feature_name = arguments[0]
        else:
            l_class_name = arguments[0]
            l_feature_name = arguments[1]
    feature_execute(a_project, "Creators",
                    lambda a_class, a_feature, a_buffer:
                        a_project.fetch_feature_creators(a_class, a_feature,
                                                         a_buffer),
                    l_class_name, l_feature_name)


def assigners(a_project, *arguments):
    """
        The assigners view displays the features which assign to the current
        feature. This means that unless the current feature is an attribute,
        assignment is not defined and this view will be empty.

        a_project: The current openned eiffel project
        arguments: A tuple that optionnaly contain the class name as first
        element and the feature name as the second

        See: https://docs.eiffel.com/book/eiffelstudio/
                                                  feature-formatters-assigners
    """
    l_class_name = None
    l_feature_name = None
    if arguments:
        if len(arguments) == 1:
            l_feature_name = arguments[0]
        else:
            l_class_name = arguments[0]
            l_feature_name = arguments[1]
    feature_execute(a_project, "Assigners",
                    lambda a_class, a_feature, a_buffer:
                        a_project.fetch_feature_assigners(a_class, a_feature,
                                                          a_buffer),
                    l_class_name, l_feature_name)


def callees(a_project, *arguments):
    """
        The callees view will list the names of all features used by the
        feature.

        a_project: The current openned eiffel project
        arguments: A tuple that optionnaly contain the class name as first
        element and the feature name as the second

        See: https://docs.eiffel.com/book/eiffelstudio/
                                                   feature-formatters-callees
    """
    l_class_name = None
    l_feature_name = None
    if arguments:
        if len(arguments) == 1:
            l_feature_name = arguments[0]
        else:
            l_class_name = arguments[0]
            l_feature_name = arguments[1]
    feature_execute(a_project, "Callees",
                    lambda a_class, a_feature, a_buffer:
                        a_project.fetch_feature_callees(a_class, a_feature,
                                                        a_buffer),
                    l_class_name, l_feature_name)


def creations(a_project, *arguments):
    """
        The feature creations view displays the names of any features which
        appear in the current feature as targets of creation instructions.

        a_project: The current openned eiffel project
        arguments: A tuple that optionnaly contain the class name as first
        element and the feature name as the second

        See: https://docs.eiffel.com/book/eiffelstudio/
                                                   feature-formatters-creations
    """
    l_class_name = None
    l_feature_name = None
    if arguments:
        if len(arguments) == 1:
            l_feature_name = arguments[0]
        else:
            l_class_name = arguments[0]
            l_feature_name = arguments[1]
    feature_execute(a_project, "Creation",
                    lambda a_class, a_feature, a_buffer:
                        a_project.fetch_feature_creation(a_class, a_feature,
                                                         a_buffer),
                    l_class_name, l_feature_name)


def assignees(a_project, *arguments):
    """
        The assignees view lists all features which appear in the current
        feature as targets of assignments. This includes true assignments to
        class features only, that is, it does not include "targets" of the
        assignment-like syntax of assignment commands.

        a_project: The current openned eiffel project
        arguments: A tuple that optionnaly contain the class name as first
        element and the feature name as the second

        See: https://docs.eiffel.com/book/eiffelstudio/
                                                   feature-formatters-assignees
    """
    l_class_name = None
    l_feature_name = None
    if arguments:
        if len(arguments) == 1:
            l_feature_name = arguments[0]
        else:
            l_class_name = arguments[0]
            l_feature_name = arguments[1]
    feature_execute(a_project, "Assignees",
                    lambda a_class, a_feature, a_buffer:
                        a_project.fetch_feature_assignees(a_class, a_feature,
                                                          a_buffer),
                    l_class_name, l_feature_name)


def descendants(a_project, *arguments):
    """
        The descendant versions view displays all the features that redefine
        the feature.

        a_project: The current openned eiffel project
        arguments: A tuple that optionnaly contain the class name as first
        element and the feature name as the second

        See: https://docs.eiffel.com/book/eiffelstudio/
                                       feature-formatters-descendant-versions
    """
    l_class_name = None
    l_feature_name = None
    if arguments:
        if len(arguments) == 1:
            l_feature_name = arguments[0]
        else:
            l_class_name = arguments[0]
            l_feature_name = arguments[1]
    feature_execute(a_project, "Descendants",
                    lambda a_class, a_feature, a_buffer:
                        a_project.fetch_feature_descendants(a_class, a_feature,
                                                            a_buffer),
                    l_class_name, l_feature_name)


def flat(a_project, *arguments):
    """
        The flat view displays the feature body as it is seen at run-time
        (according to ancestor versions, if any).

        a_project: The current openned eiffel project
        arguments: A tuple that optionnaly contain the class name as first
        element and the feature name as the second

        See: https://docs.eiffel.com/book/eiffelstudio/
                                                  feature-formatters-flat-view
    """
    l_class_name = None
    l_feature_name = None
    if arguments:
        if len(arguments) == 1:
            l_feature_name = arguments[0]
        else:
            l_class_name = arguments[0]
            l_feature_name = arguments[1]
    feature_execute(a_project, "Flat",
                    lambda a_class, a_feature, a_buffer:
                        a_project.fetch_feature_flat(a_class, a_feature,
                                                     a_buffer),
                    l_class_name, l_feature_name)


def homonyms(a_project, *arguments):
    """
        The homonyms view displays all the features in the system which have
        the same name as the feature.

        a_project: The current openned eiffel project
        arguments: A tuple that optionnaly contain the class name as first
        element and the feature name as the second

        See: https://docs.eiffel.com/book/eiffelstudio/
                                                  feature-formatters-homonyms
    """
    l_class_name = None
    l_feature_name = None
    if arguments:
        if len(arguments) == 1:
            l_feature_name = arguments[0]
        else:
            l_class_name = arguments[0]
            l_feature_name = arguments[1]
    feature_execute(a_project, "Homonyms",
                    lambda a_class, a_feature, a_buffer:
                        a_project.fetch_feature_homonyms(a_class, a_feature,
                                                         a_buffer),
                    l_class_name, l_feature_name)


def implementers(a_project, *arguments):
    """
        The implementers view displays all the different versions of the
        feature by exploring the ancestor versions and the descendant versions,
        and selecting among those the ones which are not inherited.

        a_project: The current openned eiffel project
        arguments: A tuple that optionnaly contain the class name as first
        element and the feature name as the second

        See: https://docs.eiffel.com/book/eiffelstudio/
                                               feature-formatters-implementers
    """
    l_class_name = None
    l_feature_name = None
    if arguments:
        if len(arguments) == 1:
            l_feature_name = arguments[0]
        else:
            l_class_name = arguments[0]
            l_feature_name = arguments[1]
    feature_execute(a_project, "Implementers",
                    lambda a_class, a_feature, a_buffer:
                        a_project.fetch_feature_implementers(a_class,
                                                             a_feature,
                                                             a_buffer),
                    l_class_name, l_feature_name)


def text(a_project, *arguments):
    """
        The basic text view displays the text of the feature as it is written
        in the enclosing class.

        a_project: The current openned eiffel project
        arguments: A tuple that optionnaly contain the class name as first
        element and the feature name as the second

        See: https://docs.eiffel.com/book/eiffelstudio/
                                             feature-formatters-basic-text-view
    """
    l_class_name = None
    l_feature_name = None
    if arguments:
        if len(arguments) == 1:
            l_feature_name = arguments[0]
        else:
            l_class_name = arguments[0]
            l_feature_name = arguments[1]
    feature_execute(a_project, "Text",
                    lambda a_class, a_feature, a_buffer:
                        a_project.fetch_feature_text(a_class, a_feature,
                                                     a_buffer),
                    l_class_name, l_feature_name)


def complete_features_commands(a_project, a_base, a_command_line,
                               a_cursor_position):
    """
        Return a text list of the possible features or classes
        starting with `a_base' in `a_project'. Use `a_command_lise'
        and `a_cursor_position' to validate if the function must
        complete class names or feature names.
    """
    l_to_complete = 0
    l_last_was_space = False
    i = 0
    while(i < a_cursor_position and i < len(a_command_line) and
          l_to_complete < 2):
        if a_command_line[i] == " ":
            if not l_last_was_space:
                l_to_complete = l_to_complete + 1
                l_last_was_space = True
        else:
            l_last_was_space = False
        i = i + 1
    if l_to_complete < 2:
        l_result = eiffel_class.complete_class_match(a_project, a_base)
    else:
        l_class = a_command_line.split()[1]
        if l_class == "%":
            l_class = eiffel_class.get_class_from_buffer(a_project)
        l_features_list = a_project.feature_list(l_class)
        l_matches = eiffel_ide.match_list_class(
            (element[0] for element in l_features_list), a_base)
        l_result = str(l_matches)
    return l_result
