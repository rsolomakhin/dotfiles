# Copyright 2020 Rouslan Solomakhin
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

# Looping over $TOOLS and $HELPERS should split the string by whitespace:
setopt shwordsplit

source ~/.common.sh

HELPERS=""
HELPERS="$HELPERS $HOME/.fzf.zsh"
HELPERS="$HELPERS $HOME/google-cloud-sdk/completion.zsh.inc"
HELPERS="$HELPERS $HOME/google-cloud-sdk/path.zsh.inc"
HELPERS="$HELPERS /etc/zsh_completion"
HELPERS="$HELPERS /usr/local/git/current/share/git-core/git-completion.zsh"
HELPERS="$HELPERS /usr/local/git/current/share/git-core/git-prompt.sh"
for helper in $HELPERS; do [ -f $helper ] && source $helper >& /dev/null; done

# vi:ft=sh
