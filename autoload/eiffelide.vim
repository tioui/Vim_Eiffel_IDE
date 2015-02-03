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

" DESC: Prefix to use the run command. If you want to run it in another
" terminal in or in a Conque window or the default, directly in vim (!)
if !exists("g:eiffel_run_prefix")
    let g:eiffel_run_prefix = "!"
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

" Initialize the Omnicomplete system
let g:eiffel_complete_is_class = 0
execute "set omnifunc=eiffelide#CompleteEiffel"
autocmd CompleteDone * call eiffelide#EndCompletion()
" To map a shortcut for Class completion, use the following line
" (just change the <C-G>)
inoremap <C-G> <esc>:call eiffelide#StartClassCompletion()<cr>



" DESC: Python environment initialisation
python import sys, vim

python sys.path.insert(0, vim.eval('g:eiffel_plugin_root')+"/pyplugin")

python import eiffel_project, eiffel_ide, eiffel_compilation, eiffel_class
python import eiffel_feature

" DESC: The Eiffel Project python object
" SEE: `project' class in pyplugin/eiffel_ide.py 
python i_eiffel_project = None




" ========================== Compilation commands============================

" DESC: Command shortcuts for a simple speedy compilation
command! EiffelCompile python eiffel_compilation.quick_melt_no_focus(i_eiffel_project)

command! ECompile EiffelCompile 

command! EC EiffelCompile 

" DESC: Command shortcuts for a 'Recompile from scratch' compilation
command! EiffelRecompile python eiffel_compilation.recompile(i_eiffel_project)

command! ERecompile EiffelRecompile 

" DESC: Command shortcuts for a 'Finalize' compilation.
command! EiffelFinalize python eiffel_compilation.finalize(i_eiffel_project)

command! EFinalize EiffelFinalize 

" DESC: Command shortcuts for a 'Freeze' compilation.
" SEE: http://docs.eiffel.com/book/eiffelstudio/melting-ice-technology
command! EiffelFreeze python eiffel_compilation.freeze(i_eiffel_project)

command! EFreeze EiffelFreeze 

" DESC: Command shortcut for a 'Melting' compilation
" SEE: http://docs.eiffel.com/book/eiffelstudio/melting-ice-technology
command! EiffelMelt python eiffel_compilation.melt(i_eiffel_project)

command! EMelt EiffelMelt

" DESC: Command shortcut for a 'Quick Melting' compilation
command! EiffelQuickMelt python eiffel_compilation.quick_melt(i_eiffel_project)

command! EQuickMelt EiffelQuickMelt

" DESC: Command shortcuts for Eiffel project information.
command! EiffelProject echom eiffelide#config_file()

command! EProject EiffelProject

command! EiffelTarget echom eiffelide#target_name()

command! ETarget EiffelTarget

" ====================== Class informations commands ========================

" DESC: Class Flat View
command! -nargs=* EiffelClassFlat python eiffel_class.flat(i_eiffel_project,<f-args>)

command! -nargs=* ECFlat python eiffel_class.flat(i_eiffel_project,<f-args>)

" DESC: Class Ancestors
command! -nargs=* EiffelClassAncestors python eiffel_class.ancestors(i_eiffel_project,<f-args>)

command! -nargs=* ECAncestors python eiffel_class.ancestors(i_eiffel_project,<f-args>)

" DESC: Class Attributes
command! -nargs=* EiffelClassAttributes python eiffel_class.attributes(i_eiffel_project,<f-args>)

command! -nargs=* ECAttributes python eiffel_class.attributes(i_eiffel_project,<f-args>)

" DESC: Class Clients
command! -nargs=* EiffelClassClients python eiffel_class.clients(i_eiffel_project,<f-args>)

command! -nargs=* ECClients python eiffel_class.clients(i_eiffel_project,<f-args>)

" DESC: Class Deferred features
command! -nargs=* EiffelClassDeferred python eiffel_class.deferred(i_eiffel_project,<f-args>)

command! -nargs=* ECDeferred python eiffel_class.deferred(i_eiffel_project,<f-args>)

" DESC: Class Descendants
command! -nargs=* EiffelClassDescendants python eiffel_class.descendants(i_eiffel_project,<f-args>)

