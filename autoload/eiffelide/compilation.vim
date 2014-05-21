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

" DESC: Run a compilation from scratch of the openned `eiffel_project'
function! eiffelide#compilation#recompile()
python << endpython
if eiffel_project:
	l_buffer_number = vim.eval("eiffelide#open_tools_window()")
	vim.command("let b:eiffel_ide_buffer_info = \"Compiling...\"")
	l_buffer = environment.window(l_buffer_number,True)
	eiffel_project.recompile(l_buffer)
	vim.command("let b:eiffel_ide_buffer_info = \"Compilation output\"")
	if not eiffel_project.has_error():
		vim.command("call eiffelide#return_to_saved_window()")
else:
	print "No Vim Eiffel IDE project opened."
endpython
endfunction

" DESC: Run a 'Freezing' compilation of the openned `eiffel_project'
" SEE: http://docs.eiffel.com/book/eiffelstudio/melting-ice-technology 
function! eiffelide#compilation#freeze()
python << endpython
if eiffel_project:
	l_buffer_number = vim.eval("eiffelide#open_tools_window()")
	vim.command("let b:eiffel_ide_buffer_info = \"Freezing...\"")
	l_buffer = environment.window(l_buffer_number,True)
	eiffel_project.freeze(l_buffer)
	vim.command("let b:eiffel_ide_buffer_info = \"Freeze output\"")
	if not eiffel_project.has_error():
		vim.command("call eiffelide#return_to_saved_window()")
else:
	print "No Vim Eiffel IDE project opened."
endpython
endfunction

" DESC: Run a 'Melting' compilation of the openned `eiffel_project'
" SEE: http://docs.eiffel.com/book/eiffelstudio/melting-ice-technology
function! eiffelide#compilation#melt()
python << endpython
if eiffel_project:
	l_buffer_number = vim.eval("eiffelide#open_tools_window()")
	vim.command("let b:eiffel_ide_buffer_info = \"Melting...\"")
	l_buffer = environment.window(l_buffer_number,True)
	eiffel_project.melt(l_buffer)
	vim.command("let b:eiffel_ide_buffer_info = \"Melt output\"")
	if not eiffel_project.has_error():
		vim.command("call eiffelide#return_to_saved_window()")
else:
	print "No Vim Eiffel IDE project opened."
endpython
endfunction

" DESC: Run a 'Finilize' compilation of the openned `eiffel_project'
function! eiffelide#compilation#finalize()
python << endpython
if eiffel_project:
	l_buffer_number = vim.eval("eiffelide#open_tools_window()")
	vim.command("let b:eiffel_ide_buffer_info = \"Finalizing...\"")
	l_buffer = environment.window(l_buffer_number,True)
	eiffel_project.finalize(l_buffer)
	vim.command("let b:eiffel_ide_buffer_info = \"Finalize output\"")
	if not eiffel_project.has_error():
		vim.command("call eiffelide#return_to_saved_window()")
else:
	print "No Vim Eiffel IDE project opened."
endpython
endfunction

" DESC: Run a 'Quick Melting' compilation of the openned `eiffel_project'
" SEE: http://docs.eiffel.com/book/eiffelstudio/melting-ice-technology
function! eiffelide#compilation#quick_melt()
python << endpython
if eiffel_project:
	l_buffer_number = vim.eval("eiffelide#open_tools_window()")
	vim.command("let b:eiffel_ide_buffer_info = \"Quick melting...\"")
	l_buffer = environment.window(l_buffer_number,True)
	eiffel_project.quick_melt(l_buffer)
	vim.command("let b:eiffel_ide_buffer_info = \"Quick melt output\"")
	if not eiffel_project.has_error():
		vim.command("call eiffelide#return_to_saved_window()")
else:
	print "No Vim Eiffel IDE project opened."
endpython
endfunction

" DESC: Run a 'Quick Melting' compilation of the openned `eiffel_project' and
" even if there is error, do not put the focus in the Eiffel IDE tools
" buffer window.
" SEE: http://docs.eiffel.com/book/eiffelstudio/melting-ice-technology
function! eiffelide#compilation#quick_melt_no_focus()
python << endpython
if eiffel_project:
	l_buffer_number = vim.eval("eiffelide#open_tools_window()")
	vim.command("let b:eiffel_ide_buffer_info = \"Compiling...\"")
	l_buffer = environment.window(l_buffer_number,True)
	eiffel_project.quick_melt(l_buffer)
	vim.command("let b:eiffel_ide_buffer_info = \"Compilation output\"")
	vim.command("call eiffelide#return_to_saved_window()")
else:
	print "No Vim Eiffel IDE project opened."
endpython
endfunction

" DESC: Return True if the last compilation was a success.
function! eiffelide#compilation#is_success()
	let result = 0
python << endpython
if eiffel_project:
	if eiffel_project.has_error():
		vim.command("let result = 0")
	else:
		vim.command("let result = 1")
else:
	print "No Vim Eiffel IDE project opened."
endpython
	return result
endfunction
