# Copyright 2015 Rouslan Solomakhin
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
PATH=$PATH:$HOME/android-sdk-linux/platform-tools
PATH=$PATH:$HOME/android-sdk-linux/tools
PATH=$PATH:$HOME/depot_tools
PATH=$PATH:$HOME/software/bin
PATH=$PATH:$HOME/quickopen
export PATH
export CHROME_DEVEL_SANDBOX=/usr/local/sbin/chrome-devel-sandbox
export CHROMIUM=$HOME/chrome/src
export EDITOR='vim'

# Resume SSH agent.
[ -e ~/.ssh_agent.sh ] && source ~/.ssh_agent.sh > /dev/null 2>&1
if ! ssh-add -l > /dev/null 2>&1; then
  killall -9 ssh-agent > /dev/null 2>&1
  ssh-agent -s > ~/.ssh_agent.sh
  source ~/.ssh_agent.sh > /dev/null 2>&1
  for file in ~/.ssh/*.pub; do
    ssh-add ${file/.pub}
  done
fi

alias e="emacs"
alias em="emacs"
alias grep="grep --color=auto"
ls --color=auto > /dev/null 2>&1 && alias ls="ls --color=auto"
alias so="source"
alias vi="vim"
alias v="vim"
alias xterm='xterm -e zsh'
alias zshrc='vim ~/.zshrc'

alias -s cc=vim
alias -s cpp=vim
alias -s gypi=vim
alias -s gyp=vim
alias -s html=vim
alias -s h=vim
alias -s java=vim
alias -s js=vim
alias -s xml=vim

# Disable flow control (Ctrl-S).
stty -ixon

# Colorful manuals.
man() {
  env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
    PAGER=/usr/bin/less \
    _NROFF_U=1 \
    PATH=${HOME}/bin:${PATH} \
             man "$@"
}

# Save and share history.
export HISTSIZE=1000
if ((!EUID)); then
  export HISTFILE=~/.history_root
else
  export HISTFILE=~/.history
fi
export SAVEHIST=1000

# Vi editing mode.
bindkey -v
autoload -U colors && colors
_INS="%{$bg_bold[cyan]%}%{$fg[white]%} INSERT %{$reset_color%}%{$fg[cyan]%}%{$reset_color%}%{$fg[green]%}%n@%m%{$reset_color%}:%{$fg[blue]%}%~%{$reset_color%}%% "
_NRM="%{$bg_bold[green]%}%{$fg[white]%} NORMAL %{$reset_color%}%{$fg[green]%}%{$reset_color%}%{$fg[green]%}%n@%m%{$reset_color%}:%{$fg[blue]%}%~%{$reset_color%}%% "
precmd() {
  PROMPT=$_INS
}
zle-keymap-select() {
  [[ $KEYMAP = vicmd ]] && PROMPT=$_NRM || PROMPT=$_INS
  () { return $__prompt_status }
  zle reset-prompt
}
zle-line-init() {
  typeset -g __prompt_status="$?"
}
zle -N zle-keymap-select
zle -N zle-line-init
bindkey '^?' backward-delete-char
bindkey '^G' what-cursor-position
bindkey '^h' backward-delete-char
bindkey "^R" history-incremental-search-backward
export KEYTIMEOUT=1
