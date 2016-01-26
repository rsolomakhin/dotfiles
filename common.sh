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
export CHROMIUM=$HOME/chrome/src
export EMACS="emacsclient -t"
export VIM="vim"
export EDITOR="$VIM"
export GOPATH=$HOME/go
export GYP_GENERATORS="ninja"
export HISTCONTROL="ignoredups:erasedups"
export FZF_DEFAULT_COMMAND="git ls || find"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

if [ -d ~/software/share/vim/vim74 ]; then
  export VIMRUNTIME=$HOME/software/share/vim/vim74
elif [ -d /usr/share/vim/vim74 ]; then
  export VIMRUNTIME=/usr/share/vim/vim74
fi

if [ -f /usr/lib/git-core/git-sh-prompt ]; then
  source /usr/lib/git-core/git-sh-prompt
elif [ -f /usr/local/git/current/share/git-core/git-prompt.sh ]; then
  source /usr/local/git/current/share/git-core/git-prompt.sh
fi

if type __git_ps1 >& /dev/null; then
  export PS1='[\u@\h \w$(__git_ps1 " (%s)")]\$ '
else
  export PS1='[\u@\h \w]\$ '
fi

[ -z "$GYP_DEFINES" ] && export GYP_DEFINES="component=shared_library"
[ "$TERM" == "dumb" ] && export PAGER=cat

PREFIX=$HOME/software/bin
if [[ $PATH != $PREFIX:* ]]; then
  PATH=$PREFIX:$PATH
fi

if [[ $PATH != *depot_tools* ]]; then
  PATH=$PATH:$GOPATH/bin
  PATH=$PATH:$HOME/android-sdk-linux/platform-tools
  PATH=$PATH:$HOME/android-sdk-linux/tools
  PATH=$PATH:$HOME/depot_tools
  PATH=$PATH:$HOME/google-cloud-sdk/bin
  PATH=$PATH:$HOME/gradle/bin
  export PATH
fi

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

alias e="$EDITOR"
alias em="$EMACS"
alias ema="$EMACS"
alias emac="$EMACS"
alias emacs="$EMACS"
alias grep="grep --color=auto"
alias j="jobs"
alias so="source"
alias v="$VIM"
alias vi="$VIM"

unalias ls >& /dev/null
ls --version >& /dev/null \
  && alias ls="ls --color=auto" \
  || alias ls="gls --color=auto"

# Disable flow control (Ctrl-S).
stty -ixon
