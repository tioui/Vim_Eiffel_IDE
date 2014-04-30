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


def get_global_variable(a_variable_name):
    """Return the Vim global variable named `a_variable_name'."""
    return vim.eval("g:" + a_variable_name)


def set_global_variable(a_variable_name, a_value):
    """Assign the value `a_value' to the vim global variable
    `a_variable_name'."""
    if a_value is None or str(a_value) == "":
        vim.command("let g:" + a_variable_name + " = \"\"")
    else:
        vim.command("let g:" + a_variable_name + " = " + str(a_value))


def get_argument_variable(a_variable_name):
    """Return the Vim local argument variable named `a_variable_name'."""
    return vim.eval("a:" + a_variable_name)


def set_argument_variable(a_variable_name, a_value):
    """Assign the value `a_value' to the vim local argument variable
    `a_variable_name'."""
    if a_value is None or str(a_value) == "":
        vim.command("let a:" + a_variable_name + " = \"\"")
    else:
        vim.command("let a:" + a_variable_name + " = " + str(a_value))


def get_script_variable(a_variable_name):
    """Return the Vim script variable named `a_variable_name'."""
    return vim.eval("s:" + a_variable_name)


def set_script_variable(a_variable_name, a_value):
    """Assign the value `a_value' to the vim script variable
    `a_variable_name'."""
    if a_value is None or str(a_value) == "":
        vim.command("let s:" + a_variable_name + " = \"\"")
    else:
        vim.command("let s:" + a_variable_name + " = " + str(a_value))


def get_buffer_variable(a_variable_name):
    """Return the Vim buffer variable named `a_variable_name'."""
    return vim.eval("b:" + a_variable_name)


def set_buffer_variable(a_variable_name, a_value):
    """Assign the value `a_value' to the vim buffer variable
    `a_variable_name'."""
    if a_value is None or str(a_value) == "":
        vim.command("let b:" + a_variable_name + " = \"\"")
    else:
        vim.command("let b:" + a_variable_name + " = " + str(a_value))


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


class buffer:
    """A Vim buffer."""

    _item = None
    """Internal Vim buffer represented by `Current'"""

    def __init__(self, a_number=None):
        """Constructor of the vim buffer
        Create a python interface of a Vim buffer. If `a_number' is provided,
        `Current' represent the vim buffer with that number value. If
        `a_number' is not provided, `Current' represent the currently used
        Vim buffer.
        """
        if a_number:
            self._item = vim.buffers[int(a_number)]
        else:
            self._item = vim.current.buffer

    def append(self, a_text):
        """Append `a_text' to `Current'"""
        self._item.append(a_text.split("\n"))
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
