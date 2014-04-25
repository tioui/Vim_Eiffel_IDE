
let g:vim_eiffel_ide_version = "0.1a"

command! VimEiffelIdeVersion echomsg "Current vim_eiffel version: " . g:vim_eiffel_ide_version

command! -nargs=* EiffelOpen call eiffelide#open(<f-args>)

command! -nargs=* EOpen call eiffelide#open(<f-args>)

command! -nargs=1 EiffelOpenTarget call eiffelide#open_target(<f-args>)

command! -nargs=1 EOpenTarget call eiffelide#open_target(<f-args>)

