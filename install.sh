#!/bin/sh
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

die() {
  echo $@
  exit 1
}

git config user.email "rouslan.solomakhin@gmail.com" || die "Cannot set git user email for this repository"
cd || die "Cannot change dir to home"
rcup -v || die "Cannot install dotfiles"
cd - || die "Cannot go back to previous directory"
git config --global --get user.email || git config --global user.email "rouslan.solomakhin@gmail.com" || die "Cannot set global git user email"
git config --global --replace-all alias.br branch || die "Cannot alias git br"
git config --global --replace-all alias.brv "branch -vv" || die "Cannot alias git brv"
git config --global --replace-all alias.can "commit -a --amend --no-edit" || die "Cannot alias git can"
git config --global --replace-all alias.co checkout || die "Cannot alias git co"
git config --global --replace-all alias.ls ls-files || die "Cannot alias git ls"
git config --global --replace-all alias.st status || die "Cannot alias git st"
git config --global --replace-all alias.sub "submodule update --init --recursive" || die "Cannot alias git sub"
git config --global --replace-all color.ui auto || die "Cannot enable git colors"
git config --global --replace-all core.autocrlf false || die "Cannot set git autoclrf"
git config --global --replace-all core.excludesfile ~/.cvsignore || die "Cannot set git excludes file"
git config --global --replace-all core.filemode false || die "Cannot disable git filemode"
git config --global --replace-all http.cookiefile ~/.gitcookies || die "Cannot set git cookie file"
git config --global --replace-all push.default simple || die "Cannot set git push settings"
git config --global --replace-all user.name "Rouslan Solomakhin" || die "Cannot set git user name"
git submodule update --init --recursive || die "Cannot update submodules"
sudo apt-get install build-essential cmake python-dev || die "Cannot install YCM deps"
cd third_party/ycmd/ || die "Cannot go into YCM dir"
./build.py --clang-completer --gocode-completer || die "Cannot build YCM"
cd ~/.emacs.d/ || die "Cannot change dir to ~/.emacs.d/"
cask install || die "Cannot install cask deps"
