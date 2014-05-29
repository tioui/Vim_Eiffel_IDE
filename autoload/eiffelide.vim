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


" DESC: Redefine to change the path to the EiffelStudio (EC) compiler.
if !exists("g:eiffelstudio_compiler")
    let g:eiffelstudio_compiler = "ec"
endif

" DESC: Redefine to change the root directory of the Vim_Eiffel_IDE folder.
if !exists("g:eiffel_plugin_root")
    let g:eiffel_plugin_root= expand('<sfile>:p:h:h')
endif

" DESC: Redefine to change the Eiffel IDE Tools buffer name
if !exists("g:eiffel_tools_buffer_name")
    let g:eiffel_tools_buffer_name = "__eiffel_IDE_tools__"
endif

" DESC: Redefine to change the default Eiffel IDE tools window height or width.
if !exists("g:eiffel_tools_window_dimension")
    let g:eiffel_tools_window_dimension = 10
endif

" DESC: Redefine to put the Eiffel IDE tools above (or left) of the current window
" SEE: `g:eiffel_tools_window_vertical'
if !exists("g:eiffel_tools_window_leftabove")
    let g:eiffel_tools_window_leftabove= 0
endif

" DESC: Redefine to put the Eiffel IDE tools à the right (or left) or the
" current window
" SEE: `g:eiffel_tools_window_leftabove'
if !exists("g:eiffel_tools_window_vertical")
    let g:eiffel_tools_window_vertical = 0
endif

" DESC: Redefine to put the Eiffel IDE tools à the right (or left) or the
" current window
" SEE: `g:eiffel_tools_window_leftabove'
if !exists("g:eiffel_tools_window_statusline")
	let status_line = "%f%m%r%h%w%q%=[%l,%v][%p%%]"
	if &statusline !=# ''
		let status_line = &statusline
	endif
	let status_line = substitute(status_line,"%f","%{exists('b:eiffel_tools_buffer_info')?(b:eiffel_tools_buffer_info):bufname('%')}","")
	let status_line = substitute(status_line,"%F","%{exists('b:eiffel_tools_buffer_info')?(b:eiffel_tools_buffer_info):fnamemodify(bufname('%'), ':p')}","")
    let g:eiffel_tools_window_statusline = status_line
endif

let &statusline = g:eiffel_tools_window_statusline




" DESC: Python environment initialisation
python import sys, vim

python sys.path.insert(0, vim.eval('g:eiffel_plugin_root')+"/pyplugin")

python import eiffelproject, environment, eiffelide, eiffelcompilation

" DESC: The Eiffel Project python object
" SEE: `project' class in pyplugin/eiffelide.py 
python eiffel_project = None




" ========================== Compilation commands============================

" DESC: Command shortcuts for a simple speedy compilation
command! EiffelCompile python eiffelcompilation.quick_melt_no_focus(eiffel_project)

command! ECompile EiffelCompile 

command! EC EiffelCompile 

" DESC: Command shortcuts for a 'Recompile from scratch' compilation
command! EiffelRecompile python eiffelcompilation.recompile(eiffel_project)

command! ERecompile EiffelRecompile 

" DESC: Command shortcuts for a 'Finalize' compilation.
command! EiffelFinalize python eiffelcompilation.finalize(eiffel_project)

command! EFinalize EiffelFinalize 

" DESC: Command shortcuts for a 'Freeze' compilation.
" SEE: http://docs.eiffel.com/book/eiffelstudio/melting-ice-technology
command! EiffelFreeze python eiffelcompilation.freeze(eiffel_project)

command! EFreeze EiffelFreeze 

" DESC: Command shortcut for a 'Melting' compilation
" SEE: http://docs.eiffel.com/book/eiffelstudio/melting-ice-technology
command! EiffelMelt python eiffelcompilation.melt(eiffel_project)

command! EMelt EiffelMelt

" DESC: Command shortcut for a 'Quick Melting' compilation
command! EiffelQuickMelt python eiffelcompilation.quick_melt(eiffel_project)

command! EQuickMelt EiffelQuickMelt

" DESC: Command shortcuts for Eiffel project information.
command! EiffelProject echom eiffelide#config_file()

command! EProject EiffelProject

command! EiffelTarget echom eiffelide#target_name()

command! ETarget EiffelTarget

" ====================== Class informations commands ========================

" DESC: Class Flat View
command! -nargs=* EiffelClassFlat call eiffelide#class#flat(<f-args>)

command! -nargs=* ECFlat call eiffelide#class#flat(<f-args>)

" DESC: Class Ancestors
command! -nargs=* EiffelClassAncestors call eiffelide#class#ancestors(<f-args>)

command! -nargs=* ECAncestors call eiffelide#class#ancestors(<f-args>)

" DESC: Class Attributes
command! -nargs=* EiffelClassAttributes call eiffelide#class#attributes(<f-args>)

command! -nargs=* ECAttributes call eiffelide#class#attributes(<f-args>)

" DESC: Class Clients
command! -nargs=* EiffelClassClients call eiffelide#class#clients(<f-args>)

command! -nargs=* ECClients call eiffelide#class#clients(<f-args>)

" DESC: Class Deferred features
command! -nargs=* EiffelClassDeferred call eiffelide#class#deferred(<f-args>)

command! -nargs=* ECDeferred call eiffelide#class#deferred(<f-args>)

" DESC: Class Descendants
command! -nargs=* EiffelClassDescendants call eiffelide#class#descendants(<f-args>)

command! -nargs=* ECDescendants call eiffelide#class#descendants(<f-args>)

