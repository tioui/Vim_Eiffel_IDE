
" DESC: Redefine to change the path to the EiffelStudio (EC) compiler.
if !exists("g:eiffelstudio_compiler")
    let g:eiffelstudio_compiler = "ec"
endif

" DESC: Redefine to change the root directory of the Vim_Eiffel_IDE folder.
if !exists("g:eiffel_plugin_root")
    let g:eiffel_plugin_root= expand('<sfile>:p:h:h')
endif

" DESC: Redefine to change the Eiffel IDE Tools buffer name
if !exists("g:eiffel_ide_buffer_name")
    let g:eiffel_ide_buffer_name = "__eiffel_IDE_tools__"
endif

" DESC: Redefine to change the default Eiffel IDE tools window height or width.
if !exists("g:eiffel_ide_tools_window_dimension")
    let g:eiffel_ide_tools_window_dimension = 10
endif

" DESC: Redefine to put the Eiffel IDE tools above (or left) of the current window
" SEE: `g:eiffel_ide_tools_window_vertical'
if !exists("g:eiffel_ide_tools_window_leftabove")
    let g:eiffel_ide_tools_window_leftabove= 0
endif

" DESC: Redefine to put the Eiffel IDE tools à the right (or left) or the
" current window
" SEE: `g:eiffel_ide_tools_window_leftabove'
if !exists("g:eiffel_ide_tools_window_vertical")
    let g:eiffel_ide_tools_window_vertical = 0
endif

" DESC: Redefine to put the Eiffel IDE tools à the right (or left) or the
" current window
" SEE: `g:eiffel_ide_tools_window_leftabove'
if !exists("g:eiffel_ide_tools_window_statusline")
	let status_line = "%f%m%r%h%w%q%=[%l,%v][%p%%]"
	if &statusline !=# ''
		let status_line = &statusline
	endif
	let status_line = substitute(status_line,"%f","%{exists('b:eiffel_ide_buffer_info')?(b:eiffel_ide_buffer_info):bufname('%')}","")
	let status_line = substitute(status_line,"%F","%{exists('b:eiffel_ide_buffer_info')?(b:eiffel_ide_buffer_info):fnamemodify(bufname('%'), ':p')}","")
    let g:eiffel_ide_tools_window_statusline = status_line
	echom status_line
endif

let &statusline = g:eiffel_ide_tools_window_statusline


" DESC: Command shortcuts for a simple speedy compilation
command! EiffelCompile call eiffelide#quick_melt_no_focus()

command! ECompile EiffelCompile 

command! EC EiffelCompile 

" DESC: Command shortcuts for a 'Recompile from scratch' compilation
command! EiffelRecompile call eiffelide#recompile()

command! ERecompile EiffelRecompile 

" DESC: Command shortcuts for a 'Finalize' compilation.
command! EiffelFinalize call eiffelide#finalize()

command! EFinalize EiffelFinalize 

" DESC: Command shortcuts for a 'Freeze' compilation.
" SEE: http://docs.eiffel.com/book/eiffelstudio/melting-ice-technology
command! EiffelFreeze call eiffelide#freeze()

command! EFreeze EiffelFreeze 

" DESC: Command shortcut for a 'Melting' compilation
" SEE: http://docs.eiffel.com/book/eiffelstudio/melting-ice-technology
command! EiffelMelt call eiffelide#melt()

command! EMelt EiffelMelt

" DESC: Command shortcut for a 'Quick Melting' compilation
command! EiffelQuickMelt call eiffelide#quick_melt()

command! EQuickMelt EiffelQuickMelt

" DESC: Command shortcuts for Eiffel project information.
command! EiffelProject echom eiffelide#config_file()

command! EProject EiffelProject

command! EiffelTarget echom eiffelide#target_name()

command! ETarget EiffelTarget

" DESC: Run and Debug
command! EiffelRun call eiffelide#run()

command! ERun EiffelRun

" DESC: Class Flat View
command! -nargs=* EiffelClassFlat call eiffelide#class_flat(<f-args>)

