# Copyright 2017 Rouslan Solomakhin
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
export FZF_CTRL_T_COMMAND="git ls"
export FZF_DEFAULT_COMMAND="git ls"
export HISTCONTROL="ignoredups:erasedups"

HELPERS="$HOME/.ssh_agent.sh"
for helper in $HELPERS; do [ -f $helper ] && source $helper >& /dev/null; done

TOOLS="$HOME/depot_tools $HOME/.fzf/bin $HOME/node/bin $HOME/homebrew/bin"
for tool in $TOOLS; do
  [[ -d $tool && $PATH != *$tool* ]] && PATH=$tool:$PATH
done
export PATH

alias em="$EMACS"
alias ema="$EMACS"
alias emac="$EMACS"
alias ggrep="git grep"
alias grep="grep --color=auto"
alias j="jobs"
alias so="source"
alias v="$VIM"
alias vi="$VIM"

if [[ "`uname`" == "Darwin" ]]; then
  alias ll="ls -l -G"
  alias ls="ls -G"
else
  alias ll="ls -l --color"
  alias ls="ls --color"
fi

# Disable flow control (Ctrl-S).
stty -ixon >& /dev/null

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

# Make VIM the default editor.
editor_vim() {
  echo "VIM is the default editor"
  echo "export EDITOR=\"$VIM\"" > ~/.default_editor.sh
  export EDITOR="$VIM"
  alias e="$EDITOR"
}

# Make Emacs the default editor.
editor_emacs() {
  echo "Emacs is the default editor"
  echo "export EDITOR=\"$EMACS\"" > ~/.default_editor.sh
  export EDITOR="$EMACS"
  alias e="$EDITOR"
}

# List files in git.
gls() {
  git ls | grep $@
}

help() {
  echo "Commands:"
  echo "  $ ssh_agent_restart   - Restart the SSH agent."
  echo "  $ gradle_chromium     - Generate the gradle files for Chromium."
  echo "  $ editor_vim          - Set vim as the default text editor."
  echo "  $ editor_emacs        - Set emacs as the default text editor."
  echo "  $ gls <pattern>       - List file names matching the pattern."
  echo "  $ ggrep <pattern>     - List files containing the pattern."
}

if [ -f ~/.ssh_agent.sh ]; then
  source ~/.ssh_agent.sh >& /dev/null
fi

if [ -f $HOME/homebrew/share/vim/vim80/syntax/syntax.vim ]; then
  export VIMRUNTIME=$HOME/homebrew/share/vim/vim80
elif [ -f /usr/share/vim/vim80/syntax/syntax.vim ]; then
  export VIMRUNTIME=/usr/share/vim/vim80
elif [ -f $HOME/../usr/share/vim/vim80/syntax/syntax.vim ]; then
  export VIMRUNTIME=$HOME/../usr/share/vim/vim80
elif [ -f /usr/share/vim/vim74/syntax/syntax.vim ]; then
  export VIMRUNTIME=/usr/share/vim/vim74
fi

# Apply the powerline theme.
source ~/.sh-theme.sh

# Select the default editor.
if [ -f ~/.default_editor.sh ]; then
  source ~/.default_editor.sh
  alias e="$EDITOR"
else
  echo "Run 'editor_vim' or 'editor_emacs' please."
fi

# vi:ft=sh
