
let g:vim_eiffelstudio_version = "0.1a"

command! VimEiffelStudioVersion echomsg "Current vim_eiffel version: " . g:vim_eiffelstudio_version

command! -nargs=* EiffelOpen call eiffelstudio#open(<f-args>)

command! -nargs=* EOpen call eiffelstudio#open(<f-args>)

command! -nargs=1 EiffelOpenTarget call eiffelstudio#open_target(<f-args>)

command! -nargs=1 EOpenTarget call eiffelstudio#open_target(<f-args>)

let g:is_eiffelstudio_open = 0
