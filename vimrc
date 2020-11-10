noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>


" -----------------------------------------------------------------------------
"     - Colours -
" -----------------------------------------------------------------------------
colorscheme hagsteel


" -----------------------------------------------------------------------------
"     - Debugging -
" -----------------------------------------------------------------------------
nmap <F8> :VBGcontinue<CR>
nmap <F9> :VBGstepOver<CR>
nmap <F10> :VBGstepIn<CR>
nmap <F6> :VBGevalWordUnderCursor<CR>


" -----------------------------------------------------------------------------
"     - Line numbers -
"     Use relative line numbers in insert mode
" -----------------------------------------------------------------------------
" set relativenumber
" set number
" autocmd InsertEnter * :set norelativenumber
" autocmd InsertLeave * :set relativenumber
set nonumber
set norelativenumber


" -----------------------------------------------------------------------------
"     - Default settings -
" -----------------------------------------------------------------------------
set fillchars+=vert:│
syntax on
filetype plugin indent on
set nopreviewwindow
set tabstop=4
set shiftwidth=4
set expandtab
set whichwrap+=<,>,h,l,[,]
set incsearch
set ignorecase
set smartcase
set smartindent
set wildmenu
set wildmode=full
set foldmethod=indent
set foldenable
set foldlevelstart=10
set foldnestmax=10
set noruler
set laststatus=2
set splitright
set splitbelow
set backspace=indent,eol,start
set nowrap
set nohlsearch
set ttimeoutlen=10
set mouse=
" set noshowcmd
set noswapfile
set colorcolumn=110
set nosmd
set noru
set hidden
noremap <F1> :echo "--- lol, accidental F1 ---"<CR>

