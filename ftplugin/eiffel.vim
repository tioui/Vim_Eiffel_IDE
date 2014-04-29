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
