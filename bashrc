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

export EMACS="emacsclient -t"
export VIM="vim"

export ALTERNATE_EDITOR=""
export ANDROID_HOME=$HOME/chrome/src/third_party/android_tools/sdk
export CHROME_DEVEL_SANDBOX=/usr/local/sbin/chrome-devel-sandbox
export EDITOR="$VIM"
export FZF_CTRL_T_COMMAND="git ls"
export FZF_DEFAULT_COMMAND="git ls"
export GOPATH=$HOME/go
export GYP_GENERATORS="ninja"
export HISTCONTROL="ignoredups:erasedups"
export JAVA_HOME=$HOME/jdk
export PYTHONPATH=$HOME/python:$PYTHONPATH
export STUDIO_VM_OPTIONS="-Xmx2048m"

[ -z "$GYP_DEFINES" ] && export GYP_DEFINES="component=shared_library"

HELPERS="$HOME/.fzf/shell/key-bindings.bash
$HOME/google-cloud-sdk/completion.bash.inc
$HOME/.rvm/scripts/rvm
$HOME/.ssh_agent.sh
/usr/lib/git-core/git-sh-prompt
/usr/local/git/current/share/git-core/git-completion.bash
/usr/local/git/current/share/git-core/git-prompt.sh"
for helper in $HELPERS; do [ -f $helper ] && source $helper >& /dev/null; done

if type __git_ps1 >& /dev/null; then
  export PS1='[\u@\h \w$(__git_ps1 " (%s)")]\$ '
else
  export PS1='[\u@\h \w]\$ '
fi

if [ -z "$VIMRUNTIME" -a -d /usr/share/vim/vim74 ]; then
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
  alias ls="ls -G"
else
  alias ls="ls --color=auto"
fi

TOOLS="$GOPATH/bin
$HOME/.fzf/bin
$HOME/.rvm/bin
$HOME/android-sdk-linux/tools
$HOME/android-studio/bin
$HOME/chrome/src/third_party/android_tools/sdk/platform-tools
$HOME/chrome/src/third_party/android_tools/sdk/tools
$HOME/depot_tools
$HOME/emacs/bin
$HOME/google-cloud-sdk/bin
$HOME/jdk/bin
$HOME/node/bin
$HOME/python/bin
$HOME/software/bin
/opt/android-studio-stable/bin"
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

# Disable flow control (Ctrl-S).
stty -ixon

# Resume SSH agent.
ssh_agent_restart() {
  echo "Restarting ssh agent"
  rm -f ~/.ssh_agent.sh
  killall -9 ssh-agent
  ssh-agent -s > ~/.ssh_agent.sh
  source ~/.ssh_agent.sh
  for file in ~/.ssh/*.pub; do
    ssh-add ${file/.pub}
  done
}

# Generte the grade files for Chromium.
gradle_chromium() {
  echo "Generating gradle files for Chromium"
  pushd ~/chrome/src \
    && build/android/gradle/generate_gradle.py --output-directory out/and \
        --project-dir ~/AndroidStudioProjects/chrome_public_test_apk \
        --target //chrome/android:chrome_public_test_apk__apk \
    && build/android/gradle/generate_gradle.py --output-directory out/and \
        --project-dir ~/AndroidStudioProjects/chrome_public_apk \
        --target //chrome/android:chrome_public_apk \
    && popd
}

help() {
  echo "Commands:"
  echo "  $ ssh_agent_restart   - Restart the SSH agent."
  echo "  $ gradle_chromium     - Generate the gradle files for Chromium."
}

if [ -f ~/.ssh_agent.sh ]; then
  source ~/.ssh_agent.sh >& /dev/null
fi
