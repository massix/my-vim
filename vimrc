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
  set display=lastline
  set rtp+=~/.vim/bundle/vundle/
  set conceallevel=2
  set concealcursor=vin
" }}}

call vundle#rc()
filetype plugin indent on

" ------ Plugins installed through Vundle ------ {{{
  Plugin 'gmarik/vundle.git'
  Plugin 'tpope/vim-fugitive.git'
  Plugin 'Lokaltog/vim-easymotion.git'
  Plugin 'Valloric/YouCompleteMe.git'
  Plugin 'bling/vim-airline.git'
  Plugin 'altercation/vim-colors-solarized.git'
  Plugin 'scrooloose/nerdcommenter.git'
  Plugin 'myusuf3/numbers.vim.git'
  Plugin 'plasticboy/vim-markdown.git'
  Plugin 'tpope/vim-sensible.git'
  Plugin 'kien/ctrlp.vim.git'
  Plugin 'Raimondi/delimitMate.git'
  Plugin 'sickill/vim-monokai.git'
  Plugin 'kshenoy/vim-signature.git'
  Plugin 'tpope/vim-vinegar.git'
  Plugin 'rking/ag.vim.git'
  Plugin 'programble/itchy.vim.git'
  Plugin 'octol/vim-cpp-enhanced-highlight.git'
  Plugin 'osyo-manga/vim-over.git'
  Plugin 'gcmt/taboo.vim.git'
  Plugin 'benmills/vimux.git'
  Plugin 'zhaocai/GoldenView.Vim.git'
  Plugin 'jnurmine/Zenburn.git'
  Plugin 'git://repo.or.cz/vcscommand.git'
  Plugin 'vim-scripts/vimwiki.git'
  Plugin 'mhinz/vim-signify.git'
  Plugin 'edkolev/promptline.vim.git'
  Plugin 'edkolev/tmuxline.vim.git'
  Plugin 'fabi1cazenave/suckless.vim.git'
  Plugin 'inside/vim-search-pulse.git'
  Plugin 'flazz/vim-colorschemes.git'
  Plugin 'terryma/vim-multiple-cursors.git'
  Plugin 'bling/vim-bufferline.git'
  Plugin 'fatih/vim-go.git'
  Plugin 'itchyny/calendar.vim.git'
  Plugin 'scrooloose/nerdtree.git'
  Plugin 'majutsushi/tagbar.git'
  Plugin 'ludovicchabant/vim-gutentags'
  Plugin 'jeetsukumaran/vim-buffergator.git'
  "Plugin 'xolox/vim-misc.git'
  "Plugin 'xolox/vim-easytags.git'
" }}}

" ----- Plugins tested and removed (but handy to have'em here) ----- {{{
  "Plugin 'ludovicchabant/vim-lawrencium'
  "Plugin 'mikewest/vimroom.git'
  "Plugin 'vim-scripts/a.vim.git'
  "Plugin 'Yggdroot/indentLine.git'
  "Plugin 'L9'
  "Plugin 'SirVer/ultisnips.git'
  "Plugin 'honza/vim-snippets.git'
  "Plugin 'scrooloose/syntastic'
  "Plugin 'airblade/vim-gitgutter.git'
  "Plugin 'thetoast/diff-fold.git'
  "Plugin 'godlygeek/csapprox.git'
  "Plugin 'chrisbra/NrrwRgn.git'
" }}}

