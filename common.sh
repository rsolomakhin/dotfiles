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
export EDITOR="emacs -nw"
export FZF_DEFAULT_COMMAND="find -L . \( \
      -path '*/\.*' -o \
      -path '\./out*' -o \
      -fstype 'dev' -o \
      -fstype 'proc' \
    \) -prune -o \
    -type f -print -o \
    -type d -print -o \
    -type l -print 2> /dev/null | \
        sed 1d | cut -b3- "
export FZF_DEFAULT_OPTS="--color=bw"
export GOPATH=$HOME/go
export GYP_DEFINES="component=shared_library"
export GYP_GENERATORS="ninja"

if [[ $PATH != *depot_tools* ]]; then
  PATH=$HOME/software/bin:$PATH
  PATH=$PATH:$GOPATH/bin
  PATH=$PATH:$HOME/android-sdk-linux/platform-tools
  PATH=$PATH:$HOME/android-sdk-linux/tools
  PATH=$PATH:$HOME/depot_tools
  PATH=$PATH:$HOME/gradle/bin
  PATH=$PATH:$HOME/.third_party/cask/bin
  export PATH
fi

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

alias grep="grep --color=auto"
alias j="jobs"
alias so="source"
alias v="vim"
alias vi="vim"
ls --color=auto > /dev/null 2>&1 && alias ls="ls --color=auto"
if [ "$TERM" == "xterm" ]; then
  alias tmux="tmux -2"
fi

# Disable flow control (Ctrl-S).
stty -ixon

if [[ $EDITOR == v* ]]; then
  alias e="emacs -nw"
  alias em="emacs -nw"
else
  alias e="$EDITOR"
  alias em="$EDITOR"
fi

if [ -n "$INSIDE_EMACS" ]; then
  export PAGER=cat
fi
