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

"""Common routines for the Vim Eiffel IDE."""

import environment


def save_current_window():
    """
    Save the current window to reselect it afterward by
    `select_saved_window'
    """
    environment.set_global_variable("eiffel_saved_window_number",
                                    environment.evaluate("bufwinnr('%')"))


def select_saved_window():
    """Select the window saved by the `save_current_window' feature"""
    if environment.is_global_variable_exists("eiffel_saved_window_number"):
        saved_window_number = environment.get_global_variable(
            "eiffel_saved_window_number"
        )
        environment.execute(
            saved_window_number + "wincmd w"
        )


def get_tools_window_position_flag():
    """Return the global flag for eiffel tools window positionning"""
    if int(environment.get_global_variable(
        "eiffel_tools_window_leftabove"
    )):
        position_flag = "leftabove"
    else:
        position_flag = "rightbelow"
    return position_flag


def get_tools_window_vertical_flag():
    """Return the global flag for eiffel tools window vertical positionning"""
    vertical_flag = ""
    if int(environment.get_global_variable(
        "eiffel_tools_window_vertical"
    )):
        vertical_flag = "vertical"
    return vertical_flag


def save_current_window_and_open_existing_tools_window(a_buffer_name,
                                                       command="split"):
    """
    Save the current window with `save_current_window' and open the
    existing tools buffer `a_buffer_name' in a new window. If `command' is set
    to 'new', the tools buffer a_buffer_name don't have to exist
    """
    position_flag = get_tools_window_position_flag()
    vertical_flag = get_tools_window_vertical_flag()
    dimension = environment.get_global_variable(
        "eiffel_tools_window_dimension"
    )
    to_execute = position_flag + " " + vertical_flag + " " + dimension + " " +\
        command + " " + a_buffer_name
    environment.execute(to_execute)
    environment.execute("redraw")
    environment.execute("wincmd p")
    save_current_window()
    environment.execute("wincmd p")


def save_current_window_and_open_new_tools_window(a_buffer_name):
    """
    Save the current window with `save_current_window' and open a new tools
    buffer `a_buffer_name' in a new window.
    """
    save_current_window_and_open_existing_tools_window(a_buffer_name, "new")
    if environment.evaluate("bufname(\"%\")") == a_buffer_name:
        environment.execute("setlocal buftype=nofile")
        environment.execute("setlocal bufhidden=hide")
        environment.execute("setlocal noswapfile")
        environment.set_buffer_variable("eiffel_tools_buffer_class", "")
        environment.set_buffer_variable("eiffel_tools_buffer_info",
                                        "Eiffel IDE Information")


def save_current_window_and_select_tools_window(a_tools_window_number):
    """
    Save the current window with `save_current_window' and select the
    tools buffer window with the number `a_tools_window_number'
    """
    save_current_window()
    environment.execute(str(a_tools_window_number) + " wincmd w")


def get_tools_buffer_number():
    name = environment.get_global_variable("eiffel_tools_buffer_name")
    return int(environment.evaluate("bufnr(\"" + name + "\")"))


def save_current_window_and_open_tools_window():
    """
    Save the current window with `save_current_window' and open the eiffel
    tools buffer in a window. The window containing the eiffel tools buffer
    will be selected after the launch of this routine. To reselect the
    window saved by this routine, use the `select_saved_window' routine.
    """
    tools_buffer_name = environment.get_global_variable(
        "eiffel_tools_buffer_name"
    )
    tools_buffer_number = get_tools_buffer_number()
    if tools_buffer_number < 0:
        save_current_window_and_open_new_tools_window(tools_buffer_name)
    else:
        tools_buffer_window_number = int(environment.evaluate(
            "bufwinnr(\"" + tools_buffer_name + "\")"
        ))
        if tools_buffer_window_number < 0:
            save_current_window_and_open_existing_tools_window(
                tools_buffer_name
            )
        else:
            save_current_window_and_select_tools_window(
                tools_buffer_window_number
            )
    environment.execute("setlocal filetype=")


def set_tools_window_text(a_text):
    """Change the Eiffel tools buffer window status bar text."""
    environment.execute("let b:eiffel_tools_buffer_info = \"" + a_text + "\"")


def run_project(a_project):
    """Run the executable of the Eiffel Project `a_project'."""
    if a_project:
        environment.execute("!" + a_project.run_command())
    else:
        print("No Vim Eiffel IDE project opened.")


def launch_process(a_project, a_routine, a_work_text, a_done_text,
                   a_focus_on_error=False, a_always_focus=False):
    if a_project:
        save_current_window_and_open_tools_window()
        set_tools_window_text(a_work_text)
        tools_buffer_number = get_tools_buffer_number()
        tools_buffer = environment.window(tools_buffer_number, True)
        a_routine(tools_buffer)
        set_tools_window_text(a_done_text)
        if not(a_always_focus or (a_focus_on_error and a_project.has_error())):
            select_saved_window()
    else:
        print("No Eiffel project opened")


def test_argv(*arguments):
    text = ""
    for i in arguments:
        text = text + str(i)
    print(text)
