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

export GYP_DEFINES="component=shared_library OS=android clang=1 create_standalone_apk=1 fastbuild=1"
[ -e ~/.env-local.sh ] && source ~/.env-local.sh
source build/android/envsetup.sh
echo $GYP_DEFINES
mkdir -p out_android
ln -svfT out_android out
