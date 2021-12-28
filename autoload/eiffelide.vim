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


" To map a shortcut for Class and creator completion, use the following line
" (just change the <C-X><C-G> and <C-X><C-H>)
inoremap <C-X><C-G> <esc>:call eiffelide#StartClassCompletion()<cr>
inoremap <C-X><C-H> <esc>:call eiffelide#StartCreatorCompletion()<cr>


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
let g:eiffel_complete_is_creator = 0
execute "set omnifunc=eiffelide#CompleteEiffel"
autocmd CompleteDone * call eiffelide#EndCompletion()


" DESC: Python environment initialisation
python3 import sys, vim

python3 sys.path.insert(0, vim.eval('g:eiffel_plugin_root')+"/pyplugin")

python3 import eiffel_project, eiffel_ide, eiffel_system, eiffel_class
python3 import eiffel_feature

" DESC: The Eiffel Project python object
" SEE: `project' class in pyplugin/eiffel_ide.py 
python3 i_eiffel_project = None




" ========================== System commands============================

" DESC: Command shortcuts for a simple speedy compilation
command! EiffelSystemCompile python3 eiffel_system.quick_melt_no_focus(i_eiffel_project)

command! ESCompile EiffelSystemCompile 

command! EC EiffelSystemCompile

" DESC: Command shortcuts for a 'Recompile from scratch' compilation
command! EiffelSystemRecompile python3 eiffel_system.recompile(i_eiffel_project)

command! ESRecompile EiffelSystemRecompile 

" DESC: Command shortcuts for a 'Finalize' compilation.
command! EiffelSystemFinalize python3 eiffel_system.finalize(i_eiffel_project)

command! ESFinalize EiffelSystemFinalize 

" DESC: Command shortcuts for a 'Freeze' compilation.
" SEE: http://docs.eiffel.com/book/eiffelstudio/melting-ice-technology
command! EiffelSystemFreeze python3 eiffel_system.freeze(i_eiffel_project)

command! ESFreeze EiffelSystemFreeze 

" DESC: Command shortcut for a 'Melting' compilation
" SEE: http://docs.eiffel.com/book/eiffelstudio/melting-ice-technology
command! EiffelSystemMelt python3 eiffel_system.melt(i_eiffel_project)

command! ESMelt EiffelSystemMelt

" DESC: Command shortcut for a 'Quick Melting' compilation
command! EiffelSystemQuickMelt python3 eiffel_system.quick_melt(i_eiffel_project)

command! ESQuickMelt EiffelSystemQuickMelt

" DESC: Run and Debug
command! EiffelSystemRun python3 eiffel_ide.run_project(i_eiffel_project)

command! ESRun EiffelSystemRun

" DESC: Class list
command! EiffelSystemClasses python3 eiffel_system.list_classes(i_eiffel_project)

command! ESClasses python3 eiffel_system.list_classes(i_eiffel_project)

" DESC: Command shortcuts for Eiffel project information.
command! EiffelProject echom eiffelide#config_file()

command! EProject EiffelProject

command! EiffelTarget echom eiffelide#target_name()

command! ETarget EiffelTarget

" ====================== Class informations commands ========================

" DESC: Class Flat View
command! -complete=customlist,eiffelide#list_class -nargs=* EiffelClassFlat python3 eiffel_class.flat(i_eiffel_project,<f-args>)

command! -complete=customlist,eiffelide#list_class -nargs=* ECFlat python3 eiffel_class.flat(i_eiffel_project,<f-args>)

" DESC: Class Ancestors
command! -complete=customlist,eiffelide#list_class -nargs=* EiffelClassAncestors python3 eiffel_class.ancestors(i_eiffel_project,<f-args>)

command! -complete=customlist,eiffelide#list_class -nargs=* ECAncestors python3 eiffel_class.ancestors(i_eiffel_project,<f-args>)

" DESC: Class Attributes
command! -complete=customlist,eiffelide#list_class -nargs=* EiffelClassAttributes python3 eiffel_class.attributes(i_eiffel_project,<f-args>)

command! -complete=customlist,eiffelide#list_class -nargs=* ECAttributes python3 eiffel_class.attributes(i_eiffel_project,<f-args>)

