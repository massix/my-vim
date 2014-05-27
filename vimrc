syntax on
filetype off

set modelines=5
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

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()


" ------ Bundles installed through Vundle ------ "
Bundle 'gmarik/vundle'
"Bundle 'tpope/vim-fugitive'
Bundle 'Lokaltog/vim-easymotion'
"Bundle 'L9'
Bundle 'Valloric/YouCompleteMe'
Bundle 'bling/vim-airline.git'
Bundle 'altercation/vim-colors-solarized'
Bundle 'scrooloose/nerdcommenter'
"Bundle 'scrooloose/nerdtree'
Bundle 'myusuf3/numbers.vim'
Bundle 'plasticboy/vim-markdown'
Bundle 'tpope/vim-sensible'
"Bundle 'scrooloose/syntastic'
Bundle 'ludovicchabant/vim-lawrencium'
Bundle 'kien/ctrlp.vim.git'
"Bundle 'airblade/vim-gitgutter.git'
Bundle 'Raimondi/delimitMate.git'
"Bundle 'SirVer/ultisnips.git'
"Bundle 'honza/vim-snippets.git'
Bundle 'sickill/vim-monokai.git'
Bundle 'kshenoy/vim-signature.git'
Bundle 'tpope/vim-vinegar.git'

filetype plugin indent on


"" Functions have to be at the very beginning

"" Better highlighting for C++ stuff
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

"" Complete "#i" automatgically
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

"" Change the background from dark to light with a simple keymap
function! SwitchBackground()
	if &background == 'dark'
		set background=light
	else
		set background=dark
	endif
	echon "background=" &background
endfunction


" ------ Beginning of customizations ------ "


" Clang stuff {
	let g:clang_complete_copen = 1
	let g:clang_complete_auto = 1
	let g:clang_snippets = 1
	let g:clang_snippets_engine = 'clang_complete'
	let g:clang_complete_macros = 1
	let g:clang_complete_patterns = 1
	let g:clang_close_preview = 1
	let g:clang_user_options = ' -std=c++0x'
	let g:clang_auto_select = 1
" }

" Syntastic stuff {
	let g:syntastic_cpp_config_file = '.clang_complete'
" }

" JavaComplete stuff {
	autocmd Filetype java setlocal omnifunc=javacomplete#Complete
	autocmd Filetype java setlocal completefunc=javacomplete#CompleteParamsInfo
" }

" NerdTree stuff {
	"let NERDChristmasTree = 1
	"let NERDTreeChDirMode = 2
" }

" Jedi stuff {
	let g:jedi#autocompletion_command = "<M-space>"
" }

" DScanner stuff {
	"" These absolute paths have to be fixed for each installation if you need to
	"" use the dscanner plugin to autocomplete the d code.
	let g:dscanner_path = "~/dev/Dscanner/dscanner"
	let g:dscanner_includePath = ['/usr/local/Cellar/dmd/2.061/src/phobos', '/usr/local/Cellar/dmd/2.061/druntime/import']
" }

" Custom mappings {
	nmap <leader>h :nohl<CR>
	"nmap <leader>t :NERDTreeToggle<CR>
	nmap <leader>m :call ToggleMouse()<CR>
	nmap <leader>s :source ~/.vimrc<CR>
	nmap <leader>b :call SwitchBackground()<CR>
	nmap <leader>n :NumbersToggle<CR>

	iab #i <C-R>=SmartInclude()<CR>
" }


" Random stuff {
	autocmd Syntax cpp call EnhanceSyntax()

	augroup filetype
		au! BufRead,BufNewFile *.proto setfiletype proto
	augroup end
" }

" YCM {
		let g:ycm_extra_conf_globlist = ['~/.vim/bundle/YouCompleteMe/cpp/ycm/*', './*']
		let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/cpp/ycm/.ycm_extra_conf.py'
		let g:ycm_autoclose_preview_window_after_completion = 1
		let g:ycm_autoclose_preview_window_after_insertion = 1

		nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>
		nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>
" }

" EasyMotion {
	"map / <Plug>(easymotion-sn)
	"omap / <Plug>(easymotion-tn)
	"map n <Plug>(easymotion-next)
	"map N <Plug>(easymotion-prev)
	"nmap s <Plug>(easymotion-s2)
	"nmap t <Plug>(easymotion-t2)
" }

" CtrlP {
	nmap <leader>T :CtrlPMixed<CR>
" }

" I need to remap these in order to avoid conflicts with YCM
" UltiSnips {

	"function! g:UltiSnips_Complete()
		"call UltiSnips#ExpandSnippet()
		"if g:ulti_expand_res == 0
			"if pumvisible()
				"return "\<C-n>"
			"else
				"call UltiSnips#JumpForwards()
				"if g:ulti_jump_forwards_res == 0
					"return "\<TAB>"
				"endif
			"endif
		"endif
		"return ""
	"endfunction

	"au BufEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"
	"let g:UltiSnipsJumpForwardTrigger="<tab>"
	"let g:UltiSnipsListSnippets="<c-e>"

	"let g:UltiSnipsSnippetDirectories=["UltiSnips"]

	" Use the followings if the function doesn't work properly
	"let g:UltiSnipsExpandTrigger="<c-j>"
	"let g:UltiSnipsJumpForwardTrigger="<c-j>"
	"let g:UltiSnipsJumpBackwardTrigger="<c-k>"
" }

" Fugitive config {
	autocmd BufReadPost fugitive://* set bufhidden=delete  " Automatically delete fugitive buffers
" }

