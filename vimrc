" -- Settings {{{
syntax on
filetype off

set t_Co=256
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
" }}}

call vundle#rc()
filetype plugin indent on

" ------ Bundles installed through Vundle ------ {{{
Bundle 'gmarik/vundle'
Bundle 'tpope/vim-fugitive'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'Valloric/YouCompleteMe'
Bundle 'bling/vim-airline.git'
Bundle 'altercation/vim-colors-solarized'
Bundle 'scrooloose/nerdcommenter'
Bundle 'myusuf3/numbers.vim'
Bundle 'plasticboy/vim-markdown'
Bundle 'tpope/vim-sensible'
Bundle 'kien/ctrlp.vim.git'
Bundle 'Raimondi/delimitMate.git'
Bundle 'sickill/vim-monokai.git'
Bundle 'kshenoy/vim-signature.git'
Bundle 'tpope/vim-vinegar.git'
Bundle 'rking/ag.vim.git'
Bundle 'programble/itchy.vim.git'
Bundle 'octol/vim-cpp-enhanced-highlight.git'
Bundle 'osyo-manga/vim-over.git'
Bundle 'gcmt/taboo.vim.git'
Bundle 'benmills/vimux.git'
Bundle 'zhaocai/GoldenView.Vim.git'
Bundle "jnurmine/Zenburn.git"
Bundle "git://repo.or.cz/vcscommand.git"
" }}}

" ----- Bundles tested and removed (but handy to have'em here) ----- {{{
"Bundle 'ludovicchabant/vim-lawrencium'
"Bundle 'mikewest/vimroom.git'
"Bundle 'vim-scripts/a.vim.git'
"Bundle 'Yggdroot/indentLine.git'
"Bundle 'L9'
"Bundle 'SirVer/ultisnips.git'
"Bundle 'honza/vim-snippets.git'
"Bundle 'scrooloose/syntastic'
"Bundle 'airblade/vim-gitgutter.git'
"Bundle 'scrooloose/nerdtree.git'
" }}}