command! -nargs=* ECDescendants python eiffel_class.descendants(i_eiffel_project,<f-args>)

" DESC: Class Exported features
command! -nargs=* EiffelClassExported python eiffel_class.exported(i_eiffel_project,<f-args>)

command! -nargs=* ECExported python eiffel_class.exported(i_eiffel_project,<f-args>)

" DESC: Class External features
command! -nargs=* EiffelClassExternals python eiffel_class.externals(i_eiffel_project,<f-args>)

command! -nargs=* ECExternals python eiffel_class.externals(i_eiffel_project,<f-args>)

" DESC: Class Flat contract view
command! -nargs=* EiffelClassFlatShort python eiffel_class.flatshort(i_eiffel_project,<f-args>)

command! -nargs=* ECFlatShort python eiffel_class.flatshort(i_eiffel_project,<f-args>)

command! -nargs=* EiffelClassFlatContract python eiffel_class.flatshort(i_eiffel_project,<f-args>)

command! -nargs=* ECFlatContract python eiffel_class.flatshort(i_eiffel_project,<f-args>)

" DESC: Class Once features
command! -nargs=* EiffelClassOnce python eiffel_class.once(i_eiffel_project,<f-args>)

command! -nargs=* ECOnce python eiffel_class.once(i_eiffel_project,<f-args>)

" DESC: Class Invariants
command! -nargs=* EiffelClassInvariants python eiffel_class.invariants(i_eiffel_project,<f-args>)

command! -nargs=* ECInvariants python eiffel_class.invariants(i_eiffel_project,<f-args>)

" DESC: Class Routines
command! -nargs=* EiffelClassRoutines python eiffel_class.routines(i_eiffel_project,<f-args>)

command! -nargs=* ECRoutines python eiffel_class.routines(i_eiffel_project,<f-args>)

" DESC: Class Creators
command! -nargs=* EiffelClassCreators python eiffel_class.creators(i_eiffel_project,<f-args>)

command! -nargs=* ECCreators python eiffel_class.creators(i_eiffel_project,<f-args>)

" DESC: Class Short View
command! -nargs=* EiffelClassShort python eiffel_class.short(i_eiffel_project,<f-args>)

command! -nargs=* ECShort python eiffel_class.short(i_eiffel_project,<f-args>)

command! -nargs=* EiffelClassContract python eiffel_class.short(i_eiffel_project,<f-args>)

command! -nargs=* ECContract python eiffel_class.short(i_eiffel_project,<f-args>)

" DESC: Class Suppliers
command! -nargs=* EiffelClassSuppliers python eiffel_class.suppliers(i_eiffel_project,<f-args>)

command! -nargs=* ECSuppliers python eiffel_class.suppliers(i_eiffel_project,<f-args>)

" DESC: Class Text
command! -nargs=* EiffelClassText python eiffel_class.text(i_eiffel_project,<f-args>)

command! -nargs=* ECText python eiffel_class.text(i_eiffel_project,<f-args>)

" DESC: Edit class
command! -nargs=* EiffelClassEdit python eiffel_class.edit(i_eiffel_project, False, False, False, False, <f-args>)

command! -nargs=* ECEdit python eiffel_class.edit(i_eiffel_project, False, False, False, False, <f-args>)

" DESC: Edit class force close
command! -nargs=* EiffelClassEditF python eiffel_class.edit(i_eiffel_project, False, False, False, True, <f-args>)

command! -nargs=* ECEditF python eiffel_class.edit(i_eiffel_project, False, False, False, True, <f-args>)

" DESC: Edit class in new window (split)
command! -nargs=* EiffelClassEditSplit python eiffel_class.edit(i_eiffel_project, True, False, False, False, <f-args>)

command! -nargs=* ECEditSp python eiffel_class.edit(i_eiffel_project, True, False, False, False, <f-args>)

" DESC: Edit class in new window (vertical split)
command! -nargs=* EiffelClassEditVSplit python eiffel_class.edit(i_eiffel_project, True, True, False, False, <f-args>)

command! -nargs=* ECEditVSp python eiffel_class.edit(i_eiffel_project, True, True, False, False, <f-args>)