" DESC: Class Clients
command! -complete=customlist,eiffelide#list_class -nargs=* EiffelClassClients python3 eiffel_class.clients(i_eiffel_project,<f-args>)

command! -complete=customlist,eiffelide#list_class -nargs=* ECClients python3 eiffel_class.clients(i_eiffel_project,<f-args>)

" DESC: Class Deferred features
command! -complete=customlist,eiffelide#list_class -nargs=* EiffelClassDeferred python3 eiffel_class.deferred(i_eiffel_project,<f-args>)

command! -complete=customlist,eiffelide#list_class -nargs=* ECDeferred python3 eiffel_class.deferred(i_eiffel_project,<f-args>)

" DESC: Class Descendants
command! -complete=customlist,eiffelide#list_class -nargs=* EiffelClassDescendants python3 eiffel_class.descendants(i_eiffel_project,<f-args>)

command! -complete=customlist,eiffelide#list_class -nargs=* ECDescendants python3 eiffel_class.descendants(i_eiffel_project,<f-args>)

" DESC: Class Exported features
command! -complete=customlist,eiffelide#list_class -nargs=* EiffelClassExported python3 eiffel_class.exported(i_eiffel_project,<f-args>)

command! -complete=customlist,eiffelide#list_class -nargs=* ECExported python3 eiffel_class.exported(i_eiffel_project,<f-args>)

" DESC: Class External features
command! -complete=customlist,eiffelide#list_class -nargs=* EiffelClassExternals python3 eiffel_class.externals(i_eiffel_project,<f-args>)

command! -complete=customlist,eiffelide#list_class -nargs=* ECExternals python3 eiffel_class.externals(i_eiffel_project,<f-args>)

" DESC: Class Flat contract view
command! -complete=customlist,eiffelide#list_class -nargs=* EiffelClassFlatShort python3 eiffel_class.flatshort(i_eiffel_project,<f-args>)

command! -complete=customlist,eiffelide#list_class -nargs=* ECFlatShort python3 eiffel_class.flatshort(i_eiffel_project,<f-args>)

command! -complete=customlist,eiffelide#list_class -nargs=* EiffelClassFlatContract python3 eiffel_class.flatshort(i_eiffel_project,<f-args>)

command! -complete=customlist,eiffelide#list_class -nargs=* ECFlatContract python3 eiffel_class.flatshort(i_eiffel_project,<f-args>)

" DESC: Class Once features
command! -complete=customlist,eiffelide#list_class -nargs=* EiffelClassOnce python3 eiffel_class.once(i_eiffel_project,<f-args>)

command! -complete=customlist,eiffelide#list_class -nargs=* ECOnce python3 eiffel_class.once(i_eiffel_project,<f-args>)

" DESC: Class Invariants
command! -complete=customlist,eiffelide#list_class -nargs=* EiffelClassInvariants python3 eiffel_class.invariants(i_eiffel_project,<f-args>)

command! -complete=customlist,eiffelide#list_class -nargs=* ECInvariants python3 eiffel_class.invariants(i_eiffel_project,<f-args>)

" DESC: Class Routines
command! -complete=customlist,eiffelide#list_class -nargs=* EiffelClassRoutines python3 eiffel_class.routines(i_eiffel_project,<f-args>)

command! -complete=customlist,eiffelide#list_class -nargs=* ECRoutines python3 eiffel_class.routines(i_eiffel_project,<f-args>)

" DESC: Class Creators
command! -complete=customlist,eiffelide#list_class -nargs=* EiffelClassCreators python3 eiffel_class.creators(i_eiffel_project,<f-args>)

command! -complete=customlist,eiffelide#list_class -nargs=* ECCreators python3 eiffel_class.creators(i_eiffel_project,<f-args>)

" DESC: Class Short View
command! -complete=customlist,eiffelide#list_class -nargs=* EiffelClassShort python3 eiffel_class.short(i_eiffel_project,<f-args>)

command! -complete=customlist,eiffelide#list_class -nargs=* ECShort python3 eiffel_class.short(i_eiffel_project,<f-args>)

command! -complete=customlist,eiffelide#list_class -nargs=* EiffelClassContract python3 eiffel_class.short(i_eiffel_project,<f-args>)

command! -complete=customlist,eiffelide#list_class -nargs=* ECContract python3 eiffel_class.short(i_eiffel_project,<f-args>)