command! -nargs=* ECFlat call eiffelide#class_flat(<f-args>)

" DESC: Class Ancestors View
command! -nargs=* EiffelClassAncestors call eiffelide#class_ancestors(<f-args>)

command! -nargs=* ECAncestors call eiffelide#class_ancestors(<f-args>)

" DESC: Class Attributes View
command! -nargs=* EiffelClassAttributes call eiffelide#class_attributes(<f-args>)

command! -nargs=* ECAttributes call eiffelide#class_attributes(<f-args>)



" DESC: Use the `g:saved_window_number' value to go to preceding window
" SEE: `eiffelide#open_tools_window()'
function! eiffelide#return_to_saved_window()
    if exists("g:saved_window_number")
	execute g:saved_window_number . " wincmd w"
    endif
endfunction

" DESC: If it does not exist, create the Eiffel IDE tools buffer, show it in
" a window, save the number of the current selected window in
" `g:saved_window_number' and return the Eiffel IDE tools buffer number.
" SEE: `eiffelide#return_to_saved_window()'
function! eiffelide#open_tools_window()
    if g:eiffel_ide_tools_window_vertical
		let l:vertical = "vertical"
    else
		let l:vertical = ""
    endif
    if g:eiffel_ide_tools_window_leftabove
		let l:position = "leftabove"
    else
		let l:position = "rightbelow"
    endif
    if bufnr(g:eiffel_ide_buffer_name) < 0
        execute l:position . " " . l:vertical . " " . g:eiffel_ide_tools_window_dimension . " new " . g:eiffel_ide_buffer_name
        setlocal buftype=nofile
        setlocal bufhidden=hide
        setlocal noswapfile
		let b:eiffel_ide_buffer_info = "Eiffel IDE Information"
		redraw
		wincmd p
		let g:saved_window_number = bufwinnr('%')
		wincmd p
    else
		if bufwinnr(g:eiffel_ide_buffer_name) < 0
			execute l:position . " " . l:vertical . " " . g:eiffel_ide_tools_window_dimension . " split " . g:eiffel_ide_buffer_name
			redraw
			wincmd p
			let g:saved_window_number = bufwinnr('%')
			wincmd p
		else
			let g:saved_window_number = bufwinnr('%')
			execute bufwinnr(g:eiffel_ide_buffer_name) . " wincmd w"
		endif
    endif
	setlocal filetype=
    return bufnr(g:eiffel_ide_buffer_name)
endfunction

" DESC: Python environment initialisation
python import sys, vim

python sys.path.insert(0, vim.eval('g:eiffel_plugin_root')+"/pyplugin")

python import eiffelide, environment

" DESC: The Eiffel Project python object
" SEE: `project' class in pyplugin/eiffelide.py 
python eiffel_project = None

" DESC: Open an Eiffel Project. The first optionnal argument is the Eiffel 
" project (.ecf) file. The second optionnal argument is the project target.
" SEE: `eiffel_project'
function! eiffelide#open(...)
    if a:0 ># 0
	let config_file = fnamemodify(a:1,':p')
    else
	let config_file = fnamemodify(bufname("%"), ':p')
    endif
    echom "Opening Vim Eiffel IDE."
    if a:0 ># 1
	python eiffel_project = eiffelide.project(vim.eval('config_file'),vim.eval('a:2'))
    else
	python eiffel_project = eiffelide.project(vim.eval('config_file'))
    endif
    call eiffelide#quick_melt()
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

" DESC: Run a compilation from scratch of the openned `eiffel_project'
function! eiffelide#recompile()
python << endpython
if eiffel_project:
	l_buffer_number = vim.eval("eiffelide#open_tools_window()")
	vim.command("let b:eiffel_ide_buffer_info = \"Freezing...\"")
	l_buffer = environment.buffer(l_buffer_number)
	eiffel_project.recompile(l_buffer)
	vim.command("let b:eiffel_ide_buffer_info = \"Freezing complete\"")
	if not eiffel_project.has_error():
		vim.command("call eiffelide#return_to_saved_window()")
