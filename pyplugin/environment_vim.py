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


"""Interface to the vim archive to use with the other python file

Give an interface to the vim archivecture to hide all vim functionnality
from the python file.
"""

import vim
import string


def evaluate(a_instruction):
    """Evaluate the Vim instruction `a_instruction' and retuen a string
    containing the result"""
    return vim.eval(a_instruction)


def execute(a_command):
    """Execute the Vim command `a_command'"""
    vim.command(a_command)


def is_option_exists(a_option_name):
    """Is the Vim option named `a_option_name' is define."""
    return int(evaluate("exists(\"&" + a_option_name + "\")"))


def get_option(a_option_name):
    """Return the value of the Vim option named `a_option_name' ."""
    return evaluate("&" + a_option_name)


def set_option(a_option_name, a_value):
    """Assign the value `a_value' to the vim option `a_option_name'."""
    if a_value is None or str(a_value) == "":
        execute("let &" + a_option_name + " = \"\"")
    else:
        execute("let &" + a_option_name + " = \"" + str(a_value) + "\"")


def is_prefixed_variable_exists(a_prefix, a_variable_name):
    """Is the Vim variable named `a_variable_name' prefixed with `a_prefix' has
    been define."""
    return int(evaluate(
        "exists(\"" + a_prefix + ":" + a_variable_name + "\")"
    ))


def get_prefixed_variable(a_prefix, a_variable_name):
    """Return the Vim variable named `a_variable_name' and prefixed with
    `a_prefix'."""
    return evaluate(a_prefix + ":" + a_variable_name)


def set_prefixed_variable(a_prefix, a_variable_name, a_value):
    """Assign the value `a_value' to the vim variable
    `a_variable_name' prefixed with `a_prefix'."""
    if a_value is None:
        if is_prefixed_variable_exists(a_prefix, a_variable_name):
            execute("unlet " + a_prefix + ":" + a_variable_name)
    else:
        execute(
            "let " + a_prefix + ":" + a_variable_name + " = \"" +
            str(a_value) + "\""
        )


def is_global_variable_exists(a_variable_name):
    """Is the Vim global variable named `a_variable_name' has been define."""
    return is_prefixed_variable_exists("g", a_variable_name)


def get_global_variable(a_variable_name):
    """Return the Vim global variable named `a_variable_name'."""
    return get_prefixed_variable("g", a_variable_name)


def set_global_variable(a_variable_name, a_value):
    """Assign the value `a_value' to the vim global variable
    `a_variable_name'."""
    set_prefixed_variable("g", a_variable_name, a_value)


def is_argument_variable_exists(a_variable_name):
    """Is the Vim argument variable named `a_variable_name' has been define."""
    return is_prefixed_variable_exists("a", a_variable_name)


def get_argument_variable(a_variable_name):
    """Return the Vim local argument variable named `a_variable_name'."""
    return get_prefixed_variable("g", a_variable_name)


def set_argument_variable(a_variable_name, a_value):
    """Assign the value `a_value' to the vim local argument variable
    `a_variable_name'."""
    set_prefixed_variable("a", a_variable_name, a_value)


def is_script_variable_exists(a_variable_name):
    """Is the Vim script variable named `a_variable_name' has been define."""
    return is_prefixed_variable_exists("s", a_variable_name)


def get_script_variable(a_variable_name):
    """Return the Vim script variable named `a_variable_name'."""
    return get_prefixed_variable("s", a_variable_name)


def set_script_variable(a_variable_name, a_value):
    """Assign the value `a_value' to the vim script variable
    `a_variable_name'."""
    set_prefixed_variable("s", a_variable_name, a_value)


def is_buffer_variable_exists(a_variable_name):
    """Is the Vim buffer variable named `a_variable_name' has been define."""
    return is_prefixed_variable_exists("b", a_variable_name)


def get_buffer_variable(a_variable_name):
    """Return the Vim buffer variable named `a_variable_name'."""
    return get_prefixed_variable("b", a_variable_name)


def set_buffer_variable(a_variable_name, a_value):
    """Assign the value `a_value' to the vim buffer variable
    `a_variable_name'."""
    set_prefixed_variable("b", a_variable_name, a_value)


def word_under_the_cursor():
    non_splittable_characters = string.ascii_letters + string.digits + "_"
    row, col = vim.current.window.cursor
    row = row - 1
    start = col
    end = col + 1
    result = ""
    if len(vim.current.buffer) > row and\
            len(vim.current.buffer[row]) > col and\
            vim.current.buffer[row][col] in non_splittable_characters:
        try:
            while start > -1 and\
                    vim.current.buffer[row][start] in\
                    non_splittable_characters:
                result = vim.current.buffer[row][start] + result
                start = start - 1
        except:
            pass
        try:
            while end < len(vim.current.buffer[row]) and\
                    vim.current.buffer[row][end] in non_splittable_characters:
                result = result + vim.current.buffer[row][end]
                end = end + 1
        except:
            pass
    return result


def buffer_to_text(a_number=None):
    """Get the text contained in a buffer.

        a_number:   The number index of the buffer (if None, use the current
                    buffer.

        Return:     The text of the buffer (each line separate by a \n
    """
    if a_number:
        l_buffer = vim.buffers[int(a_number)]
    else:
        l_buffer = vim.current.buffer
    return "\n".join(l_buffer)


def show_error(message):
    """Print a Vim error `message'."""
    execute("echoerr \"" + message + "\"")


class window:
    """A Vim window."""

    _item = None
    """Internal Vim window represented by `Current'"""

    must_scroll = False
    """`Current' must scroll when the full"""

    def __init__(self, a_number=None, scroll=False):
        """Constructor of the vim window
        Create a python interface of a Vim window. If `a_number' is provided,
        `Current' represent the vim window with that number value. If
        `a_number' is not provided, `Current' represent the currently used
        Vim window.
        """
        if a_number:
            self._item = vim.buffers[int(a_number)]
        else:
            self._item = vim.current.buffer
        self.must_scroll = scroll

    def append(self, a_text):
        """Append `a_text' to `Current'"""
        self._item.append(a_text.split("\n"))
        if self.must_scroll:
            vim.command("normal! G")
        vim.command("redraw")

    def clear(self):
        """Remove all element in `Current'"""
        del self._item[:]
        vim.command("redraw")

    def set_text(self, a_text):
        """Replace the text of `Current' with `a_text'"""
        del self._item[:]
        self.append(a_text)
