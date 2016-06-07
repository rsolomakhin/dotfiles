# -*- sh -*-
#
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

export ALTERNATE_EDITOR=""
export ANDROID_HOME=$HOME/android-sdk-linux
export CHROME_DEVEL_SANDBOX=/usr/local/sbin/chrome-devel-sandbox
export EDITOR="$VIM"
export EMACS="emacsclient -t"
export FZF_CTRL_T_COMMAND="git ls || find"
export FZF_DEFAULT_COMMAND="git ls"
export GOPATH=$HOME/go
export GYP_GENERATORS="ninja"
export HISTCONTROL="ignoredups:erasedups"
export PYTHONPATH=$HOME/python:$PYTHONPATH
export VIM="vim"
[ -z "$GYP_DEFINES" ] && export GYP_DEFINES="component=shared_library"

HELPERS="/usr/lib/git-core/git-sh-prompt
/usr/local/git/current/share/git-core/git-prompt.sh
/usr/local/git/current/share/git-core/git-completion.bash
/etc/bash_completion.d/git-prompt
$HOME/google-cloud-sdk/completion.bash.inc
$HOME/.fzf.bash"
for helper in $HELPERS; do [ -f $helper ] && source $helper; done

if type __git_ps1 >& /dev/null; then
  export PS1='[\u@\h \w$(__git_ps1 " (%s)")]\$ '
else
  export PS1='[\u@\h \w]\$ '
fi

if [ -d /usr/share/vim/vim74 ]; then
  export VIMRUNTIME=/usr/share/vim/vim74
fi

if [ -d ~/homebrew/bin ]; then
  PREFIX=$HOME/homebrew/bin
  if [[ $PATH != $PREFIX:* ]]; then
    PATH=$PREFIX:${PATH/:$PREFIX}
  fi
  if [ -d ~/homebrew/share/vim/vim74 ]; then
    export VIMRUNTIME=$HOME/homebrew/share/vim/vim74
  fi
fi

TOOLS="$GOPATH/bin
$HOME/android-sdk-linux/platform-tools
$HOME/android-sdk-linux/tools
$HOME/depot_tools
$HOME/google-cloud-sdk/bin
$HOME/gradle/bin
$HOME/node/bin
$HOME/python/bin
$HOME/software/bin"
for tool in $TOOLS; do
  [[ -d $tool && $PATH != *$tool* ]] && PATH=$PATH:$tool
done
export PATH

alias e="$EDITOR"
alias em="$EMACS"
alias ema="$EMACS"
alias emac="$EMACS"
alias emacs="$EMACS"
alias grep="grep --color=auto"
alias ggrep="git grep"
alias j="jobs"
alias so="source"
alias v="$VIM"
alias vi="$VIM"

unalias ls >& /dev/null
ls --version >& /dev/null && alias ls="ls --color=auto" || alias ls="ls -G"

# Disable flow control (Ctrl-S).
stty -ixon

# Resume SSH agent.
restart_ssh_agent() {
  rm -f ~/.ssh_agent.sh
  killall -9 ssh-agent
  ssh-agent -s > ~/.ssh_agent.sh
  source ~/.ssh_agent.sh
}
if ! ssh-add -l >& /dev/null; then
  if [ -f ~/.ssh_agent.sh ]; then
    source ~/.ssh_agent.sh
    if ! ssh-add -l; then
      restart_ssh_agent
    fi
  else
    restart_ssh_agent
  fi
fi
if ! ssh-add -l | grep /.ssh/ >& /dev/null; then
  for file in ~/.ssh/*.pub; do
    ssh-add ${file/.pub}
  done
fi