" -----------------------------------------------------------------------------
"     - Ignore the following when expanding wildcards -
" -----------------------------------------------------------------------------
set wildignore+=*/target/*,*/tmp/*,*.swp,*.pyc,*__pycache__/* 


" -----------------------------------------------------------------------------
"     - Resizing panes -
" -----------------------------------------------------------------------------
nmap <C-h> :vertical resize -4<CR>
nmap <C-l> :vertical resize +4<CR>
nmap <C-k> :resize +4<CR>
nmap <C-j> :resize -4<CR>


" -----------------------------------------------------------------------------
"     - Scratch buffer -
"     Create a new scrach buffer
" -----------------------------------------------------------------------------
functio CreateScratchBuffer(vertical)
    if a:vertical == 1 
        :vnew
    else
        :new
    endif
    :setlocal buftype=nofile
    :setlocal bufhidden=hide
    :setlocal noswapfile
    :set ft=scratch
endfunction
:command! Scratch call CreateScratchBuffer(1)
:command! Scratchh call CreateScratchBuffer(0)


" -----------------------------------------------------------------------------
"     - Status line -
" -----------------------------------------------------------------------------
function s:GetFileType()
    if &filetype ==# "rust"
        return ""
    elseif &filetype ==# "c"
        return ""
    elseif &filetype ==# "python"
        return ""
    elseif &filetype ==# "javascript"
        return ""
    elseif &filetype ==# "vim"
        return ""
    elseif &filetype ==# "clojure"
        return ""
    elseif &filetype ==# "html"
        return ""
    elseif &filetype ==# "haskell"
        return ""
    elseif &filetype ==# "markdown"
        return ""
    elseif &filetype ==# "org"
        return ""
    elseif &filetype ==# "scss"
        return ""
    elseif &filetype ==# "scala"
        return ""
    else
        return "%y" 
endfunction

function s:GetMode()
    if mode() == "n"
        return " N "
    elseif mode() == "i"
        return "%#ModeInsert# I %*"
    elseif mode() == "v"
        return "%#ModeVisual# V %*"
    elseif mode() == "V"
        return "%#ModeVisual# V. %*"
    elseif mode() == "\<C-V>"
        return "%#ModeVisual# VB %*"
    else
        return "[mode: " . mode() . "]"
endfunction
 
function! s:PasteForStatusline()
    let paste_status = &paste
    if paste_status == 1
        return " [paste] "
    else
        return ""
    endif
endfunction
 
function GetStatusLine()
    let l:status_line_left = s:GetMode() 
    let l:status_line_left = status_line_left . " %f" " Filename
    let l:status_line_left = status_line_left . " %M" " Modified
    let l:status_line_left = status_line_left . " %r" " Read only
    let l:status_line_left = status_line_left . s:PasteForStatusline()
    let l:status_line_right = "%=" " Alignt right statusline
    let l:status_line_right = status_line_right . " %c:%l/%L (%p%%) " " col, line, tot. lines
    let l:status_line_right = status_line_right . s:GetFileType() . " " " File type
    return l:status_line_left . l:status_line_right
endfunction
set statusline=%!GetStatusLine()      " File type


" -----------------------------------------------------------------------------
"     - Tab line -
" -----------------------------------------------------------------------------
function! GuiTabLabel()
    let label = ''
    let bufnrlist = tabpagebuflist(v:lnum)
    " Add '+' if one of the buffers in the tab page is modified
    for bufnr in bufnrlist
        if getbufvar(bufnr, "&modified")
            let label = '+'
            break
        endif
    endfor
    " Append the tab number
    let label .= v:lnum.': '
    " Append the buffer name
    let name = bufname(bufnrlist[tabpagewinnr(v:lnum) - 1])
    if name == ''
        " give a name to no-name documents
        if &buftype=='quickfix'
            let name = '[Quickfix List]'
        else
            let name = '[No Name]'
        endif
    else
        " get only the file name
        let name = fnamemodify(name,":t")
    endif
    let label .= name
    " Append the number of windows in the tab page
    let wincount = tabpagewinnr(v:lnum, '$')
    return label . '  [' . wincount . ']'
endfunction


" -----------------------------------------------------------------------------
"     - Ultisnips -
" -----------------------------------------------------------------------------
let g:UltiSnipsExpandTrigger="<leader>t"

set guitablabel=%{GuiTabLabel()}
" -----------------------------------------------------------------------------
"     - FZF -
"     Fuzzy file search with ripgrep
"
"     Additional flags:
"     --column: Show column number
"     --line-number: Show line number
"     --no-heading: Do not show file headings in results
"     --fixed-strings: Search term as a literal string
"     --ignore-case: Case insensitive search
"     --no-ignore: Do not respect .gitignore, etc...
"     --hidden: Search hidden files and folders
"     --follow: Follow symlinks
"     --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
"     --color: Search color options
" -----------------------------------------------------------------------------
nmap <C-p> :FZF<CR>
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)
nmap <C-f> :Find 

" -----------------------------------------------------------------------------
"     - Copy to system clipboard -
"     Copy the selected text into the system clipboard.
"     (Useful if not using tmux)
" -----------------------------------------------------------------------------
if executable("cb")
    vmap <silent> <C-y> y:new<CR>VGp :w !cb -selection clipboard<CR><CR>u:q<CR>:echo "Copy to system clipboard"<CR>
endif
 
" -----------------------------------------------------------------------------
"     - Security fix -
"     modeline is used to look at the first and the last line in a file for
"     ex commands. This is a security issue so it's turned off.  "     
" -----------------------------------------------------------------------------
set nomodeline


" -----------------------------------------------------------------------------
"     - Vim racer -
" -----------------------------------------------------------------------------
autocmd FileType rust nmap <buffer> <leader>k <Plug>(rust-doc)
autocmd FileType rust nmap <buffer> <leader>K <Plug>(rust-doc-tab)
autocmd FileType rust nmap <buffer> gs <Plug>(rust-def-split)
autocmd FileType rust nmap <buffer> gx <Plug>(rust-def-vertical)
 
" ------------------------------------------------------------------------
"       GDB debugging
" ------------------------------------------------------------------------
let g:vebugger_leader='<Leader>d'
let g:vebugger_path_gdb = 'gdb'
let g:vebugger_breakpoint_text=''
let g:vebugger_currentline_text=''


" -----------------------------------------------------------------------------
"     - Org -
"     This is not really org mode, however I got in the habbit
"     of calling them org files. These are just notes
" -----------------------------------------------------------------------------
autocmd BufNewFile,BufRead *.org set ft=org
 
" -----------------------------------------------------------------------------
"     - VimWiki -
" -----------------------------------------------------------------------------
let g:vimwiki_list = [{'path': '~/org', 'syntax': 'markdown', 'ext': '.org'}]

" -----------------------------------------------------------------------------
"     - Date functions -
" -----------------------------------------------------------------------------
" Insert date stamp above current line.
" This is useful when organising tasks in README.md
function! InsertDateStamp()
    let l:date = system('date +\%F')
    let l:oneline_date = split(date, "\n")[0]
    execute "normal! a" . oneline_date . "\<Esc>"
    " call append(line('.'), oneline_date)
endfunction

:command! DS call InsertDateStamp()

" -----------------------------------------------------------------------------
"     - Shader lang -
" -----------------------------------------------------------------------------
autocmd BufNewFile,BufRead *.vert set ft=sl
autocmd BufNewFile,BufRead *.frag set ft=sl
autocmd BufNewFile,BufRead *.comp set ft=sl
autocmd BufNewFile,BufRead *.sl set ft=sl