"" Better highlighting for C++ stuff {{{
  function! EnhanceSyntax()
    syn match cppFuncDef "::\~\?\zs\h\w*\ze([^)]*\()\s*\(const\)\?\)\?$"
    hi def link cppFuncDef Special
  endfunction
" }}}

" ToggleMouse {{{
  function! ToggleMouse()
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
    if has('gui_running')
      if &background == 'dark'
        set background=light
      else
        set background=dark
      endif
      echon "background=" &background
    else
      echon "Terminal mode."
    endif
  endfunction
" }}}

" Move the cursor a-la Emacs  {{{
  function! MoveCursorToBeginningOfLine()
    let position = getpos(".")
  endfunction
" }}}

" Shell {{{
  function! s:ExecuteInShell(command)
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
  endfunction
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

" Airline {{{
  " Extensions
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#show_buffers = 1
  let g:airline#extensions#tabline#show_tab_nr = 1
  let g:airline#extensions#tmuxline#enabled = 1
  let g:airline#extensions#nrrwrgn#enabled = 1
  let g:airline#extensions#bufferline#enabled = 1
  let g:airline#extensions#branch#enabled = 1
  let g:airline#extensions#branch#use_vcscommand = 0
  let g:airline#extensions#syntastic#enabled = 1
  let g:airline#extensions#tagbar#enabled = 1
  let g:airline#extensions#hunks#enabled = 1
  let g:airline#extensions#ctrlp#color_template = 'visual'
  let g:airline#extensions#ctrlp#show_adjacent_modes = 1

  " Random
  let g:airline_inactive_collapse = 0
  let g:airline_powerline_fonts = 1
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
  let g:ycm_autoclose_preview_window_after_completion = 0
  let g:ycm_autoclose_preview_window_after_insertion = 0
  let g:ycm_collect_identifiers_from_tags_files = 1
  let g:ycm_add_preview_to_completeopt = 1
  let g:ycm_key_list_select_completion = ['<TAB>', '<Down>', '<Enter>']
  let g:ycm_key_list_previous_completion = ['<S-TAB>', '<Up>', '<S-Enter>']
  let g:ycm_key_invoke_completion = '<C-Space>'
  let g:ycm_key_detailed_diagnostics = '<leader>yd'
  let g:ycm_confirm_extra_conf = 0
  let g:ycm_goto_buffer_command = 'vertical-split'
" }}}
"
" vimwiki {{{

  " My main wiki hosted on Dropbox
  let dx_wiki={}
  let dx_wiki.path = '~/Dropbox/vimwiki'
  let dx_wiki.path_html = '~/Dropbox/vimwiki_html'
  let dx_wiki.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'zsh' : 'zsh'}
  let dx_wiki.diary_rel_path = 'blog/'
  let dx_wiki.diary_index = 'diary'

  " I also happen to have a local wiki that is machine-dependent
  let prs_wiki={}
  let prs_wiki.path = '~/vimwiki'
  let prs_wiki.path_html = '~/vimwiki_html'

  " Set all the wikis.
  let g:vimwiki_list = [dx_wiki, prs_wiki]
"}}}

" netrw {{{
  let g:netrw_liststyle=3
  let g:netrw_sort_by="name"
"}}}

" Silver Searcher (AG) {{{
  let g:aghighlight=1                      " Highlight the search terms after searching
  let g:agprg="ag --column --smart-case"   " Always use the smart-case
" }}}

" CtrlP {{{
  "let g:ctrlp_user_command = {
  "\   'types' : {
  "\     1: ['.git', 'cd %s && git ls-files'],
  "\     2: ['.hg', 'hg --cwd %s locate -I .'],
  "\     3: ['.bzr', 'bzr ls -R'],
  "\   },
  "\   'fallback': 'find %s -type f',
  "\ }
" }}}

" Gutentags {{{
  let g:gutentags_executable = 'ctags-exuberant'
  let g:gutentags_project_root = ['Makefile.am', 'Makefile', 'Makefile.in']
" }}}

" Calendar {{{
  let g:calendar_google_calendar = 1
  let g:calendar_google_task = 1
" }}}

" Pulse {{{
  let g:vim_search_pulse_mode = 'pattern'
  let g:vim_search_pulse_color_list = [22, 28, 34, 40, 46]
  let g:vim_search_pulse_duration = 400
" }}}

" NerdTree {{{
  let NERDTreeChDirMode = 2
  let NERDTreeMouseMode = 3
  let NERDTreeShowBookmarks = 1
  let NERDTreeWinPos = "right"
  let NERDTreeDirArrows = 1
  let NERDTreeAutoDeleteBuffer = 1
" }}}

" Custom mappings {{{

  nnoremap <Space> za

  " vimrc managements
  nnoremap <leader>sv :source $MYVIMRC<CR>
  nnoremap <leader>ev :vsp $MYVIMRC<CR>

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
  nnoremap <leader>! :Shell<space>

  " Grep with ag for the word under cursor
  nnoremap <leader>ag :Ag<Space>
  nnoremap <leader>gw viw"gy:Ag <C-R>g<CR>

  " Same as before, but limit the search to current file (occur)
  nnoremap <leader>go viw"gy:Ag <C-R>g % ~/vim-compile.zsh<CR>

  " Grep with ag for the word under cursor and add the results to the current
  " window
  nnoremap <leader>aga :AgAdd<Space>
  nnoremap <leader>gwa viw"gy:AgAdd <C-R>g<CR>

  " Same as before, but limit the search to current file (occur) and add the
  " results to the current window
  nnoremap <leader>goa viw"gy:AgAdd <C-R>g % ~/vim-compile.zsh<CR>

  " Cursor is in a class names, it will give the list of all the functions in
  " the file
  nnoremap <leader>gc viw"gy:Ag <C-R>g:: % ~/vim-compile.zsh<CR>

  " Cursor is in a class names, it will give the list of all the functions in
  " the file and add the results to the current window
  nnoremap <leader>gca viw"gy:AgAdd <C-R>g:: % ~/vim-compile.zsh<CR>

  " Pulse
  nmap n n<Plug>Pulse
  nmap N N<Plug>Pulse
  nmap * *<Plug>Pulse
  nmap # #<Plug>Pulse
  cmap <enter> <Plug>PulseFirst

  nnoremap ; :

  "" Quick save files
  nmap <leader>s :w!<CR>
  nmap <leader>sa :wa!<CR>

  nnoremap <leader>ev :vsplit $MYVIMRC<CR>
  nnoremap <leader>sv :so $MYVIMRC<CR>

  " Useless things.. comfy to have though.
  vnoremap <leader>" <ESC>`<i"<ESC>`>la"<ESC>
  vnoremap <leader>' <ESC>`<i'<ESC>`>la'<ESC>
  vnoremap <leader>( <ESC>`<i(<ESC>`>la)<ESC>
  vnoremap <leader>{ <ESC>`<i{<ESC>`>la}<ESC>

  " A nice cat..
  nnoremap <leader>cat :echo ">^.^<"<CR>

  " A reminder
  nnoremap <leader>fap :echo "The fappening"<CR>

  " Readline bindings (sorry, pure VIm users.)
  inoremap <C-e> <ESC>$a
  inoremap <C-a> <ESC>^i
  inoremap <C-k> <ESC>ldg_a
  inoremap <C-y> <ESC>pA

  " NerdTree
  nnoremap <leader>nn :NERDTreeToggle<CR>
  nnoremap <leader>nr :NERDTreeFocus<CR>:vertical resize 31<CR>

  " Tagbar
  nnoremap <leader>T :TagbarToggle<CR>

  " Remap <C-c> to behave like <ESC>
  inoremap <C-c> <ESC>
  vnoremap <C-c> <ESC>
  nnoremap <C-c> <ESC>
" }}}

" Chords {{{
  " NerdTree
  nnoremap <C-x><C-f> :NERDTreeToggle<CR>
  nnoremap <C-x><C-e> :NERDTreeFocus<CR>:vertical resize 31<CR>

  nnoremap <C-x><C-d> :TagbarToggle<CR>
  nnoremap <C-x><C-a> :wa!<CR>
  nnoremap <C-x><C-o> viw"gy:Ag <C-R>g % ~/vim-compile.zsh<CR>
  nnoremap <C-x><C-p> :CtrlP<CR>
  nnoremap <C-x><C-t> :tabe<CR>
  nnoremap <C-x><C-w> :tabclose<CR>
" }}}

" Auto commands {{{
  autocmd Syntax cpp call EnhanceSyntax()

" Protobuf
  augroup filetype
    autocmd!
    au! BufRead,BufNewFile *.proto setfiletype proto
  augroup end

  " Folds in vim files
  augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
  augroup END

  augroup filetype_go
    autocmd!
    autocmd BufRead,BufNewFile *.go setfiletype go
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

