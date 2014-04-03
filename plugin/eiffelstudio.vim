
let g:vim_eiffelstudio_version = "0.1a"

command! VimEiffelStudioVersion echomsg "Current vim_eiffel version: " . g:vim_eiffelstudio_version

command! -nargs=* OpenEiffelStudio call eiffelstudio#open(<f-args>)

let g:is_eiffelstudio_open = 0