" DESC: Class Suppliers
command! -complete=customlist,eiffelide#list_class -nargs=* EiffelClassSuppliers python3 eiffel_class.suppliers(i_eiffel_project,<f-args>)

command! -complete=customlist,eiffelide#list_class -nargs=* ECSuppliers python3 eiffel_class.suppliers(i_eiffel_project,<f-args>)

" DESC: Class Text
command! -complete=customlist,eiffelide#list_class -nargs=* EiffelClassText python3 eiffel_class.text(i_eiffel_project,<f-args>)

command! -complete=customlist,eiffelide#list_class -nargs=* ECText python3 eiffel_class.text(i_eiffel_project,<f-args>)

" DESC: Edit class
command! -complete=customlist,eiffelide#list_class -nargs=* EiffelClassEdit python3 eiffel_class.edit(i_eiffel_project, False, False, False, False, <f-args>)

command! -complete=customlist,eiffelide#list_class -nargs=* ECEdit python3 eiffel_class.edit(i_eiffel_project, False, False, False, False, <f-args>)

" DESC: Edit class force close
command! -complete=customlist,eiffelide#list_class -nargs=* EiffelClassEditF python3 eiffel_class.edit(i_eiffel_project, False, False, False, True, <f-args>)

command! -complete=customlist,eiffelide#list_class -nargs=* ECEditF python3 eiffel_class.edit(i_eiffel_project, False, False, False, True, <f-args>)

" DESC: Edit class in new window (split)
command! -complete=customlist,eiffelide#list_class -nargs=* EiffelClassEditSplit python3 eiffel_class.edit(i_eiffel_project, True, False, False, False, <f-args>)

command! -complete=customlist,eiffelide#list_class -nargs=* ECEditSp python3 eiffel_class.edit(i_eiffel_project, True, False, False, False, <f-args>)

" DESC: Edit class in new window (vertical split)
command! -complete=customlist,eiffelide#list_class -nargs=* EiffelClassEditVSplit python3 eiffel_class.edit(i_eiffel_project, True, True, False, False, <f-args>)

command! -complete=customlist,eiffelide#list_class -nargs=* ECEditVSp python3 eiffel_class.edit(i_eiffel_project, True, True, False, False, <f-args>)

" DESC: Edit class in a new tab
command! -complete=customlist,eiffelide#list_class -nargs=* EiffelClassEditTab python3 eiffel_class.edit(i_eiffel_project, False, False, True, False, <f-args>)

command! -complete=customlist,eiffelide#list_class -nargs=* ECEditTab python3 eiffel_class.edit(i_eiffel_project, False, False, True, False, <f-args>)

" ====================== Feature informations commands =======================

" DESC: Feature Ancestors
command! -complete=customlist,eiffelide#complete_freatures_commands -nargs=* EiffelFeatureAncestors python3 eiffel_feature.ancestors(i_eiffel_project,<f-args>)

command! -complete=customlist,eiffelide#complete_freatures_commands -nargs=* EFAncestors python3 eiffel_feature.ancestors(i_eiffel_project,<f-args>)

" DESC: Feature Callers
command! -complete=customlist,eiffelide#complete_freatures_commands -nargs=* EiffelFeatureCallers python3 eiffel_feature.callers(i_eiffel_project,<f-args>)

command! -complete=customlist,eiffelide#complete_freatures_commands -nargs=* EFCallers python3 eiffel_feature.callers(i_eiffel_project,<f-args>)

" DESC: Feature Creators
command! -complete=customlist,eiffelide#complete_freatures_commands -nargs=* EiffelFeatureCreators python3 eiffel_feature.creators(i_eiffel_project,<f-args>)

command! -complete=customlist,eiffelide#complete_freatures_commands -nargs=* EFCreators python3 eiffel_feature.creators(i_eiffel_project,<f-args>)

" DESC: Feature Assigners
command! -complete=customlist,eiffelide#complete_freatures_commands -nargs=* EiffelFeatureAssigners python3 eiffel_feature.assigners(i_eiffel_project,<f-args>)

command! -complete=customlist,eiffelide#complete_freatures_commands -nargs=* EFAssigners python3 eiffel_feature.assigners(i_eiffel_project,<f-args>)

