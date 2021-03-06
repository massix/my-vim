# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="gentoo"
#ZSH_THEME="mgengarelli"
ZSH_THEME="ys"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to disable command auto-correction.
# DISABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git bzr dsh ke-project-manager emacs web-search tmux autojump command-not-found nyan lol common-aliases todo-list)

source $ZSH/oh-my-zsh.sh

# User configuration

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games"
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"
#
unset GREP_OPTIONS

start_agent


export EDITOR="$(which emacsclient) -t"
export ALTERNATE_EDITOR="emacs -nw"

[[ -e ~/minion/add_to_your_profile ]] && source ~/minion/add_to_your_profile

# Do not trust ZSH cache for completion
zstyle ":completion:*:commands" rehash 1
zstyle ":completion:*" verbose yes

# Some useful aliases
alias -s      c=${EDITOR}
alias -s      h=${EDITOR}
alias -s     cc=${EDITOR}
alias -s     hh=${EDITOR}
alias -s     js=${EDITOR}
alias -s     am=${EDITOR}
alias -s     in=${EDITOR}
alias -s    ini=${EDITOR}
alias -s    cpp=${EDITOR}
alias -s    hpp=${EDITOR}
alias -s    hxx=${EDITOR}
alias -s    xml=${EDITOR}
alias -s    txt=${EDITOR}
alias -s   conf=${EDITOR}
alias -s   json=${EDITOR}

alias tmux='tmux -2'
alias woman='man' # Stop being sexist.
alias e='emacsclient -t'

fortune
unsetopt auto_name_dirs

bindkey -e

wtdl

[ -e ${HOME}/.zshenv ] && source ${HOME}/.zshenv

