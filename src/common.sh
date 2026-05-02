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

# Source a file if it exists.
source_if_exists() {
  [ -f "$1" ] && source "$1"
}

# Add to PATH only if directory exists and is not already in PATH.
# Prepend to ensure local versions take precedence.
path_prepend() {
  if [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]]; then
    PATH="$1:$PATH"
  fi
}

path_prepend "$ANDROID_HOME/platform-tools"
path_prepend "$ANDROID_HOME/tools"
path_prepend "$ANDROID_HOME/tools/bin"
path_prepend "$HOME/depot_tools"
path_prepend "$HOME/software/bin"

# Bootstrap Homebrew path if not already present.
for brew_path in /opt/homebrew/bin /usr/local/bin; do
  if [[ -x "$brew_path/brew" && $PATH != *"$brew_path"* ]]; then
    PATH="$brew_path:$PATH"
    break
  fi
done

if command -v brew >/dev/null 2>&1; then
  BREW_PREFIX=$(brew --prefix)
  path_prepend "$BREW_PREFIX/bin"
  path_prepend "$BREW_PREFIX/opt/openjdk/bin"
  path_prepend "$BREW_PREFIX/opt/llvm/bin"
fi

export PATH

# Dynamically set VIMRUNTIME based on the active vim executable's fallback path.
if command -v vim >/dev/null 2>&1; then
  VIM_FALLBACK=$(vim --version | grep 'fall-back for $VIM:' | awk -F\" '{print $2}')
  if [ -n "$VIM_FALLBACK" ] && [ -d "$VIM_FALLBACK" ]; then
    for dir in "$VIM_FALLBACK"/vim[0-9]*; do
      if [ -d "$dir" ]; then
        export VIMRUNTIME="$dir"
      fi
    done
  fi
fi

source_if_exists "$HOME/.local.sh"

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