" DESC: Feature Callees
command! -complete=customlist,eiffelide#complete_freatures_commands -nargs=* EiffelFeatureCallees python3 eiffel_feature.callees(i_eiffel_project,<f-args>)

command! -complete=customlist,eiffelide#complete_freatures_commands -nargs=* EFCallees python3 eiffel_feature.callees(i_eiffel_project,<f-args>)

" DESC: Feature Creations
command! -complete=customlist,eiffelide#complete_freatures_commands -nargs=* EiffelFeatureCreations python3 eiffel_feature.creations(i_eiffel_project,<f-args>)

command! -complete=customlist,eiffelide#complete_freatures_commands -nargs=* EFCreations python3 eiffel_feature.creations(i_eiffel_project,<f-args>)

" DESC: Feature Assignees
command! -complete=customlist,eiffelide#complete_freatures_commands -nargs=* EiffelFeatureAssignees python3 eiffel_feature.assignees(i_eiffel_project,<f-args>)

command! -complete=customlist,eiffelide#complete_freatures_commands -nargs=* EFAssignees python3 eiffel_feature.assignees(i_eiffel_project,<f-args>)

" DESC: Feature Descendants
command! -complete=customlist,eiffelide#complete_freatures_commands -nargs=* EiffelFeatureDescendants python3 eiffel_feature.descendants(i_eiffel_project,<f-args>)

command! -complete=customlist,eiffelide#complete_freatures_commands -nargs=* EFDescendants python3 eiffel_feature.descendants(i_eiffel_project,<f-args>)

" DESC: Feature Flat
command! -complete=customlist,eiffelide#complete_freatures_commands -nargs=* EiffelFeatureFlat python3 eiffel_feature.flat(i_eiffel_project,<f-args>)

command! -complete=customlist,eiffelide#complete_freatures_commands -nargs=* EFFlat python3 eiffel_feature.flat(i_eiffel_project,<f-args>)

" DESC: Feature Homonyms
command! -complete=customlist,eiffelide#complete_freatures_commands -nargs=* EiffelFeatureHomonyms python3 eiffel_feature.homonyms(i_eiffel_project,<f-args>)

command! -complete=customlist,eiffelide#complete_freatures_commands -nargs=* EFHomonyms python3 eiffel_feature.homonyms(i_eiffel_project,<f-args>)

" DESC: Feature Implementers
command! -complete=customlist,eiffelide#complete_freatures_commands -nargs=* EiffelFeatureImplementers python3 eiffel_feature.implementers(i_eiffel_project,<f-args>)

command! -complete=customlist,eiffelide#complete_freatures_commands -nargs=* EFImplementers python3 eiffel_feature.implementers(i_eiffel_project,<f-args>)

" DESC: Feature Text
command! -complete=customlist,eiffelide#complete_freatures_commands -nargs=* EiffelFeatureText python3 eiffel_feature.text(i_eiffel_project,<f-args>)

command! -complete=customlist,eiffelide#complete_freatures_commands -nargs=* EFText python3 eiffel_feature.text(i_eiffel_project,<f-args>)


" ============================ Others commands ==============================
" ============================ Common routines ============================


" DESC: Use the `g:saved_window_number' value to go to preceding window
" SEE: `eiffelide#open_tools_window()'
" NOTE: To be remove, do not use
function! eiffelide#return_to_saved_window()
	python3 eiffel_ide.select_saved_window()
endfunction

" DESC: If it does not exist, create the Eiffel IDE tools buffer, show it in
" a window, save the number of the current selected window in
" `g:saved_window_number' and return the Eiffel IDE tools buffer number.
" SEE: `eiffelide#return_to_saved_window()'
function! eiffelide#open_tools_window()
	python3 eiffel_ide.save_current_window_and_open_tools_window()
	python3 vim.command("return '" + str(eiffel_ide.get_tools_buffer_number()) + "'")
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
		python3 i_eiffel_project = eiffel_project.project(vim.eval('config_file'),vim.eval('a:2'))
    else
		python3 i_eiffel_project = eiffel_project.project(vim.eval('config_file'))
    endif
	EiffelSystemQuickMelt
endfunction

