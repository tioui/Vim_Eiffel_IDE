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


"""Eiffel IDE project

Contain the Eiffel IDE project class and tools for compiling,
managing error, retreiving system information, etc.
"""

import os
import time
import re

import environment
import tools
import async_subprocess.async_subprocess as async_subprocess


class project:
    """An Eiffel IDE project"""

    _config_file = None
    """The Eiffel IDE project config file (.ecf) name"""

    _target_name = None
    """The Eiffel IDE project target name (None if no target needed)"""

    _compilation_output = None
    """The standard and error output of the compiler"""

    _is_compile = None
    """True if the Compiler has been correctly compile at least once."""

    _has_executable = None
    """True if an executable has been produced"""

    _has_error = None
    """True if there was an error on the last compilation"""

    _has_warning = None
    """True if there was an error on the last compilation"""

    _error_warning_regex = None
    """Internal regular expression used to parse error and warning.
    Stock for optimisation."""

    _error_list = None
    """A list of dictionnary containing informations on the errors.
    Here is what is store in the dictionnaries:
        The complete error text (Key: 'group')
        Error code (Key: 'code')
        Description (Key: 'desc')
        Information on what the user should do (Key: 'what_to_do')
        Erronous class (Key 'class')
        Erronous feature (Key 'feature')
        Erronous line if any (Key 'line')
    """
    _warning_list = None
    """A list of dictionnary containing informations on the warning.
    Here is what is store in the dictionnaries:
        The complete error text (Key: 'group')
        Error code (Key: 'code')
        Description (Key: 'desc')
        Information on what the user should do (Key: 'what_to_do')
        Erronous class (Key 'class')
        Erronous feature (Key 'feature')
        Erronous line if any (Key 'line')
    """

    def compilation_output(self):
        """Return the standard and error output of the compiler on the last
        compilation"""
        result = ""
        if self.compilation_output:
            result = self.compilation_output
        return result

    def show_compilation_output(self, a_window):
        """Print the last compiler standard and error output in the
        `a_window'"""
        a_window.set_text(self.compilation_output)

    def _ec_path(self):
        """Return the file path of the EiffelStudio compiler."""
        result = environment.get_global_variable("eiffelstudio_compiler")
        if result:
            return result
        else:
            return "ec"

    def config_file(self):
        """Return the config file name (.ecf) of `Current'"""
        return self._config_file

    def config_file_path(self):
        """Return complete absolute path of `Current' config file name
        (.ecf)."""
        return os.path.dirname(self._config_file)

    def set_config_file(self, a_config_file):
        """Assign `a_config_file' value to the config file name of
        `Current'"""
        config_file_var = os.path.expandvars(a_config_file)
        config_file_user = os.path.expanduser(config_file_var)
        config_file_norm = os.path.normpath(config_file_user)
        self._config_file = config_file_norm

    def target_name(self):
        """Return the target name of `Current'"""
        return self._target_name

    def set_target_name(self, a_target_name):
        """Assign the target name of `Current' to `a_target_name'"""
        self._target_name = a_target_name

    def is_target_provided(self):
        """True if a target name has been provided."""
        return self.target_name() != ""

    def is_compile(self):
        """True if the system has been successully compiled once."""
        return self._is_compile

    def has_executable(self):
        """True if the compiler has created an executable at least once."""
        return self._has_executable

    def has_error(self):
        """True if the last compilation has generated an error"""
        return self._has_error

    def has_warning(self):
        """True if the last compilation has generated a warning"""
        return self._has_warning

    def __init__(self, a_config_file, a_target_name=None):
        """Constructor of `Current' using `a_config_file' as config
        file name and optionnaly `a_target_name' as the target."""
        self.set_config_file(a_config_file)
        self.set_target_name(a_target_name)
        self._is_compile = True
        self._has_executable = True
        self._error_list = []
        self._warning_list = []
        l_regex = {"separator": re.compile(
            "-{35}(?:\n|\r\n?)+(.+?)(?:\n|\r\n?)+-{35}",
            re.MULTILINE | re.DOTALL
        )}
        l_regex["error_code"] = re.compile("^Error code: (.+)$", re.MULTILINE)
        l_regex["warning_code"] = re.compile("^Warning code: (.+)$",
                                             re.MULTILINE)
        l_regex["error_desc"] = re.compile("^Error: (.+)$", re.MULTILINE)
        l_regex["warning_desc"] = re.compile("^Warning: (.+)$", re.MULTILINE)
        l_regex["what_to_do"] = re.compile(
            "^What to do: (.+?)(?:\n|\r\n?)(?:\n|\r\n?)",
            re.MULTILINE | re.DOTALL
        )
        l_regex["class"] = re.compile("^Class: (.+)$", re.MULTILINE)
        l_regex["feature"] = re.compile("^Feature: (.+)$", re.MULTILINE)
        l_regex["line"] = re.compile("^Line: ([0-9]+)$", re.MULTILINE)
        self._error_warning_regex = l_regex

    def _execute_compiler(self, a_input, a_params, a_window=None,
                          a_get_stdout=True, a_get_stderr=True):
        """ Launch the EiffelStudio compiler

        a_input: The standard input to use in the compiler.
        a_params: Additionnal parameters to send to the compiler
        a_window: An optionnal window to print output to
        a_get_stdout: Returning the data returned by the standard output
                      of th compiler
        a_get_stderr: Returning the data returned by the error output
                      of th compiler

        Return: The data returned by the compiler
        """
        l_params = [self._ec_path(), "-stop", "-batch",
                    "-project_path", self.config_file_path(),
                    "-config", self.config_file()]
        if self.target_name():
            l_params.extend(["-target", self.target_name()])
        l_params.extend(a_params)
        l_process = async_subprocess.AsyncPopen(l_params,
                                                stdin=async_subprocess.PIPE,
                                                stdout=async_subprocess.PIPE,
                                                stderr=async_subprocess.PIPE)
        l_data = ""
        if a_input and l_process.poll() is None:
            l_data += self._get_new_process_output(l_process, a_input,
                                                   a_get_stdout, a_get_stderr)
        while l_process.poll() is None:
            l_data += self._get_new_process_output(l_process, None,
                                                   a_get_stdout, a_get_stderr)
            if a_window:
                a_window.set_text(l_data)
            time.sleep(0.1)
        l_data += self._get_new_process_output(l_process, "quit",
                                               a_get_stdout, a_get_stderr)
        if a_window:
            a_window.set_text(l_data)
        return l_data

    def _execute_compilation(self, a_params, a_window=None):
        """Launch the compiler and manage the output. Use `a_params' as
        compiler argument and print the output in `a_window' id define"""
        self._compilation_output =\
            self._execute_compiler(None, a_params, a_window)
        self._manage_output(self._compilation_output)

    def _get_new_process_output(self, a_process, a_input=None,
                                a_get_stdout=True, a_get_stderr=True):
        """Return the current output (standard and error) of `a_process'
        when sending `a_input' in his standard input pipe."""
        (l_stdout, l_stderr) = a_process.communicate(a_input)
        l_data = ""
        if a_get_stdout and l_stdout:
            l_data += l_stdout
        if a_get_stderr and l_stderr:
            l_data += l_stderr
        return l_data

    def _manage_output(self, a_data):
        """Parse the output data `a_data' of the compiling process to
        retreive the success and error informations."""
        if "System Recompiled." in a_data:
            self._is_compile = True
        if "C compilation completed" in a_data:
            self._has_executable = True
        self._has_error = "Error" in a_data
        self._has_warning = "Warning" in a_data or "Obsolete" in a_data
        if self.has_error() or self.has_warning():
            self._extract_errors_and_warnings(a_data)

    def _extract_errors_and_warnings(self, a_text):
        """Extract errors and warnings message from `a_text' and create
        a liste of dictionnary of errors `_error_list' and warning
        `_warning_list'"""
        self._error_list = []
        self._warning_list = []
        for l_item in self._error_warning_regex["separator"].findall(a_text):
            if "Error code:" in l_item:
                self._manage_an_error_or_warning(l_item, self._error_list,
                                                 "error")
            if "Warning code:" in l_item:
                self._manage_an_error_or_warning(l_item, self._warning_list,
                                                 "warning")

    def _manage_an_error_or_warning(self, a_text, a_list, a_mode):
        """Create a dictionnairy from a error or warning in `a_text' and
        add it to `a_list'. If a_mode is "error", the routine manage an
        error and if it is "warning", it manage a warning."""
        l_result = {"group": a_text}
        self._manage_an_error_or_warning_element(a_text, l_result, "code",
                                                 a_mode)
        self._manage_an_error_or_warning_element(a_text, l_result, "desc",
                                                 a_mode)
        self._manage_an_error_or_warning_element(a_text, l_result,
                                                 "what_to_do")
        self._manage_an_error_or_warning_element(a_text, l_result, "class")
        self._manage_an_error_or_warning_element(a_text, l_result, "feature")
        self._manage_an_error_or_warning_element(a_text, l_result, "line")
        a_list.append(l_result)

    def _manage_an_error_or_warning_element(self, a_text, a_dict, a_element,
                                            a_mode=None):
        """Add an error or warning information from `a_text' in `a_dict'
        representing `a_element'. If a_mode is "error", the routine manage an
        error and if it is "warning", it manage a warning. If it is `None',
        the element does not need to make any distinction between error or
        warning."""
        l_element = None
        if a_mode:
            l_match_list = self._error_warning_regex[a_mode + "_" +
                                                     a_element].findall(a_text)
            if len(l_match_list) > 0:
                l_element = l_match_list[0]
        else:
            l_match_list = self._error_warning_regex[a_element].findall(a_text)
            if len(l_match_list) > 0:
                l_element = l_match_list[0]
        if l_element:
            a_dict[a_element] = tools.normalize_string(l_element)
        else:
            a_dict[a_element] = l_element

    def recompile(self, a_window=None):
        """Recompile `Current' from scratch."""
        self._execute_compilation(["-clean", "-freeze", "-c_compile"],
                                  a_window)

    def freeze(self, a_window=None):
        """Run a 'Freezing' compilation.

        See: http://docs.eiffel.com/book/eiffelstudio/melting-ice-technology
        """
        self._execute_compilation(["-freeze", "-c_compile"], a_window)

    def finalize(self, a_window=None):
        """Run a 'finalize' compilation."""
        self._execute_compilation(["-finalize", "-c_compile"], a_window)

    def melt(self, a_window=None):
        """Run a 'melting' compilation.

        See: http://docs.eiffel.com/book/eiffelstudio/melting-ice-technology
        """
        self._execute_compilation(["-melt", "-c_compile"], a_window)

    def quick_melt(self, a_window=None):
        """Run a 'Quick Melting' compilation.

        See: http://docs.eiffel.com/book/eiffelstudio/melting-ice-technology
        """
        self._execute_compilation(["-quick_melt", "-c_compile"], a_window)

    def run_command(self):
        """ Return the command line to start the Eiffel Run and debug tools"""
        result = self._ec_path() + " -stop -batch -debug -project_path " +\
            self.config_file_path() + " -config " + self.config_file()
        if self.target_name():
            result = result + " -target " + self.target_name()
        return result

    def get_class_flat(self, a_class, a_window=None):
        """
            Return and optionnaly print on `a_window' the flat view
            of `a_class'.
        """
        return self._execute_compiler("C\nF\n" + a_class + "\n\nQ\n",
                                      ["-loop"], a_window, False, True)

    def get_class_ancestors(self, a_class, a_window=None):
        """
            Return and optionnaly print on `a_window' the ancestors
            of `a_class'.
        """
        return self._execute_compiler("C\nA\n" + a_class + "\n\nQ\n",
                                      ["-loop"], a_window, False, True)

    def get_class_attributes(self, a_class, a_window=None):
        """
            Return and optionnaly print on `a_window' the attributes
            of `a_class'.
        """
        return self._execute_compiler("C\nB\n" + a_class + "\n\nQ\n",
                                      ["-loop"], a_window, False, True)

    def get_class_clients(self, a_class, a_window=None):
        """
            Return and optionnaly print on `a_window' the clients
            of `a_class'.
        """
        return self._execute_compiler("C\nC\n" + a_class + "\n\nQ\n",
                                      ["-loop"], a_window, False, True)

    def get_class_deferred(self, a_class, a_window=None):
        """
            Return and optionnaly print on `a_window' the deferred feature
            of `a_class'.
        """
        return self._execute_compiler("C\nE\n" + a_class + "\n\nQ\n",
                                      ["-loop"], a_window, False, True)

    def get_class_descendants(self, a_class, a_window=None):
        """
            Return and optionnaly print on `a_window' the descendants
            of `a_class'.
        """
        return self._execute_compiler("C\nD\n" + a_class + "\n\nQ\n",
                                      ["-loop"], a_window, False, True)

    def get_class_exported(self, a_class, a_window=None):
        """
            Return and optionnaly print on `a_window' the exported features
            of `a_class'.
        """
        return self._execute_compiler("C\nP\n" + a_class + "\n\nQ\n",
                                      ["-loop"], a_window, False, True)

    def get_class_externals(self, a_class, a_window=None):
        """
            Return and optionnaly print on `a_window' the external features
            of `a_class'.
        """
        return self._execute_compiler("C\nX\n" + a_class + "\n\nQ\n",
                                      ["-loop"], a_window, False, True)

    def get_class_flatshort(self, a_class, a_window=None):
        """
            Return and optionnaly print on `a_window' the flat contract view
            of `a_class'.
        """
        return self._execute_compiler("C\nI\n" + a_class + "\n\nQ\n",
                                      ["-loop"], a_window, False, True)

    def get_class_once(self, a_class, a_window=None):
        """
            Return and optionnaly print on `a_window' the once features
            of `a_class'.
        """
        return self._execute_compiler("C\nO\n" + a_class + "\n\nQ\n",
                                      ["-loop"], a_window, False, True)

    def get_class_invariants(self, a_class, a_window=None):
        """
            Return and optionnaly print on `a_window' the invariants
            of `a_class'.
        """
        return self._execute_compiler("C\nK\n" + a_class + "\n\nQ\n",
                                      ["-loop"], a_window, False, True)

    def get_class_routines(self, a_class, a_window=None):
        """
            Return and optionnaly print on `a_window' the routines
            of `a_class'.
        """
        return self._execute_compiler("C\nR\n" + a_class + "\n\nQ\n",
                                      ["-loop"], a_window, False, True)

    def get_class_creators(self, a_class, a_window=None):
        """
            Return and optionnaly print on `a_window' the creators
            of `a_class'.
        """
        return self._execute_compiler("C\nN\n" + a_class + "\n\nQ\n",
                                      ["-loop"], a_window, False, True)

    def get_class_short(self, a_class, a_window=None):
        """
            Return and optionnaly print on `a_window' the contracts
            of `a_class'.
        """
        return self._execute_compiler("C\nS\n" + a_class + "\n\nQ\n",
                                      ["-loop"], a_window, False, True)

    def get_class_suppliers(self, a_class, a_window=None):
        """
            Return and optionnaly print on `a_window' the suppliers
            of `a_class'.
        """
        return self._execute_compiler("C\nU\n" + a_class + "\n\nQ\n",
                                      ["-loop"], a_window, False, True)

    def get_class_text(self, a_class, a_window=None):
        """
            Return and optionnaly print on `a_window' the source code text
            of `a_class'.
        """
        return self._execute_compiler("C\nT\n" + a_class + "\n\nQ\n",
                                      ["-loop"], a_window, False, True)
