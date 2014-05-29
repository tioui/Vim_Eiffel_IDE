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

import environment
import eiffelide


def launch_comilation(a_project, a_routine, a_work_text,
                      a_done_text, a_focus=True):
    if a_project:
        eiffelide.save_current_window_and_open_tools_window()
        eiffelide.set_tools_window_text(a_work_text)
        tools_buffer_number = eiffelide.get_tools_buffer_number()
        tools_buffer = environment.window(tools_buffer_number, True)
        a_routine(tools_buffer)
        eiffelide.set_tools_window_text(a_done_text)
        if not a_project.has_error() or not a_focus:
            eiffelide.select_saved_window()
    else:
        print("No Vim Eiffel IDE project opener")


def recompile(a_project):
    launch_comilation(a_project, lambda window: a_project.recompile(window),
                      "Compiling...", "Compilation output")


def freeze(a_project):
    launch_comilation(a_project, lambda window: a_project.freeze(window),
                      "Freezing...", "Freezing output")


def melt(a_project):
    launch_comilation(a_project, lambda window: a_project.melt(window),
                      "Melting...", "Melting output")


def finalize(a_project):
    launch_comilation(a_project, lambda window: a_project.finalize(window),
                      "Freezing...", "Freezing output")


def quick_melt(a_project):
    launch_comilation(a_project, lambda window: a_project.quick_melt(window),
                      "Quick Melting...", "Quick Melting output")


def quick_melt_no_focus(a_project):
    launch_comilation(a_project, lambda window: a_project.quick_melt(window),
                      "Quick Melting...", "Quick Meting output", False)
