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
export EDITOR="~/.default_editor || help"
export FZF_CTRL_T_COMMAND="git ls"
export FZF_DEFAULT_COMMAND="git ls"
export HISTCONTROL="ignoredups:erasedups"

HELPERS="$HOME/.fzf/shell/key-bindings.bash
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

TOOLS="$HOME/depot_tools"
for tool in $TOOLS; do
  [[ -d $tool && $PATH != *$tool* ]] && PATH=$tool:$PATH
done
export PATH

alias e="$EDITOR"
alias em="$EMACS"
alias ema="$EMACS"
alias emac="$EMACS"
alias grep="grep --color=auto"
alias ggrep="git grep"
alias j="jobs"
alias so="source"
alias v="$VIM"
alias vi="$VIM"
alias ll="ls -l"

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
  build/android/gradle/generate_gradle.py --output-directory out/and \
        --project-dir ~/AndroidStudioProjects/chrome_public_test_apk \
        --target //chrome/android:chrome_public_test_apk__apk
  build/android/gradle/generate_gradle.py --output-directory out/and \
        --project-dir ~/AndroidStudioProjects/chrome_junit_tests \
        --target //chrome/android:chrome_junit_tests
}

editor_vim() {
    echo "VIM is the default editor"
    echo "exec vim" > ~/.default_editor
    chmod 700 ~/.default_editor
}

editor_emacs() {
    echo "Emacs is the default editor"
    echo "exec emacsclient -t" > ~/.default_editor
    chmod 700 ~/.default_editor
}

help() {
  echo "Commands:"
  echo "  $ ssh_agent_restart   - Restart the SSH agent."
  echo "  $ gradle_chromium     - Generate the gradle files for Chromium."
  echo "  $ editor_vim          - Launch vim as the default text editor."
  echo "  $ editor_emacs        - Launch emacs as the default text editor."
}

if [ -f ~/.ssh_agent.sh ]; then
  source ~/.ssh_agent.sh >& /dev/null
fi
