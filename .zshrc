# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="gentoo"

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
plugins=(git bzr)

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

NOCOMPILPATH=${PATH}
ENVIRONMENT_FILE=${HOME}/bin/var_env_toolchain.sh
COMPILPATHACTIVE=0

function activate_compilation_path() 
{
  [[ ${COMPILPATHACTIVE} -eq 0 ]] && . ${ENVIRONMENT_FILE} || echo "Compilation path was already active"
  export COMPILPATHACTIVE=1
  export RPS1="compilation path"
}

function deactivate_compilation_path()
{
  export PATH=${NOCOMPILPATH}
  export COMPILPATHACTIVE=0
  unset RPS1
}

function bootstrap_component()
{
  deactivate_compilation_path
  export BRANCH_NAME=$(basename $(dirname $PWD))
  PARENT=$(dirname $PWD)
  YCM_TEMPLATE=${HOME}/.vim/bundle/YouCompleteMe/cpp/ycm/.ycm_extra_conf.py.in
  CLANG_TAGS=${HOME}/dev/clang-tags/build/env.sh

  if [[ "x$1" == "x" ]]; then
    echo "Missing parent branch name"
    return
  elif [[ "x$1" != "x${BRANCH_NAME}" ]]; then
    echo "Parent branch name : ${BRANCH_NAME} differs from $1"
    return
  fi

  if [[ -e "${PWD}/bootstrap.sh" ]]; then
    ./bootstrap.sh \
      --toolchain-dir=/ke/local/toolchain3-x86_64-nptl \
      --kemake-dir=${PARENT}/ke-kemake || return
  else
    echo "Missing ./bootstrap.sh"
    return
  fi

  activate_compilation_path
  RPS1="$RPS1:$BRANCH_NAME"

  take .release
  GRANDPARENT=$(dirname $(dirname $PWD))

  $(dirname $PWD)/configure --with-toolchain-dir=/ke/local/toolchain3-x86_64-nptl --with-kemake-dir=${GRANDPARENT}/ke-kemake --with-common-lib=${GRANDPARENT}/ke-common/.release --with-common-include=${GRANDPARENT}/ke-common

  COMMON_INCLUDE=$(cat Makefile | grep 'COMMON_INCLUDE' | cut -d ' ' -f 3)
  echo "Common include : ${COMMON_INCLUDE}"

  echo "Sourcing variables for clang-tags"
  source ${CLANG_TAGS}
  export CLANG_TAGS_BIN=$(which clang-tags)
  export PROJECT_ROOT=${PARENT}

  # Don't pollute the environment
  unset GRANDPARENT
  unset COMMON_INCLUDE
  unset PARENT
  unset YCM_TEMPLATE
  unset CLANG_TAGS
}

function generate_clang_tags_for_project()
{
  PAR1=''
  PAR2=''
  CLANG_TAGS=${HOME}/dev/clang-tags/build/env.sh
  INCREMENTAL=0
  source ${CLANG_TAGS}

  if [[ "x$1" == "x" || "x${PROJECT_ROOT}" == "x" ]]; then
    echo "Missing project name (did you bootstrap_component the project?)"
    return
  fi

  if [[ -d "${PROJECT_ROOT}/$1" && -e "${PROJECT_ROOT}/$1/Makefile.am" ]]; then
    echo "Generating tags for ${PROJECT_ROOT}/$1"
    echo "Using branch name: ${BRANCH_NAME}"
    if [[ -d "${PROJECT_ROOT}/$1/tests/unit" ]]; then
      echo "Running checks too"
      #MAKE_EXT="check"
    fi
  else
    echo "Project ${PROJECT_ROOT}/$1 doesn't exist (Makefile.am missing or directory doesn't exist)"
    return
  fi

  if [[ -e "${PROJECT_ROOT}/$1/compile_commands.json" ]]; then
    echo "Compilation DB exists, doing incremental build"
    INCREMENTAL=1
  fi

  # Strip folders until we don't fall in the right one
  PAR1=$(dirname ${PROJECT_ROOT}/$1)
  if [[ "${PAR1}" != "${PROJECT_ROOT}" ]]; then
    PAR2=$(dirname $PAR1)
  fi

  RELEASE_DIR=${PAR1}/.release/
  COMPONENT_NAME=$(basename $1)
  cd ${RELEASE_DIR}

  if [[ "x${PAR2}" != "x" ]]; then
    cd ${COMPONENT_NAME}
  fi

  export CLANG_TAGS_BIN=$(which clang-tags)
  [[ ${INCREMENTAL} -eq 0 ]] && make clean 
  ${CLANG_TAGS_BIN} trace make ${MAKE_EXT}

  if [[ -e "${PWD}/compile_commands.json" ]]; then
    if [[ ${INCREMENTAL} -eq 0 ]]; then 
      cp "${PWD}/compile_commands.json" "${PAR1}/${COMPONENT_NAME}"
    else
      cat "${PWD}/compile_commands.json" >> "${PAR1}/${COMPONENT_NAME}/compile_commands.json"
    fi
  fi

  # Moving the .ycm_extra_conf.py in the right place
  ESCAPED_FOLDER=$(echo "${PAR1}/${COMPONENT_NAME}" | sed -e 's/[\/&]/\\&/g')

  cp ${HOME}/bin/ycm_template.py "${PAR1}/${COMPONENT_NAME}/.ycm_extra_conf.py"
  sed -i "s/\$TOBESET/${ESCAPED_FOLDER}/" ${PAR1}/${COMPONENT_NAME}/.ycm_extra_conf.py

  unset PAR1
  unset PAR2
  unset RELEASE_DIR
  unset CLANG_TAGS_BIN
  unset ESCAPED_FOLDER
  unset MAKE_EXT
  unset INCREMENTAL
}

