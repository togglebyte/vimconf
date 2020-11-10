set makeprg=go\ build
command! CT !clear; go test

" Keymappings
nmap <C-b> :!clear;go build<CR>