"" Better highlighting for C++ stuff {{{
function! EnhanceSyntax()
    syn match cppFuncDef "::\~\?\zs\h\w*\ze([^)]*\()\s*\(const\)\?\)\?$"
    hi def link cppFuncDef Special
endfunction
" }}}

function! ToggleMouse() "{{{
    if &mouse == 'a'
        set mouse=
    else
        set mouse=a
    endif
    echon "mouse=" &mouse
  endfunction
" }}}

"" Complete "#i" automatgically {{{
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
" }}}

"" Change the background from dark to light with a simple keymap {{{
function! SwitchBackground()
	if &background == 'dark'
		set background=light
	else
		set background=dark
	endif
	echon "background=" &background
endfunction
" }}}

" Shell {{{

function! s:ExecuteInShell(command) " {{{
    let command = join(map(split(a:command), 'expand(v:val)'))
    let winnr = bufwinnr('^' . command . '$')
    silent! execute  winnr < 0 ? 'botright vnew ' . fnameescape(command) : winnr . 'wincmd w'
    setlocal buftype=nowrite bufhidden=wipe nobuflisted noswapfile nowrap nonumber
    echo 'Execute ' . command . '...'
    silent! execute 'silent %!'. command
    silent! redraw
    silent! execute 'au BufUnload <buffer> execute bufwinnr(' . bufnr('#') . ') . ''wincmd w'''
    silent! execute 'nnoremap <silent> <buffer> <LocalLeader>r :call <SID>ExecuteInShell(''' . command . ''')<CR>:AnsiEsc<CR>'
    silent! execute 'nnoremap <silent> <buffer> q :q<CR>'
    silent! execute 'AnsiEsc'
    echo 'Shell command ' . command . ' executed.'
endfunction " }}}
command! -complete=shellcmd -nargs=+ Shell call s:ExecuteInShell(<q-args>)

" }}}

" ------ Beginning of customizations ------ "

" Clang {{{
  let g:clang_complete_copen = 1
  let g:clang_complete_auto = 1
  let g:clang_snippets = 1
  let g:clang_snippets_engine = 'clang_complete'
  let g:clang_complete_macros = 1
  let g:clang_complete_patterns = 1
  let g:clang_close_preview = 1
  let g:clang_user_options = ' -std=c++0x'
	let g:clang_auto_select = 1
" }}}

" Syntastic {{{
	let g:syntastic_cpp_config_file = '.clang_complete'
" }}}

" Jedi {{{
	let g:jedi#autocompletion_command = "<M-space>"
" }}}

" DScanner {{{
	"" These absolute paths have to be fixed for each installation if you need to
	"" use the dscanner plugin to autocomplete the d code.
	let g:dscanner_path = "~/dev/Dscanner/dscanner"
	let g:dscanner_includePath = ['/usr/local/Cellar/dmd/2.061/src/phobos', '/usr/local/Cellar/dmd/2.061/druntime/import']
" }}}
"
" YCM {{{
		let g:ycm_extra_conf_globlist = ['~/.vim/bundle/YouCompleteMe/cpp/ycm/*', './*']
		let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/cpp/ycm/.ycm_extra_conf.py'
		let g:ycm_autoclose_preview_window_after_completion = 1
		let g:ycm_autoclose_preview_window_after_insertion = 1
" }}}

" netrw {{{
    let g:netrw_liststyle=3
    let g:netrw_sort_by="name"
"}}}

" Silver Searcher (AG) {{{
  let g:aghighlight=1                      " Highlight the search terms after searching
  let g:agprg="ag --column --smart-case"   " Always use the smart-case

" }}}

" Custom mappings {{{

  nnoremap <Space> za

  " Random things
	nnoremap <leader>h :nohl<CR>
	nnoremap <leader>m :call ToggleMouse()<CR>
	nnoremap <leader>s :source ~/.vimrc<CR>
	nnoremap <leader>b :call SwitchBackground()<CR>
	nnoremap <leader>n :NumbersToggle<CR>

  " Tabs managements
  nnoremap <leader>d :tabnext<CR>
  nnoremap <leader>a :tabprev<CR>
  nnoremap <leader>w :tabclose<CR>
  nnoremap <leader>e :tabe
  nnoremap <leader>r :TabooRename
  nnoremap <leader>R :TabooReset<CR>

  " YouCompleteMe
  nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>
  nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>
  nnoremap gd :YcmCompleter GoToDefinition<CR>
  nnoremap gD :YcmCompleter GoToDeclaration<CR>
  nnoremap g* :YcmCompleter GoTo<CR>

  " CtrlP plugin
	nnoremap <leader>pm :CtrlPMixed<CR>
  nnoremap <leader>pb :CtrlPBuffer<CR>

  " Shell function
  nnoremap <leader>! :Shell 

  " Grep with ag for the word under cursor
  nnoremap <leader>ag :Ag 
  nnoremap <leader>gw viw"gy:Ag <C-R>g<CR>

  " Same as before, but limit the search to current file (occur)
  nnoremap <leader>go viw"gy:Ag <C-R>g % ~/vim-compile.zsh<CR>
" }}}

" Auto commands {{{
	autocmd Syntax cpp call EnhanceSyntax()

  " Protobuf
	augroup filetype
		au! BufRead,BufNewFile *.proto setfiletype proto
	augroup end

  " Folds in vim files
  augroup filetype_vim
  autocmd!
    autocmd FileType vim setlocal foldmethod=marker
  augroup END

  " Java autocomplete
	autocmd Filetype java setlocal omnifunc=javacomplete#Complete
	autocmd Filetype java setlocal completefunc=javacomplete#CompleteParamsInfo

  " Automatically delete hidden buffers
  "autocmd BufEnter * setlocal bufhidden=delete 

  " Hide fugitive buffers
	autocmd BufReadPost fugitive://* set bufhidden=delete  " Automatically delete fugitive buffers

  " Use markdown for minion notes
  autocmd BufReadPost */notes/*.txt set ft=markdown      " Automatically set markdown for minion notes
" }}}

