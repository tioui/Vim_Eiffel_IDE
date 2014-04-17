
" DESC: Redefine to change the path to the EiffelStudio (EC) compiler.
if !exists("g:eiffelstudio_compiler")
    let g:eiffelstudio_compiler = "ec"
endif

" DESC: Redefine to change the root directory of the Vim-Eiffelstudio folder.
if !exists("g:eiffel_plugin_root")
    let g:eiffel_plugin_root= expand('<sfile>:p:h:h')
endif

" DESC: Redefine to change the EiffelStudio Tools buffer name
if !exists("g:eiffelstudio_buffer_name")
    let g:eiffelstudio_buffer_name = "__eiffelstudio_tools__"
endif

" DESC: Redefine to change the default EiffelStudio tools window height or width.
if !exists("g:eiffelstudio_tools_window_dimension")
    let g:eiffelstudio_tools_window_dimension = 10
endif

" DESC: Redefine to put the EiffelStudio tools above (or left) of the current window
" SEE: `g:eiffelstudio_tools_window_vertical'
if !exists("g:eiffelstudio_tools_window_leftabove")
    let g:eiffelstudio_tools_window_leftabove= 0
endif

" DESC: Redefine to put the EiffelStudio tools à the right (or left) or the
" current window
" SEE: `g:eiffelstudio_tools_window_leftabove'
if !exists("g:eiffelstudio_tools_window_vertical")
    let g:eiffelstudio_tools_window_vertical = 0
endif

" DESC: Command shortcuts for a simple speedy compilation
command! EiffelCompile call eiffelstudio#quick_melt_no_focus()

command! ECompile EiffelCompile 

command! EC EiffelCompile 

" DESC: Command shortcuts for a 'Recompile from scratch' compilation
command! EiffelRecompile call eiffelstudio#recompile()

command! ERecompile EiffelRecompile 

" DESC: Command shortcuts for a 'Freeze' compilation.
" SEE: http://docs.eiffel.com/book/eiffelstudio/melting-ice-technology
command! EiffelFreeze call eiffelstudio#freeze()

command! EFreeze EiffelFreeze 

" DESC: Command shortcut for a 'Melting' compilation
" SEE: http://docs.eiffel.com/book/eiffelstudio/melting-ice-technology
command! EiffelMelt call eiffelstudio#melt()

command! EMelt EiffelMelt

" DESC: Command shortcut for a 'Quick Melting' compilation
command! EiffelQuickMelt call eiffelstudio#quick_melt()

command! EQuickMelt EiffelQuickMelt

" DESC: Command shortcuts for Eiffel project information.
command! EiffelProject echom eiffelstudio#config_file()

command! EProject EiffelProject

command! EiffelTarget echom eiffelstudio#target_name()

command! ETarget EiffelTarget

" DESC: Use the `g:saved_window_number' value to go to preceding window
" SEE: `eiffelstudio#open_tools_window()'
function! eiffelstudio#return_to_saved_window()
    if exists("g:saved_window_number")
	execute g:saved_window_number . " wincmd w"
    endif
endfunction

" DESC: If it does not exist, create the EiffelStudio tools buffer, show it in
" a window, save the number of the current selected window in
" `g:saved_window_number' and return the EiffelStudio tools buffer number.
" SEE: `eiffelstudio#return_to_saved_window()'
function! eiffelstudio#open_tools_window()
    if g:eiffelstudio_tools_window_vertical
	let l:vertical = "vertical"
    else
	let l:vertical = ""
    endif
    if g:eiffelstudio_tools_window_leftabove
	let l:position = "leftabove"
    else
	let l:position = "rightbelow"
    endif
    if bufnr(g:eiffelstudio_buffer_name) < 0
        execute l:position . " " . l:vertical . " " . g:eiffelstudio_tools_window_dimension . " new " . g:eiffelstudio_buffer_name
        setlocal buftype=nofile
        setlocal bufhidden=hide
        setlocal noswapfile
	redraw
	wincmd p
	let g:saved_window_number = bufwinnr('%')
	wincmd p
    else
	if bufwinnr(g:eiffelstudio_buffer_name) < 0
	    execute l:position . " " . l:vertical . " " . g:eiffelstudio_tools_window_dimension . " split " . g:eiffelstudio_buffer_name
	    redraw
	    wincmd p
	    let g:saved_window_number = bufwinnr('%')
	    wincmd p
	else
	    let g:saved_window_number = bufwinnr('%')
	    execute bufwinnr(g:eiffelstudio_buffer_name) . " wincmd w"
	endif
    endif
    return bufnr(g:eiffelstudio_buffer_name)
endfunction

" DESC: Python environment initialisation
python import sys, vim

python sys.path.insert(0, vim.eval('g:eiffel_plugin_root')+"/pyplugin")

python import eiffelstudio, environment

