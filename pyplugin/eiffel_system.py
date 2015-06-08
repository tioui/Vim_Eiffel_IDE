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
import eiffel_feature


def recompile(a_project):
    """
    Run a compilation from scratch of the openned `a_project'
    """
    environment.manual_fold()
    eiffel_ide.launch_process(a_project,
                              lambda window: a_project.recompile(window),
                              "Compiling...", "Compilation output", True,
                              False, lambda:
                              eiffel_feature.unset_feature_class_and_info())


def freeze(a_project):
    """
    Run a 'Freezing' compilation of the openned `a_project'
    See: http://docs.eiffel.com/book/eiffelstudio/melting-ice-technology
    """
    environment.manual_fold()
    eiffel_ide.launch_process(a_project,
                              lambda window: a_project.freeze(window),
                              "Freezing...", "Freezing output", True,
                              False, lambda:
                              eiffel_feature.unset_feature_class_and_info())


def melt(a_project):
    """
    Run a 'Melting' compilation of the openned `a_project'
    See: http://docs.eiffel.com/book/eiffelstudio/melting-ice-technology
    """
    environment.manual_fold()
    eiffel_ide.launch_process(a_project,
                              lambda window: a_project.melt(window),
                              "Melting...", "Melting output", True,
                              False, lambda:
                              eiffel_feature.unset_feature_class_and_info())


def finalize(a_project):
    """
    Run a 'Finilize' compilation of the openned `a_project'
    """
    environment.manual_fold()
    eiffel_ide.launch_process(a_project,
                              lambda window: a_project.finalize(window),
                              "Finalizing...", "Finalizing output", True,
                              False, lambda:
                              eiffel_feature.unset_feature_class_and_info())


def quick_melt(a_project):
    """
    Run a 'Quick Melting' compilation of the openned `a_project'
    See: http://docs.eiffel.com/book/eiffelstudio/melting-ice-technology
    """
    environment.manual_fold()
    eiffel_ide.launch_process(a_project,
                              lambda window: a_project.quick_melt(window),
                              "Quick Melting...", "Quick Melting output", True,
                              False, lambda:
                              eiffel_feature.unset_feature_class_and_info())


def quick_melt_no_focus(a_project):
    """
    Run a 'Quick Melting' compilation of the openned `a_project' and even if
    there is error, do not put the focus in the Eiffel IDE tools window.
    See: http://docs.eiffel.com/book/eiffelstudio/melting-ice-technology
    """
    environment.manual_fold()
    eiffel_ide.launch_process(a_project,
                              lambda window: a_project.quick_melt(window),
                              "Quick Melting...", "Quick Meting output", False,
                              False, lambda:
                              eiffel_feature.unset_feature_class_and_info())


def list_classes(a_project):
    """
        List all classes organize by cluster
    """
    eiffel_ide.launch_process(a_project,
                              lambda window: a_project.fetch_system_classes(
                                  window), "Getting system classes",
                              "System classes", False, True, lambda:
                              eiffel_feature.unset_feature_class_and_info())
    environment.indent_fold()