KE_PATH_ACTIVE=0
function activate_ke_path()
{
  if [[ ${KE_PATH_ACTIVE} -eq 0 ]]; then
    export PATH=${PATH}:/ke/bin:/ke/scripts
  fi

  KE_PATH_ACTIVE=1
}

activate_ke_path


AGENT_ENV=${HOME}/.ssh/environment
function start_agent()
{
  if [[ "x$1" == "xforce" ]]; then
    rm -f ${AGENT_ENV}
    killall -9 ssh-agent
  fi

  if [[ -e ${AGENT_ENV} ]]; then
    . ${AGENT_ENV} &> /dev/null
    ssh-add &> /dev/null
    ssh-add ${HOME}/.ssh/id_rsa_kedev &> /dev/null
  else
    ssh-agent > ${AGENT_ENV}
    chmod 0600 ${AGENT_ENV}
    start_agent
  fi
}

start_agent

function prepare_dev()
{
	if [[ "x$1" == "x--help" || "x$1" == "x-h" ]]; then
		echo "$0 <branch_name> <repo1> [repo2 ... repon]"
		echo "   ke-common and ke-kemake are cloned by default"
		return
	fi


  if [[ "x$1" == "x" ]]; then
		echo "$0 <branch_name> <repo1> [repo2 ... repon]"
    echo "Missing branch name"
    return
  fi

	if [[ $# -lt 2 ]]; then
		echo "$0 <branch_name> <repo1> [repo2 ... repon]"
		echo "You have to clone at least one repo"
		return
	fi

  BRANCH_NAME=$1
	shift

  if [[ -d ${HOME}/dev/${BRANCH_NAME} ]]; then
    echo "A Branch with that name exists already"
    return
  fi

  take ${HOME}/dev/${BRANCH_NAME}

  REPOS_TO_CLONE=(ke-common ke-kemake)
  for i; do
    bzr branch mel:${i} mel:${i}/${USER}/${BRANCH_NAME} || return
    bzr co mel:${i}/${USER}/${BRANCH_NAME} ${i} || return
  done

	for repo in ${REPOS_TO_CLONE}; do
    bzr branch mel:${repo} mel:${repo}/${USER}/${BRANCH_NAME} || return
    bzr co mel:${repo}/${USER}/${BRANCH_NAME} ${repo} || return
  done

  unset BRANCH_NAME
	unset REPOS_TO_CLONE
}

function clean_branch()
{
	BRANCH_NAME=$1
	shift

	for i; do
		echo "bzr remove-branch mel:${USER}/${i}/${BRANCH_NAME}"
	done

  REPOS_TO_CLONE=(ke-common ke-kemake)
	for repo in ${REPOS_TO_CLONE}; do
		echo "bzr remove-branch mel:${USER}/${repo}/${BRANCH_NAME}"
  done

	unset REPOS_TO_CLONE
}

function sw_release()
{
  COMP_NAME=$(basename $PWD)

  if [[ -d ../.release/${COMP_NAME} ]]; then
    cd ../.release/${COMP_NAME}
  elif [[ -d ../../${COMP_NAME} ]]; then
    cd ../../${COMP_NAME}
  fi

  unset COMP_NAME
}

export EDITOR=vim
source ~/minion/add_to_your_profile
