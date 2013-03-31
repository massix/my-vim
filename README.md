My VIM Configuration
====================

## Plugins installed
- clang_complete: provides intellisense for C, C++, Objective-C and Objective-C++ codes
  with no effort needed to configure it.
- cocoa.vim: provides some support for Obj-C and Obj-C++ programming on Mac OS platform
- conque: terminal in VIm
- dwm: tiled window management for vim made easy
- gundo: provides a visual tree of the undo history for the files
- javacomplete: the name says it all
- jedi-vim: autocompletion for python (you have to manually install jedi, using pip)
- jellybeans: darkish colorscheme
- minibufexpl: tabbing made easy on Vim using buffers
- nerdcommenter: commenting the code will be the sexiest thing you will ever do
- nerdtree: file explorer à la Eclipse
- numbers.vim: relative numbering positioning
- powerline (+ fonts): a true statusline for your vim (you have to manually install
  	powerline, using pip)
- snipmate.vim: autocomplete snippets in any language
- syntastic: on-the-fly syntax checking (have to be tuned a little bit for java if you
  	use weird classpaths, otherwise it goes along just fine with clang_complete)
- vim-colors-solarized: light-weight light colorscheme
- vim-easymotion: move anywhere in your code with a few keystrokes
- vim-fugitive: git interface for vim
- vim-gitgutter: git helpers
- vim-irblack: another darkish theme
- vim-markdown: markdown syntax
- vim-sensible: collection of defaults for vim that no-one should complain about
- yankring: copy/paste made easy à la emacs

## How to use it
1. Clone the repo:
   `git clone https://github.com/massix/my-vim ~/.vim`

2. Initialize the submodules from withing your `~/.vim`:
   `git submodules update --init`

3. Install the missing packages using pip:
   `pip install jedi powerline`

4. Create a `~/.vimrc` that does nothing but loading the provided `vimrc`:
   `echo 'source ~/.vim/vimrc' >> ~/.vimrc`

5. Have fun!

