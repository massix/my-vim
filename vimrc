syntax on
filetype plugin indent on

set modelines=5
set guifont=Menlo\ for\ Powerline:h10
set ts=2
set sw=2
set nocp
set autoindent
set smartindent
set cindent
set hlsearch
set number
set cursorline
set mouse=a
set ruler
set showmatch
set path=$PWD/**
set showcmd
set wildmode=list:full
set display=lastline
set shiftround
set smarttab
set incsearch
set ignorecase
set smartcase
set hlsearch
set laststatus=2
set statusline=%2*[%02n]%*\ %f\ %3*%(%m%)%4*%(%r%)%*%=%b\ %{fugitive#statusline()}\ 0x%B\ \ <%l,%c%V>\ %P
set display=lastline

" Clang stuff {
	let g:clang_complete_copen = 1
	let g:clang_complete_auto = 1
	let g:clang_snippets = 1
	let g:clang_snippets_engine = 'clang_complete'
	let g:clang_complete_macros = 1
	let g:clang_complete_patterns = 1
	let g:clang_close_preview = 1
" }

" Syntastic stuff {
	let g:syntastic_cpp_config_file = '.clang_complete'
" }

" JavaComplete stuff {
	autocmd Filetype java setlocal omnifunc=javacomplete#Complete
	autocmd Filetype java setlocal completefunc=javacomplete#CompleteParamsInfo
" }

function! EnhanceSyntax()
    syn match cppFuncDef "::\~\?\zs\h\w*\ze([^)]*\()\s*\(const\)\?\)\?$"
    hi def link cppFuncDef Special
endfunction

function! ToggleMouse()
    if &mouse == 'a'
        set mouse=
    else
        set mouse=a
    endif
    echon "mouse=" &mouse
endfunction

function! SmartInclude()
    let next = nr2char( getchar( 0 ) )
    if next == '"'
        return "#include \".hpp\"\<Left>\<Left>\<Left>\<Left>\<Left>"
    endif
    if next == '<'
        return "#include <>\<Left>"
    endif
    return "#include <.h>\<Left>\<Left>\<Left>"
endfunction

function! SwitchBackground()
	if &background == 'dark'
		set background=light
	else
		set background=dark
	endif
	echon "background=" &background
endfunction

nmap <leader>h :nohl<CR>
nmap <leader>t :NERDTreeToggle<CR>
nmap <leader>m :call ToggleMouse()<CR>
nmap <leader>s :source ~/.vimrc<CR>
nmap <leader>b :call SwitchBackground()<CR>
nmap <leader>g :GundoToggle<CR>
nmap <leader>n :NumbersToggle<CR>
nmap <leader>y :YRShow<CR>

iab #i <C-R>=SmartInclude()<CR>

autocmd Syntax cpp call EnhanceSyntax()

augroup filetype
  au! BufRead,BufNewFile *.proto setfiletype proto
augroup end

"" Customizations for NERDTree
let NERDChristmasTree = 1
let NERDTreeChDirMode = 2

"" Jedi stuff
let g:jedi#autocompletion_command = "<M-space>"

" This is to activate Powerline, unluckily it gives problems with the
" autocompletion stuff :(
set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim

call pathogen#infect()

" This has to be called after the pathogen infect
if has("gui_running")
	"set background=dark
	colo jellybeans
else
	colo evening
endif

