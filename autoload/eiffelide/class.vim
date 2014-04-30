" The MIT License (MIT)
"
" Copyright (c) 2014 Louis Marchand
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to
" deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
" FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
" THE SOFTWARE.


python << endpython
def class_execute(a_name, a_routine):
    """Tool routine for all class information functionnalities

    a_name: The name of the functionnality
    a_routine: The lambda routine that get/print information

    Return: None
    """
    if int(vim.eval("a:0")) > 0:
        l_class = vim.eval("a:1")
    else:
        l_class = environment.word_under_the_cursor()
    if l_class:
        l_buffer_number = vim.eval("eiffelide#open_tools_window()")
        vim.command("let b:eiffel_ide_buffer_info = \"Getting " +
                    a_name.lower() + " of " + l_class + "\"")
        vim.command("setlocal filetype=eiffel")
        l_buffer = environment.buffer(l_buffer_number)
        a_routine(l_class, l_buffer)
        vim.command("let b:eiffel_ide_buffer_info = \"" + a_name + " of " +
                    l_class + "\"")
    else:
        print "Class name not valid"
endpython



" DESC: The flat view displays all the features for the current class, i.e. 
" including both written-in and inherited features
function! eiffelide#class#flat(...)
python << endpython
if eiffel_project:
	class_execute("Flat view",\
		lambda a_class, a_buffer:\
			eiffel_project.get_class_flat(a_class, a_buffer)
		)
else:
	print "No Vim Eiffel IDE project opened."
endpython
endfunction

" DESC: The ancestors view displays all the classes from which the current
" class inherits, directly or not, using a tree-like indented layout.
" SEE: https://docs.eiffel.com/book/eiffelstudio/ancestors
function! eiffelide#class#ancestors(...)
python << endpython
if eiffel_project:
	class_execute("Ancestors",\
		lambda a_class, a_buffer:\
			eiffel_project.get_class_ancestors(a_class, a_buffer)
		)
else:
	print "No Vim Eiffel IDE project opened."
endpython
endfunction

" DESC: The attributes view displays all the attributes of the current class,
" including inherited attributes. 
" SEE: https://docs.eiffel.com/book/eiffelstudio/attributes
function! eiffelide#class#attributes(...)
python << endpython
if eiffel_project:
	class_execute("Attributes",\
		lambda a_class, a_buffer:\
			eiffel_project.get_class_attributes(a_class, a_buffer)
		)
else:
	print "No Vim Eiffel IDE project opened."
endpython
endfunction
