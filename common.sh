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

export ALTERNATE_EDITOR=""
export BROWSER="google-chrome"
export CHROMIUM_OUTPUT_DIR="out/emu"
export CHROMIUM_SRC="$HOME/chrome/src"
export ANDROID_HOME="$CHROMIUM_SRC/third_party/android_sdk/public"
export EMACS="emacsclient -t"
export FZF_CTRL_T_COMMAND="git ls"
export FZF_DEFAULT_COMMAND="git ls"
export HISTCONTROL="ignoredups:erasedups"
export NINJA_SUMMARIZE_BUILD="0"
export VIM="vim"

VIMRUNTIMES=""
VIMRUNTIMES="$VIMRUNTIMES /opt/homebrew/share/vim/vim91"
VIMRUNTIMES="$VIMRUNTIMES /opt/homebrew/share/vim/vim90"
VIMRUNTIMES="$VIMRUNTIMES /usr/local/homebrew/share/vim/vim91"
VIMRUNTIMES="$VIMRUNTIMES /usr/local/homebrew/share/vim/vim90"
VIMRUNTIMES="$VIMRUNTIMES /usr/share/vim/vim91"
VIMRUNTIMES="$VIMRUNTIMES /usr/share/vim/vim90"
for vimruntime in $VIMRUNTIMES; do
  if [ -d $vimruntime ]; then
    export VIMRUNTIME="$vimruntime"
    break
  fi
done

TOOLS=""
TOOLS="$TOOLS $ANDROID_HOME/platform-tools"
TOOLS="$TOOLS $ANDROID_HOME/tools"
TOOLS="$TOOLS $ANDROID_HOME/tools/bin"
TOOLS="$TOOLS $HOME/depot_tools"
TOOLS="$TOOLS $HOME/software/bin"
TOOLS="$TOOLS /usr/local/homebrew/bin"
TOOLS="$TOOLS /opt/homebrew/bin"
TOOLS="$TOOLS /opt/homebrew/opt/openjdk/bin"
TOOLS="$TOOLS /opt/homebrew/opt/llvm/bin"
for tool in $TOOLS; do
  [[ -d $tool && $PATH != *$tool* ]] && PATH=$tool:$PATH
done
export PATH

HELPERS=""
HELPERS="$HELPERS $HOME/.local.sh"
for helper in $HELPERS; do [ -f $helper ] && source $helper >& /dev/null; done

alias e="$VIM"
alias em="$EMACS"
alias ema="$EMACS"
alias emac="$EMACS"
alias ggrep="git grep"
alias grep="grep --color=auto"
alias j="jobs"
alias so="source"
alias v="$VIM"
alias vi="$VIM"

# Disable flow control (Ctrl-S).
stty -ixon >& /dev/null

if [ "`uname`" = "Darwin" ]; then
  . ~/.darwin.sh
else
  . ~/.linux.sh
fi

# vi:ft=sh