" DESC: The Eiffel Project python object
" SEE: `project' class in pyplugin/eiffelstudio.py 
python eiffel_project = None

" DESC: Open an Eiffel Project. The first optionnal argument is the Eiffel 
" project (.ecf) file. The second optionnal argument is the project target.
" SEE: `eiffel_project'
function! eiffelstudio#open(...)
    if a:0 ># 0
	let config_file = fnamemodify(a:1,':p')
    else
	let config_file = fnamemodify(bufname("%"), ':p')
    endif
    echom "Opening Vim EiffelStudio."
    if a:0 ># 1
	python eiffel_project = eiffelstudio.project(vim.eval('config_file'),vim.eval('a:2'))
    else
	python eiffel_project = eiffelstudio.project(vim.eval('config_file'))
    endif
    call eiffelstudio#quick_melt()
endfunction

" DESC: Open an Eiffel Project. The first optionnal argument is the Eiffel 
" project (.ecf) file. The second optionnal argument is the project target.
" SEE: `eiffelstudio#open()' and `eiffel_project'
function! eiffelstudio#open_target(target)
    call eiffelstudio#open(fnamemodify(bufname("%"), ':p'), a:target)
endfunction

" DESC: Return the config file name of the openned `eiffel_project'
function! eiffelstudio#config_file()
python << endpython
if eiffel_project:
    vim.command("return " + eiffel_project.config_file())
else:
    print "No Vim Eiffelstudio project opened."
endpython
endfunction

" DESC: Return the target name of the openned `eiffel_project' (if any).
function! eiffelstudio#target_name()
python << endpython
if eiffel_project:
    if eiffel_project.target_name():
	vim.command("return '" + eiffel_project.target_name() + "'")
    else:
	vim.command("return ''")
else:
    print "No Vim Eiffelstudio project opened."
endpython
endfunction

" DESC: Run a compilation from scratch of the openned `eiffel_project'
function! eiffelstudio#recompile()
python << endpython
if eiffel_project:
    l_buffer_number = vim.eval("eiffelstudio#open_tools_window()")
    l_buffer = environment.buffer(l_buffer_number)
    eiffel_project.recompile(l_buffer)
    if not eiffel_project.has_error():
        vim.command("call eiffelstudio#return_to_saved_window()")
else:
    print "No Vim Eiffelstudio project opened."
endpython
endfunction

" DESC: Run a 'Freezing' compilation of the openned `eiffel_project'
" SEE: http://docs.eiffel.com/book/eiffelstudio/melting-ice-technology 
function! eiffelstudio#freeze()
python << endpython
if eiffel_project:
    l_buffer_number = vim.eval("eiffelstudio#open_tools_window()")
    l_buffer = environment.buffer(l_buffer_number)
    eiffel_project.freeze(l_buffer)
    if not eiffel_project.has_error():
        vim.command("call eiffelstudio#return_to_saved_window()")
else:
    print "No Vim Eiffelstudio project opened."
endpython
endfunction

" DESC: Run a 'Melting' compilation of the openned `eiffel_project'
" SEE: http://docs.eiffel.com/book/eiffelstudio/melting-ice-technology
function! eiffelstudio#melt()
python << endpython
if eiffel_project:
    l_buffer_number = vim.eval("eiffelstudio#open_tools_window()")
    l_buffer = environment.buffer(l_buffer_number)
    eiffel_project.melt(l_buffer)
    if not eiffel_project.has_error():
        vim.command("call eiffelstudio#return_to_saved_window()")
else:
    print "No Vim Eiffelstudio project opened."
endpython
endfunction

" DESC: Run a 'Quick Melting' compilation of the openned `eiffel_project'
" SEE: http://docs.eiffel.com/book/eiffelstudio/melting-ice-technology
function! eiffelstudio#quick_melt()
python << endpython
if eiffel_project:
    l_buffer_number = vim.eval("eiffelstudio#open_tools_window()")
    l_buffer = environment.buffer(l_buffer_number)
    eiffel_project.quick_melt(l_buffer)
    if not eiffel_project.has_error():
        vim.command("call eiffelstudio#return_to_saved_window()")
else:
    print "No Vim Eiffelstudio project opened."
endpython
endfunction

" DESC: Run a 'Quick Melting' compilation of the openned `eiffel_project' and
" even if there is error, do not put the focus in the EiffelStudio tools
" buffer window.
" SEE: http://docs.eiffel.com/book/eiffelstudio/melting-ice-technology
function! eiffelstudio#quick_melt_no_focus()
python << endpython
if eiffel_project:
    l_buffer_number = vim.eval("eiffelstudio#open_tools_window()")
    l_buffer = environment.buffer(l_buffer_number)
    eiffel_project.quick_melt(l_buffer)
    vim.command("call eiffelstudio#return_to_saved_window()")
else:
    print "No Vim Eiffelstudio project opened."
endpython
endfunction