" DESC: Edit class in a new tab
command! -nargs=* EiffelClassEditTab python eiffel_class.edit(i_eiffel_project, False, False, True, False, <f-args>)

command! -nargs=* ECEditTab python eiffel_class.edit(i_eiffel_project, False, False, True, False, <f-args>)


" ====================== Feature informations commands =======================

" DESC: Feature Ancestors
command! -nargs=* EiffelFeatureAncestors python eiffel_feature.ancestors(i_eiffel_project,<f-args>)

command! -nargs=* EFAncestors python eiffel_feature.ancestors(i_eiffel_project,<f-args>)

" DESC: Feature Callers
command! -nargs=* EiffelFeatureCallers python eiffel_feature.callers(i_eiffel_project,<f-args>)

command! -nargs=* EFCallers python eiffel_feature.callers(i_eiffel_project,<f-args>)

" DESC: Feature Creators
command! -nargs=* EiffelFeatureCreators python eiffel_feature.creators(i_eiffel_project,<f-args>)

command! -nargs=* EFCreators python eiffel_feature.creators(i_eiffel_project,<f-args>)

" DESC: Feature Assigners
command! -nargs=* EiffelFeatureAssigners python eiffel_feature.assigners(i_eiffel_project,<f-args>)

command! -nargs=* EFAssigners python eiffel_feature.assigners(i_eiffel_project,<f-args>)

" DESC: Feature Callees
command! -nargs=* EiffelFeatureCallees python eiffel_feature.callees(i_eiffel_project,<f-args>)

command! -nargs=* EFCallees python eiffel_feature.callees(i_eiffel_project,<f-args>)

" DESC: Feature Creations
command! -nargs=* EiffelFeatureCreations python eiffel_feature.creations(i_eiffel_project,<f-args>)

command! -nargs=* EFCreations python eiffel_feature.creations(i_eiffel_project,<f-args>)

" DESC: Feature Assignees
command! -nargs=* EiffelFeatureAssignees python eiffel_feature.assignees(i_eiffel_project,<f-args>)

command! -nargs=* EFAssignees python eiffel_feature.assignees(i_eiffel_project,<f-args>)

" DESC: Feature Descendants
command! -nargs=* EiffelFeatureDescendants python eiffel_feature.descendants(i_eiffel_project,<f-args>)

command! -nargs=* EFDescendants python eiffel_feature.descendants(i_eiffel_project,<f-args>)

" DESC: Feature Flat
command! -nargs=* EiffelFeatureFlat python eiffel_feature.flat(i_eiffel_project,<f-args>)

command! -nargs=* EFFlat python eiffel_feature.flat(i_eiffel_project,<f-args>)

" DESC: Feature Homonyms
command! -nargs=* EiffelFeatureHomonyms python eiffel_feature.homonyms(i_eiffel_project,<f-args>)

command! -nargs=* EFHomonyms python eiffel_feature.homonyms(i_eiffel_project,<f-args>)

" DESC: Feature Implementers
command! -nargs=* EiffelFeatureImplementers python eiffel_feature.implementers(i_eiffel_project,<f-args>)

command! -nargs=* EFImplementers python eiffel_feature.implementers(i_eiffel_project,<f-args>)

" DESC: Feature Text
command! -nargs=* EiffelFeatureText python eiffel_feature.text(i_eiffel_project,<f-args>)

command! -nargs=* EFText python eiffel_feature.text(i_eiffel_project,<f-args>)


" ============================ Others commands ==============================

" DESC: Run and Debug
command! EiffelRun python eiffel_ide.run_project(i_eiffel_project)

command! ERun EiffelRun

" ============================ Common routines ============================


" DESC: Use the `g:saved_window_number' value to go to preceding window
" SEE: `eiffelide#open_tools_window()'
" NOTE: To be remove, do not use
function! eiffelide#return_to_saved_window()
	python eiffel_ide.select_saved_window()
endfunction

