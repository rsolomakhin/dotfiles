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

source ~/.common.sh

HELPERS="$HOME/.fzf.zsh"
for helper in $HELPERS; do [ -f $helper ] && source $helper >& /dev/null; done

# Turn off vim line editing, even if that's the default text editor.
bindkey -e

# Turn on history.
export HISTFILE=~/.zsh_history
export HISTSIZE=10000000
export SAVEHIST=$HISTSIZE
setopt APPEND_HISTORY
setopt BANG_HIST
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# Correct commands.
setopt CORRECT

# .. goes up a dir.
setopt AUTO_CD

# vi:ft=sh
