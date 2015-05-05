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
PATH=$PATH:$HOME/software/bin
export PATH
export CHROME_DEVEL_SANDBOX=/usr/local/sbin/chrome-devel-sandbox
export CHROMIUM=$HOME/chrome/src
export ALTERNATE_EDITOR=''
if [ -e ~/.editor.sh ]; then
  source ~/.editor.sh
fi
if [ -z "$EDITOR" ]; then
  export EDITOR='vim'
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
alias j='jobs'
alias so="source"
alias v="vim"
alias vi="vim"
alias xterm='xterm -e zsh'
alias zshrc='$EDITOR ~/.zshrc'
ls --color=auto > /dev/null 2>&1 && alias ls="ls --color=auto"

alias -s cc=$EDITOR
alias -s cpp=$EDITOR
alias -s gn=$EDITOR
alias -s gyp=$EDITOR
alias -s gypi=$EDITOR
alias -s h=$EDITOR
alias -s html=$EDITOR
alias -s java=$EDITOR
alias -s js=$EDITOR
alias -s proto=$EDITOR
alias -s xml=$EDITOR

# Disable flow control (Ctrl-S).
stty -ixon

# Save and share history.
export HISTSIZE=1000
if ((!EUID)); then
  export HISTFILE=~/.history_root
else
  export HISTFILE=~/.history
fi
export SAVEHIST=1000

if [[ $EDITOR == v* ]]; then
  # Vi editing mode.
  bindkey -v
  bindkey '^?' backward-delete-char
  bindkey '^G' what-cursor-position
  bindkey '^h' backward-delete-char
  export KEYTIMEOUT=1
  if [ -f ~/.third_party/promptline.vim/prompt_vim.sh ]; then
    source ~/.third_party/promptline.vim/prompt_vim.sh
  fi
  # Vim text objects.
  if [ -f ~/.third_party/opp.zsh/opp.zsh ]; then
    source ~/.third_party/opp.zsh/opp.zsh
  fi
  alias e="emacs"
  alias em="emacs"
else
  # Emacs editing mode.
  bindkey -e
  if [ -f ~/.third_party/promptline.vim/prompt_emacs.sh ]; then
    source ~/.third_party/promptline.vim/prompt_emacs.sh
  fi
  alias e="$EDITOR"
  alias em="$EDITOR"
fi

# Control-Z to resume current job.
if [ -f ~/.third_party/ctrl-zsh/ctrl-zsh.plugin.zsh ]; then
  source ~/.third_party/ctrl-zsh/ctrl-zsh.plugin.zsh
fi

# Fuzzy file finder and history lookup.
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