else:
	print "No Vim Eiffel IDE project opened."
endpython
endfunction

" DESC: Run a 'Freezing' compilation of the openned `eiffel_project'
" SEE: http://docs.eiffel.com/book/eiffelstudio/melting-ice-technology 
function! eiffelide#freeze()
python << endpython
if eiffel_project:
	l_buffer_number = vim.eval("eiffelide#open_tools_window()")
	vim.command("let b:eiffel_ide_buffer_info = \"Freezing...\"")
	l_buffer = environment.buffer(l_buffer_number)
	eiffel_project.freeze(l_buffer)
	vim.command("let b:eiffel_ide_buffer_info = \"Freezing complete\"")
	if not eiffel_project.has_error():
		vim.command("call eiffelide#return_to_saved_window()")
else:
	print "No Vim Eiffel IDE project opened."
endpython
endfunction

" DESC: Run a 'Melting' compilation of the openned `eiffel_project'
" SEE: http://docs.eiffel.com/book/eiffelstudio/melting-ice-technology
function! eiffelide#melt()
python << endpython
if eiffel_project:
	l_buffer_number = vim.eval("eiffelide#open_tools_window()")
	vim.command("let b:eiffel_ide_buffer_info = \"Melting...\"")
	l_buffer = environment.buffer(l_buffer_number)
	eiffel_project.melt(l_buffer)
	vim.command("let b:eiffel_ide_buffer_info = \"Melting complete\"")
	if not eiffel_project.has_error():
		vim.command("call eiffelide#return_to_saved_window()")
else:
	print "No Vim Eiffel IDE project opened."
endpython
endfunction

" DESC: Run a 'Finilize' compilation of the openned `eiffel_project'
function! eiffelide#finalize()
python << endpython
if eiffel_project:
	l_buffer_number = vim.eval("eiffelide#open_tools_window()")
	vim.command("let b:eiffel_ide_buffer_info = \"Finalizing...\"")
	l_buffer = environment.buffer(l_buffer_number)
	eiffel_project.finalize(l_buffer)
	vim.command("let b:eiffel_ide_buffer_info = \"Finalizing complete\"")
	if not eiffel_project.has_error():
		vim.command("call eiffelide#return_to_saved_window()")
else:
	print "No Vim Eiffel IDE project opened."
endpython
endfunction

" DESC: Run a 'Quick Melting' compilation of the openned `eiffel_project'
" SEE: http://docs.eiffel.com/book/eiffelstudio/melting-ice-technology
function! eiffelide#quick_melt()
python << endpython
if eiffel_project:
	l_buffer_number = vim.eval("eiffelide#open_tools_window()")
	vim.command("let b:eiffel_ide_buffer_info = \"Quick melting...\"")
	l_buffer = environment.buffer(l_buffer_number)
	eiffel_project.quick_melt(l_buffer)
	vim.command("let b:eiffel_ide_buffer_info = \"Quick melting complete\"")
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
function! eiffelide#quick_melt_no_focus()
python << endpython
if eiffel_project:
	l_buffer_number = vim.eval("eiffelide#open_tools_window()")
	vim.command("let b:eiffel_ide_buffer_info = \"Compiling...\"")
	l_buffer = environment.buffer(l_buffer_number)
	eiffel_project.quick_melt(l_buffer)
	vim.command("let b:eiffel_ide_buffer_info = \"Compiling complete\"")
	vim.command("call eiffelide#return_to_saved_window()")
else:
	print "No Vim Eiffel IDE project opened."
endpython
endfunction

" DESC: Launch the Debug and Run program to test project
function! eiffelide#run()
python << endpython
if eiffel_project:
	vim.command("!" + eiffel_project.run_command())
else:
	print "No Vim Eiffel IDE project opened."
endpython
endfunction

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
function! eiffelide#class_flat(...)
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
function! eiffelide#class_ancestors(...)
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
function! eiffelide#class_attributes(...)
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