" DESC: Open an Eiffel Project. The first optionnal argument is the Eiffel 
" project (.ecf) file. The second optionnal argument is the project target.
" SEE: `eiffelide#open()' and `i_eiffel_project'
function! eiffelide#open_target(target)
    call eiffelide#open(fnamemodify(bufname("%"), ':p'), a:target)
endfunction

" DESC: Return the config file name of the openned `i_eiffel_project'
function! eiffelide#config_file()
python3 << endpython
if i_eiffel_project:
    vim.command("return '" + i_eiffel_project.config_file() + "'")
else:
    print "No Vim Eiffel IDE project opened."
endpython
endfunction

" DESC: Return the target name of the openned `i_eiffel_project' (if any).
function! eiffelide#target_name()
python3 << endpython
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
python3 << endpython
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
python3 << endpython
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

" DESC: Used to activate completion for creator
function! eiffelide#StartCreatorCompletion()
	let g:eiffel_complete_is_creator = 1
	call feedkeys("a\<c-x>\<c-o>") 
endfunction


" DESC: Used to desactivate completion for classes and creator
function! eiffelide#EndCompletion()
	if g:eiffel_complete_is_class
		let g:eiffel_complete_is_class = 0
	endif
	if g:eiffel_complete_is_creator
		let g:eiffel_complete_is_creator = 0
	endif
endfunction


" DESC: Used for Auto-Completion system. See `:help complete-function'
function! eiffelide#CompleteEiffel(findstart, base)
	if g:eiffel_complete_is_class
		let result = eiffelide#CompleteClass(a:findstart, a:base)
	elseif g:eiffel_complete_is_creator
		let result = eiffelide#CompleteCreator(a:findstart, a:base)
	else
		let result = eiffelide#CompleteFeature(a:findstart, a:base)
	endif
	return result
endfunction


" DESC: Used for Auto-Completion system for classes. See `:help complete-function'
function! eiffelide#CompleteClass(findstart, base)
	if a:findstart
		python3 vim.command("let result = " +  str(eiffel_class.complete_start()))
	else
python3 << endpython
if i_eiffel_project:
	vim.command("let result = " +  eiffel_class.complete_class_match(i_eiffel_project,vim.eval('a:base')))
endpython
	endif
	return result
endfunction


" DESC: Used for Auto-Completion system for classes. See `:help complete-function'
function! eiffelide#CompleteCreator(findstart, base)
	if a:findstart
		python3 vim.command("let result = " +  str(eiffel_class.complete_start()))
	else
python3 << endpython
if i_eiffel_project:
	vim.command("let result = " +  eiffel_class.complete_creator_match(i_eiffel_project,vim.eval('a:base')))
endpython
	endif
	return result
endfunction


" DESC: Used for Auto-Completion system for features. See `:help complete-function'
function! eiffelide#CompleteFeature(findstart, base)
	if a:findstart
		python3 vim.command("let result = " +  str(eiffel_class.complete_start()))
	else
python3 << endpython
if i_eiffel_project:
	vim.command("let result = " +  eiffel_class.complete_feature_match(i_eiffel_project,vim.eval('a:base')))
endpython
	endif
	return result
endfunction

" DESC: Used for Auto-Completion for classes name in command argument.
" See `:help command-completion'
function! eiffelide#list_class(ArgLead, CmdLine, CursorPos)
python3 << endpython
if i_eiffel_project:
	vim.command("let result = " +  eiffel_class.complete_class_match(i_eiffel_project,vim.eval('a:ArgLead')))
endpython
	return result
endfunction

" DESC: Used for Auto-Completion for features in command argument.
" See `:help command-completion'
function! eiffelide#complete_freatures_commands(ArgLead, CmdLine, CursorPos)
python3 << endpython
if i_eiffel_project:
	vim.command("let result = " +  eiffel_feature.complete_features_commands(\
		i_eiffel_project,vim.eval('a:ArgLead'), vim.eval('a:CmdLine'),vim.eval('a:CursorPos')))
endpython
	return result
endfunction

" DESC: Used for indentation folding
" See `:help foldexpr'
function! eiffelide#indent_fold(lnum)
	if getline(a:lnum) =~? '\v^\s*$'
		let result = -1
	else
		if indent(a:lnum) < indent(a:lnum + 1)
			let result = ">" . indent(a:lnum + 1)
		else
			let result = indent(a:lnum)
		endif
	endif
	return result
endfunction



