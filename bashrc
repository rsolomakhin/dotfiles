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
PATH=$PATH:$HOME/bin
export PATH

if [ -n "$PS1" ]; then
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

  export CHROME_DEVEL_SANDBOX=/usr/local/sbin/chrome-devel-sandbox
  export CHROMIUM=$HOME/chrome/src
  export EDITOR='vim'
  export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\
\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

  source /etc/bash_completion
  source ~/chrome/src/tools/cr/cr-bash-helpers.sh
  (cd && source ~/config-chrome/android.sh > /dev/null)

  [ -f ~/.fzf.bash ] && source ~/.fzf.bash

  alias e="emacs"
  alias em="emacs"
  alias grep="grep --color=auto"
  alias ls="ls --color=auto --group-directories-first"
  alias so="source"
  alias vi="vim"
  alias v="vim"

  # Disable flow control (Ctrl-S).
  stty -ixon
fi
