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

export CHROMIUM_OUT_DIR=out_gn
mkdir -p $CHROMIUM_OUT_DIR/Default
ln -svfT $CHROMIUM_OUT_DIR out
if [ ! -e $CHROMIUM_OUT_DIR/Default/args.gn ]; then
  cat > $CHROMIUM_OUT_DIR/Default/args.gn <<EOF
disable_incremental_isolated_processes = true
enable_incremental_javac = true
is_clang = true
is_component_build = true
is_debug = false
target_os = "android"
EOF
fi
unset GYP_DEFINES
[ -e ~/.env-local.sh ] && source ~/.env-local.sh
cat $CHROMIUM_OUT_DIR/Default/args.gn
gn gen out/Default
