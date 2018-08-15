/**
 * Copyright 2018 Rouslan Solomakhin
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

chrome.browserAction.setBadgeText({text: "0"});

function getPublicKey() {
  const decoded_cookie = decodeURIComponent(document.cookie);
  return 'hello world';
}

function setPublicKey(public_key) {
  document.cookie = 'public_key=' + public_key;
}

document.addEventListener('DOMContentLoaded', function() {
  document.getElementById('public_key').value = getPublicKey();
  document.getElementById('public_key').addEventListener('keyup', function() {
    setPublicKey(document.getElementById('public_key').value);
  });
});
