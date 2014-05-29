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

def get_class_from_buffer():
	if vim.eval("bufname('%')") ==\
			vim.eval("g:eiffel_tools_buffer_name"):
		l_class = vim.eval("b:eiffel_tools_buffer_class")
	else:
		l_buffer_text = "\n".join(vim.current.buffer)
		l_class = eiffel_project.class_name_from_text(l_buffer_text)
	return l_class

def class_execute(a_name, a_routine):
	"""Tool routine for all class information functionnalities

	a_name: The name of the functionnality
	a_routine: The lambda routine that get/print information

	Return: None
	"""
	if int(vim.eval("a:0")) > 0:
		l_class = vim.eval("a:1")
		if l_class == "%":
			l_class = get_class_from_buffer()
	else:
		l_class = environment.word_under_the_cursor()
		if not l_class:
			l_class = get_class_from_buffer()
	if l_class:
		l_buffer_number = vim.eval("eiffelide#open_tools_window()")
		vim.command("let b:eiffel_tools_buffer_info = \"Getting " +
					a_name.lower() + " of " + l_class + "\"")
		vim.command("setlocal filetype=eiffel")
		l_buffer = environment.window(l_buffer_number, False)
		a_routine(l_class, l_buffer)
		vim.command("let b:eiffel_tools_buffer_info = \"" + a_name + " of " +
					l_class + "\"")
		vim.command("let b:eiffel_tools_buffer_class = \"" + l_class + "\"")
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
			eiffel_project.fetch_class_flat(a_class, a_buffer)
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
			eiffel_project.fetch_class_ancestors(a_class, a_buffer)
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
			eiffel_project.fetch_class_attributes(a_class, a_buffer)
		)
else:
	print "No Vim Eiffel IDE project opened."
endpython
endfunction


" DESC: The clients view displays all the classes which are using features 
" of the current class, and thus rely on its interface.  
" SEE: https://docs.eiffel.com/book/eiffelstudio/clients
function! eiffelide#class#clients(...)
python << endpython
if eiffel_project:
	class_execute("Clients",\
		lambda a_class, a_buffer:\
			eiffel_project.fetch_class_clients(a_class, a_buffer)
		)
else:
	print "No Vim Eiffel IDE project opened."
endpython
endfunction


" DESC: The deferred view displays all the deferred features of a class.
" SEE: https://docs.eiffel.com/book/eiffelstudio/deferred-features
function! eiffelide#class#deferred(...)
python << endpython
if eiffel_project:
	class_execute("Deferred features",\
		lambda a_class, a_buffer:\
			eiffel_project.fetch_class_deferred(a_class, a_buffer)
		)
else:
	print "No Vim Eiffel IDE project opened."
endpython
endfunction


" DESC: The descendants view displays all the classes which inherit from the 
" current class,directly or not, using a tree-like indented layout.
" SEE: https://docs.eiffel.com/book/eiffelstudio/descendants
function! eiffelide#class#descendants(...)
python << endpython
if eiffel_project:
	class_execute("Descendants",\
		lambda a_class, a_buffer:\
			eiffel_project.fetch_class_descendants(a_class, a_buffer)
		)
else:
	print "No Vim Eiffel IDE project opened."
endpython
endfunction


" DESC: The exported view displays all the features of the current class that 
" all other classes may call.
" SEE: https://docs.eiffel.com/book/eiffelstudio/exported-features
function! eiffelide#class#exported(...)
python << endpython
if eiffel_project:
	class_execute("Exported features",\
		lambda a_class, a_buffer:\
			eiffel_project.fetch_class_exported(a_class, a_buffer)
		)
else:
	print "No Vim Eiffel IDE project opened."
endpython
endfunction


" DESC: The external view displays all the external features of the current 
" class.
" SEE: https://docs.eiffel.com/book/eiffelstudio/class-formatters-external-features
function! eiffelide#class#externals(...)
python << endpython
if eiffel_project:
	class_execute("External features",\
		lambda a_class, a_buffer:\
			eiffel_project.fetch_class_externals(a_class, a_buffer)
		)
