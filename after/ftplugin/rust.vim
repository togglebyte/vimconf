" -----------------------------------------------------------------------------
"     - General settings -
" -----------------------------------------------------------------------------
set nospell
set nowrap
set textwidth=99
set makeprg=cargo\ check

" -----------------------------------------------------------------------------
"     - Rust help -
" -----------------------------------------------------------------------------
function! RustDocs()
    let l:word = expand("<cword>")
    :call RustMan(word)
endfunction

function! RustMan(word)
    let l:command  = ':vertical term ++close rusty-man ' . a:word
    execute command
endfunction

:command! -nargs=1 Rman call RustMan(<f-args>)

" -----------------------------------------------------------------------------
"     - Key mappings -
" -----------------------------------------------------------------------------
nmap <S-k> :call RustDocs()<CR>
nmap <C-b> :make<CR>
nmap <Leader>} ysiw}
nmap <Leader>x :!clear;cargo run<CR>
nmap <Leader>X :!clear;env RUST_BACKTRACE=1 cargo run<CR>
nmap <Leader>f :RustFmt<CR>
nmap <Leader>b :!clear;cargo test -- --nocapture<CR>
nmap <Leader>B :!clear;env RUST_BACKTRACE=1 cargo test -- --nocapture<CR>
nmap gd <Plug>(rust-def)
nmap gv <Plug>(rust-def-vertical)
nmap <F5> :RB<CR>


" -----------------------------------------------------------------------------
"     - Abbreviations -
" -----------------------------------------------------------------------------
ia pp eprintln!("{:?}",);<Left><Left>
ia cmt cmt<Leader>t<Left>
ia dd #[derive(Debug)]


" -----------------------------------------------------------------------------
"     - Debug stuff -
" -----------------------------------------------------------------------------
" Find rust function name
" Taken from rust.vim (https://github.com/rust-lang/rust.vim)
let g:vebugger_path_gdb = 'rust-gdb'
function! FindTestFunctionNameUnderCursor() abort
    let cursor_line = line('.')

    " Find #[test] attribute
    if search('\m\C#\[test\]', 'bcW') is 0
        return ''
    endif

    " Move to an opening brace of the test function
    let test_func_line = search('\m\C^\s*fn\s\+\h\w*\s*(.\+{$', 'eW')
    if test_func_line is 0
        return ''
    endif

    " Search the end of test function (closing brace) to ensure that the
    " cursor position is within function definition
    normal! %
    if line('.') < cursor_line
        return ''
    endif

    return matchstr(getline(test_func_line), '\m\C^\s*fn\s\+\zs\h\w*')
endfunction

function FindTestExecutable(test_func_name) abort
    let l:command = 'cargo test ' . a:test_func_name . ' -v'
    let l:test_output = system(command)
    let l:lines = reverse(split(test_output, '\n'))

    let l:use_next=0
    for line in lines
        if (line=~'Running')
            let l:fragments = split(line)

            " Use this line to get the path to the executable
            if l:use_next > 0 
                let l:test_exec = split(fragments[1], '`')[0]
                if len(fragments) < 3
                    return test_exec
                endif
                let l:test_name = split(fragments[2], '`')[0]
                return join([test_exec, test_name], " ")
            endif

            " If there was more than zero tests run
            " use the next available executable
            if str2nr(fragments[1]) > 0
                let l:use_next = 1
            endif
        endif
    endfor 

    return ''
endfunction

function RunDebuggerFromTest()
    echo "building ..."
    let l:test_func_name = FindTestFunctionNameUnderCursor()
    let l:test_bin_path = FindTestExecutable(l:test_func_name)
    let l:command = ':VBGstartGDB ' . test_bin_path
    execute command
endfunction

function DebugProject()
    let l:path_fragments = split(getcwd(), '/')
    let l:project_name = path_fragments[-1]
    let l:bin_dir = 'target/debug/'
    let l:bin_path = bin_dir . project_name
    if filereadable(bin_path)
        let l:command = ':VBGstartGDB ' . bin_path
        execute command
    endif
endfunction

function RunDebuggerFromMain()
    echo "building ..."
    " Build project to ensure we have target/debug
    let l:command = 'cargo build'
    let l:output = system(command)
    call DebugProject()
endfunction

:command! RD call RunDebuggerFromTest()
:command! RB call RunDebuggerFromMain()