" DESC: Class Exported features
command! -nargs=* EiffelClassExported call eiffelide#class#exported(<f-args>)

command! -nargs=* ECExported call eiffelide#class#exported(<f-args>)

" DESC: Class External features
command! -nargs=* EiffelClassExternals call eiffelide#class#externals(<f-args>)

command! -nargs=* ECExternals call eiffelide#class#externals(<f-args>)

" DESC: Class Flat contract view
command! -nargs=* EiffelClassFlatShort call eiffelide#class#flatshort(<f-args>)

command! -nargs=* ECFlatShort call eiffelide#class#flatshort(<f-args>)

command! -nargs=* EiffelClassFlatContract call eiffelide#class#flatshort(<f-args>)

command! -nargs=* ECFlatContract call eiffelide#class#flatshort(<f-args>)

" DESC: Class Once features
command! -nargs=* EiffelClassOnce call eiffelide#class#once(<f-args>)

command! -nargs=* ECOnce call eiffelide#class#once(<f-args>)

" DESC: Class Invariants
command! -nargs=* EiffelClassInvariants call eiffelide#class#invariants(<f-args>)

command! -nargs=* ECInvariants call eiffelide#class#invariants(<f-args>)

" DESC: Class Routines
command! -nargs=* EiffelClassRoutines call eiffelide#class#routines(<f-args>)

command! -nargs=* ECRoutines call eiffelide#class#routines(<f-args>)

" DESC: Class Creators
command! -nargs=* EiffelClassCreators call eiffelide#class#creators(<f-args>)

command! -nargs=* ECCreators call eiffelide#class#creators(<f-args>)

" DESC: Class Short View
command! -nargs=* EiffelClassShort call eiffelide#class#short(<f-args>)

command! -nargs=* ECShort call eiffelide#class#short(<f-args>)

command! -nargs=* EiffelClassContract call eiffelide#class#short(<f-args>)

command! -nargs=* ECContract call eiffelide#class#short(<f-args>)

" DESC: Class Suppliers
command! -nargs=* EiffelClassSuppliers call eiffelide#class#suppliers(<f-args>)

command! -nargs=* ECSuppliers call eiffelide#class#suppliers(<f-args>)

" DESC: Class Text
command! -nargs=* EiffelClassText call eiffelide#class#text(<f-args>)

command! -nargs=* ECText call eiffelide#class#text(<f-args>)


" ============================ Others commands ==============================

" DESC: Run and Debug
command! EiffelRun python eiffelide.run_project(eiffel_project)

command! ERun EiffelRun

" ============================ Common routines ============================


" DESC: Use the `g:saved_window_number' value to go to preceding window
" SEE: `eiffelide#open_tools_window()'
" NOTE: To be remove, do not use
function! eiffelide#return_to_saved_window()
	python eiffelide.select_saved_window()
endfunction

" DESC: If it does not exist, create the Eiffel IDE tools buffer, show it in
" a window, save the number of the current selected window in
" `g:saved_window_number' and return the Eiffel IDE tools buffer number.
" SEE: `eiffelide#return_to_saved_window()'
function! eiffelide#open_tools_window()
	python eiffelide.save_current_window_and_open_tools_window()
	python vim.command("return '" + str(eiffelide.get_tools_buffer_number()) + "'")
endfunction


" DESC: Open an Eiffel Project. The first optionnal argument is the Eiffel 
" project (.ecf) file. The second optionnal argument is the project target.
" SEE: `eiffel_project'
function! eiffelide#open(...)
    if a:0 ># 0
		if a:1 ==# "%"
			let config_file = fnamemodify(bufname("%"), ':p')
		else
			let config_file = fnamemodify(a:1,':p')
		endif
    else
		let config_file = fnamemodify(bufname("%"), ':p')
    endif
    echom "Opening Vim Eiffel IDE."
    if a:0 ># 1
		python eiffel_project = eiffelproject.project(vim.eval('config_file'),vim.eval('a:2'))
    else
		python eiffel_project = eiffelproject.project(vim.eval('config_file'))
    endif
	EiffelQuickMelt
endfunction

" DESC: Open an Eiffel Project. The first optionnal argument is the Eiffel 
" project (.ecf) file. The second optionnal argument is the project target.
" SEE: `eiffelide#open()' and `eiffel_project'
function! eiffelide#open_target(target)
    call eiffelide#open(fnamemodify(bufname("%"), ':p'), a:target)
endfunction

" DESC: Return the config file name of the openned `eiffel_project'
function! eiffelide#config_file()
python << endpython
if eiffel_project:
    vim.command("return '" + eiffel_project.config_file() + "'")
else:
    print "No Vim Eiffel IDE project opened."
endpython
endfunction

" DESC: Return the target name of the openned `eiffel_project' (if any).
function! eiffelide#target_name()
python << endpython
if eiffel_project:
    if eiffel_project.target_name():
	vim.command("return '" + eiffel_project.target_name() + "'")
    else:
	vim.command("return ''")
else:
    print "No Vim Eiffel IDE project opened."
endpython
endfunction

" DESC: Return the project path of the openned `eiffel_project' (if any).
function! eiffelide#project_path()
python << endpython
if eiffel_project:
    if eiffel_project.config_file_path():
	vim.command("return '" + eiffel_project.config_file_path() + "'")
    else:
	vim.command("return ''")
else:
    print "No Vim Eiffel IDE project opened."
endpython
endfunction

" DESC: Return True if the last compilation was a success.
function! eiffelide#is_success()
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
