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
export EDITOR="vim"
export FZF_CTRL_T_COMMAND="find -L . \( \
      -path '*/\.*' -o \
      -path '\./out*' -o \
      -fstype 'dev' -o \
      -fstype 'proc' \
    \) -prune -o \
    -type f -print -o \
    -type d -print -o \
    -type l -print 2> /dev/null | \
        sed 1d | cut -b3- "
export FZF_DEFAULT_COMMAND="$FZF_CTRL_T_COMMAND"
export GOPATH=$HOME/go
export GYP_GENERATORS="ninja"
export JAVA_HOME=$HOME/jdk

[ -e /usr/lib/git-core/git-sh-prompt ] && source /usr/lib/git-core/git-sh-prompt
if type __git_ps1 >& /dev/null; then
  export PS1='[\u@\h \w$(__git_ps1 " (%s)")]\$ '
else
  export PS1='[\u@\h \w]\$ '
fi

[ -z "$GYP_DEFINES" ] && export GYP_DEFINES="component=shared_library"
[ "$TERM" == "dumb" ] && export PAGER=cat

PREFIX=$HOME/software/bin:$JAVA_HOME/bin
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
[ -e ~/.ssh_agent.sh ] && source ~/.ssh_agent.sh >& /dev/null
if ! ssh-add -l >& /dev/null; then
  killall -9 ssh-agent >& /dev/null
  ssh-agent -s > ~/.ssh_agent.sh
  source ~/.ssh_agent.sh >& /dev/null
  for file in ~/.ssh/*.pub; do
    ssh-add ${file/.pub}
  done
fi

alias e="$EDITOR"
alias em="emacsclient -t"
alias grep="grep --color=auto"
alias j="jobs"
alias so="source"
alias vi="vim"
alias v="vim"
ls --version >& /dev/null \
  && alias ls="ls --color=auto" \
  || alias ls="gls --color=auto"

# Disable flow control (Ctrl-S).
stty -ixon
