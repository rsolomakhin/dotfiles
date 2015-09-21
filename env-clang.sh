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

if [[ $- != *i* ]]; then
  echo "Script should be sourced"
  exit 1
fi

if [ ! -e ../.gclient ]; then
  echo "You're not in a Chromium repository"
  return
fi

export GYP_DEFINES="component=shared_library clang=1"
[ -e ~/.env-local.sh ] && source ~/.env-local.sh
echo $GYP_DEFINES
export CHROMIUM_OUT_DIR=out_clang
mkdir -p $CHROMIUM_OUT_DIR
which gln > /dev/null
if [ $? -eq 0 ]; then
  gln -svfT $CHROMIUM_OUT_DIR out
else
  ln -svfT $CHROMIUM_OUT_DIR out
fi
