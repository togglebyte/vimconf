set makeprg=go\ build
command! CT !clear; go test

" Keymappings
nmap <C-b> :!clear;go build<CR>
nmap <leader>x :!clear;go run %<CR>