else:
	print "No Vim Eiffel IDE project opened."
endpython
endfunction


" DESC: The Flat Contract view displays the contracts of all written-in and 
" inherited features of the current class.
" SEE: https://docs.eiffel.com/book/eiffelstudio/flat-contract-view
function! eiffelide#class#flatshort(...)
python << endpython
if eiffel_project:
	class_execute("Flat contract view",\
		lambda a_class, a_buffer:\
			eiffel_project.fetch_class_flatshort(a_class, a_buffer)
		)
else:
	print "No Vim Eiffel IDE project opened."
endpython
endfunction


" DESC: The once view displays all the routines declared as once and the 
" constant attributes in the current class (or in its ancestors).
" SEE: https://docs.eiffel.com/book/eiffelstudio/once-routines-and-constants
function! eiffelide#class#once(...)
python << endpython
if eiffel_project:
	class_execute("Once features",\
		lambda a_class, a_buffer:\
			eiffel_project.fetch_class_once(a_class, a_buffer)
		)
else:
	print "No Vim Eiffel IDE project opened."
endpython
endfunction

" DESC: The invariants view displays all the invariants of the current class.
" SEE: https://docs.eiffel.com/book/eiffelstudio/invariants
function! eiffelide#class#invariants(...)
python << endpython
if eiffel_project:
	class_execute("Invariants",\
		lambda a_class, a_buffer:\
			eiffel_project.fetch_class_invariants(a_class, a_buffer)
		)
else:
	print "No Vim Eiffel IDE project opened."
endpython
endfunction

" DESC: The routines view displays all the routine signatures of the current 
" class, including inherited routines.
" SEE: https://docs.eiffel.com/book/eiffelstudio/routines
function! eiffelide#class#routines(...)
python << endpython
if eiffel_project:
	class_execute("Routines",\
		lambda a_class, a_buffer:\
			eiffel_project.fetch_class_routines(a_class, a_buffer)
		)
else:
	print "No Vim Eiffel IDE project opened."
endpython
endfunction

" DESC: The creators view displays all the creation procedure signatures of
" the current class.
" SEE: https://docs.eiffel.com/book/eiffelstudio/creators
function! eiffelide#class#creators(...)
python << endpython
if eiffel_project:
	class_execute("Creators",\
		lambda a_class, a_buffer:\
			eiffel_project.fetch_class_creators(a_class, a_buffer)
		)
else:
	print "No Vim Eiffel IDE project opened."
endpython
endfunction

" DESC: The contract view displays the contracts of all written-in features of
" the current class.
" SEE: https://docs.eiffel.com/book/eiffelstudio/contract-view
function! eiffelide#class#short(...)
python << endpython
if eiffel_project:
	class_execute("Contract View",\
		lambda a_class, a_buffer:\
			eiffel_project.fetch_class_short(a_class, a_buffer)
		)
else:
	print "No Vim Eiffel IDE project opened."
endpython
endfunction

" DESC: The suppliers view displays all the classes from which the current
" class is calling features.
" SEE: https://docs.eiffel.com/book/eiffelstudio/suppliers
function! eiffelide#class#suppliers(...)
python << endpython
if eiffel_project:
	class_execute("Suppliers",\
		lambda a_class, a_buffer:\
			eiffel_project.fetch_class_suppliers(a_class, a_buffer)
		)
else:
	print "No Vim Eiffel IDE project opened."
endpython
endfunction

" DESC: Show the original text source code of the class.
" SEE: https://docs.eiffel.com/book/eiffelstudio/class-formatters-basic-text-view
function! eiffelide#class#text(...)
python << endpython
if eiffel_project:
	class_execute("Text View",\
		lambda a_class, a_buffer:\
			eiffel_project.fetch_class_text(a_class, a_buffer)
		)
else:
	print "No Vim Eiffel IDE project opened."
endpython
endfunction

