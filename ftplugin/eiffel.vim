" Vim filetype plugin file
" Language:	Eiffel
" Maintainer:	Louis Marchand <prog@tioui.com>
" URL:	https://github.com/tioui/Vim_Eiffel_IDE
" Last Change:	Mon 28 Apr 2014
"
" Original Maintainer:	Jocelyn Fiat <jfiat@eiffel.com>
" 						(https://github.com/eiffelhub/vim-eiffel)
" Original URL: https://github.com/eiffelhub/vim-eiffel

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif

" Don't load another plugin for this buffer
let b:did_ftplugin = 1

setlocal foldmethod=expr
setlocal foldexpr=GetEiffelFoldValue(v:lnum)

" DESC: Used by GetEiffelFoldValue to get the first line of a folding bloc
function! IsLineFoldStart(line)
	return a:line =~? '\v^\s*feature(\s*\{.*\})?(\s*(--.*)?)?'
		\ || a:line =~? '\v^\s*invariant(\s*(--.*)?)?'
endfunction

" DESC: Used for Eiffel folding
" See `:help foldexpr'
function! GetEiffelFoldValue(lnum)
	let current_line = getline(a:lnum)
	if IsLineFoldStart(getline(a:lnum))
		let result = ">1"
	elseif IsLineFoldStart(getline(a:lnum + 1)) && l:current_line =~? '\v^\s*$'
		let result = 0
	else
		let result = "="
	endif
	return l:result
endfunction

" Matchit handling
" The following lines enable the macros/matchit.vim plugin for
" extended matching with the % key.

if exists("loaded_matchit")
  autocmd BufNewFile,BufRead *.e set filetype=eiffel
  let b:match_ignorecase = 0
  if !exists("b:match_words") |
    let b:match_words = '\<\%(do\|if\|from\|check\|across\|inspect\)\>:' . '\<\%(else\|elseif\|until\|loop\|when\):'. '\<end\>'
  endif

endif " exists("loaded_matchit")
