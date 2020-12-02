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

source ~/.common.sh

HELPERS=""
HELPERS="$HELPERS $HOME/.fzf.bash"
HELPERS="$HELPERS $HOME/google-cloud-sdk/completion.bash.inc"
HELPERS="$HELPERS $HOME/google-cloud-sdk/path.bash.inc"
HELPERS="$HELPERS /etc/bash_completion"
HELPERS="$HELPERS /usr/local/git/current/share/git-core/git-completion.bash"
HELPERS="$HELPERS /usr/local/git/current/share/git-core/git-prompt.sh"
for helper in $HELPERS; do [ -f $helper ] && source $helper >& /dev/null; done

# Default PS1 theme.
export PS1='[\[\e[32m\]\u\[\e[m\]@\[\e[34m\]\h\[\e[m\]:\w]\[\e[34m\]$(__git_ps1 \(%s\))\[\e[m\]\$ '

# vi:ft=sh