" DESC: If it does not exist, create the Eiffel IDE tools buffer, show it in
" a window, save the number of the current selected window in
" `g:saved_window_number' and return the Eiffel IDE tools buffer number.
" SEE: `eiffelide#return_to_saved_window()'
function! eiffelide#open_tools_window()
	python eiffel_ide.save_current_window_and_open_tools_window()
	python vim.command("return '" + str(eiffel_ide.get_tools_buffer_number()) + "'")
endfunction


" DESC: Open an Eiffel Project. The first optionnal argument is the Eiffel 
" project (.ecf) file. The second optionnal argument is the project target.
" SEE: `i_eiffel_project'
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
		python i_eiffel_project = eiffel_project.project(vim.eval('config_file'),vim.eval('a:2'))
    else
		python i_eiffel_project = eiffel_project.project(vim.eval('config_file'))
    endif
	EiffelQuickMelt
endfunction

" DESC: Open an Eiffel Project. The first optionnal argument is the Eiffel 
" project (.ecf) file. The second optionnal argument is the project target.
" SEE: `eiffelide#open()' and `i_eiffel_project'
function! eiffelide#open_target(target)
    call eiffelide#open(fnamemodify(bufname("%"), ':p'), a:target)
endfunction

" DESC: Return the config file name of the openned `i_eiffel_project'
function! eiffelide#config_file()
python << endpython
if i_eiffel_project:
    vim.command("return '" + i_eiffel_project.config_file() + "'")
else:
    print "No Vim Eiffel IDE project opened."
endpython
endfunction

" DESC: Return the target name of the openned `i_eiffel_project' (if any).
function! eiffelide#target_name()
python << endpython
if i_eiffel_project:
    if i_eiffel_project.target_name():
	vim.command("return '" + i_eiffel_project.target_name() + "'")
    else:
	vim.command("return ''")
else:
    print "No Vim Eiffel IDE project opened."
endpython
endfunction

" DESC: Return the project path of the openned `i_eiffel_project' (if any).
function! eiffelide#project_path()
python << endpython
if i_eiffel_project:
    if i_eiffel_project.config_file_path():
	vim.command("return '" + i_eiffel_project.config_file_path() + "'")
    else:
	vim.command("return ''")
else:
    print "No Vim Eiffel IDE project opened."
endpython
endfunction

" DESC: Return True if the last compilation was a success.
function! eiffelide#is_compilation_success()
	let result = 0
python << endpython
if i_eiffel_project:
	if i_eiffel_project.has_error():
		vim.command("let result = 0")
	else:
		vim.command("let result = 1")
else:
	print "No Vim Eiffel IDE project opened."
endpython
	return result
endfunction


" DESC: Used to activate completion for classes
function! eiffelide#StartClassCompletion()
	let g:eiffel_complete_is_class = 1
	call feedkeys("a\<c-x>\<c-o>") 
endfunction

" DESC: Used to activate completion for classes
function! eiffelide#EndCompletion()
	if g:eiffel_complete_is_class
		let g:eiffel_complete_is_class = 0
	endif
endfunction


" DESC: Used for Auto-Completion system. See `:help complete-function'
function! eiffelide#CompleteEiffel(findstart, base)
	echom a:base
	if g:eiffel_complete_is_class
		let result = eiffelide#CompleteClass(a:findstart, a:base)
	else
		let result = eiffelide#CompleteFeature(a:findstart, a:base)
	endif
	return result
endfunction

" DESC: Used for Auto-Completion system for classes. See `:help complete-function'
function! eiffelide#CompleteClass(findstart, base)
	if a:findstart
		python vim.command("let result = " +  str(eiffel_class.complete_start()))
	else
python << endpython
if i_eiffel_project:
	vim.command("let result = " +  eiffel_class.complete_class_match(i_eiffel_project,vim.eval('a:base')))
endpython
	endif
	return result
endfunction


" DESC: Used for Auto-Completion system for features. See `:help complete-function'
function! eiffelide#CompleteFeature(findstart, base)
	if a:findstart
		python vim.command("let result = " +  str(eiffel_class.complete_start()))
	else
python << endpython
if i_eiffel_project:
	vim.command("let result = " +  eiffel_class.complete_feature_match(i_eiffel_project,vim.eval('a:base')))
endpython
	endif
	return result
endfunction
