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

source ~/.common.sh

# Fuzzy file finder and history lookup.
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Remap Ctrl-T to use fzf-tmux directly, which respects FZF_DEFAULT_COMMAND and
# FZF_DEFAULT_OPTS.
bind '"\C-t": "$(fzf-tmux)\e\C-e"'
