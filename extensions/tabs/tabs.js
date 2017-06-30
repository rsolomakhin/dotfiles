/**
 * Copyright 2017 Rouslan Solomakhin
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

let tabs = [];
let displayedTabs = [];
let displayedTabElements = [];
let query = new RegExp('');
let tabsElement;
let queryElement;
let selected = 0;

/**
 * Creates a div.
 * @param {string} className - The div class name.
 * @param {string} content - The div content.
 * @return {HTMLElement} The resulting div.
 */
function createDiv(className, content) {
  const div = document.createElement('div');
  div.className = className;
  if (content) {
    div.innerHTML = content;
  }
  return div;
}

/** Clears the selection from the currently selected tab. */
function clearSelection() {
  if (displayedTabElements.length > 0 &&
    selected < displayedTabElements.length) {
    displayedTabElements[selected].classList.remove('select');
  }
}

/** Selects a tab. */
function setSelection() {
  if (displayedTabElements.length == 0) {
    return;
  }

  if (selected > displayedTabElements.length) {
    selected = displayedTabElements.length - 1;
  }

  displayedTabElements[selected].classList.add('select');
}

/** Filters the tab list. */
function filterTabList() {
  displayedTabs = [];
  displayedTabElements = [];
  for (let i = 0; i < tabs.length; i++) {
    const tab = tabs[i];
    const tabElement = tabsElement.childNodes[i];
    if (query.test(tab.title)) {
      displayedTabs.push(tab);
      displayedTabElements.push(tabElement);
      tabElement.classList.remove('hide');
    } else {
      tabElement.classList.add('hide');
    }
  }
}

/**
 * Called when user hovers over a tab element.
 * @param {HTMLElement} tabElement - The tab element.
 */
function onHover(tabElement) {
  const index = displayedTabElements.indexOf(tabElement);
  if (index >= 0) {
    clearSelection();
    selected = index;
    setSelection();
  }
}

/**
 * Called when user clicks on a tab element.
 * @param {HTMLElement} tabElement - The tab element.
 */
function onClick(tabElement) {
  const index = displayedTabElements.indexOf(tabElement);
  if (index >= 0) {
    selected = index;
    goToSelectedTab();
  }
}

/** Builds the tab list. */
function buildTabList() {
  for (let i = 0; i < tabs.length; i++) {
    const tab = tabs[i];
    const tabElement = createDiv('tab');

    const titleElement = createDiv('title', tab.title);
    tabElement.appendChild(titleElement);

    const urlElement = createDiv('url', tab.url);
    tabElement.appendChild(urlElement);

    urlElement.onmouseover = titleElement.onmouseover = tabElement.onmouseover =
      function() {
        onHover(tabElement);
        return true;
      };

    urlElement.onclick = titleElement.onclick = tabElement.onclick =
      function() {
        onClick(tabElement);
        return true;
      };

    tabsElement.appendChild(tabElement);
  }
}

/**
 * Handles key down.
 * @param {Event} e - Key event.
 * @return {bool} Whether the default key handler should be triggered.
 */
function onKeyDown(e) {
  // Enter key.
  if (e.keyCode == '13') {
    goToSelectedTab();
    return false;
  }

  // Up arrow.
  if (e.keyCode == '38') {
    if (selected > 0) {
      clearSelection();
      selected--;
      setSelection();
    }
    return false;
  }

  // Down arrow.
  if (e.keyCode == '40') {
    if (selected < displayedTabElements.length - 1) {
      clearSelection();
      selected++;
      setSelection();
    }
    return false;
  }

  return true;
}

/**
 * Handles key up.
 * @param {Event} e - Key event.
 * @return {bool} Whether the default key handler should be triggered.
 */
function onKeyUp(e) {
  if (e.keyCode == '13' || e.keyCode == '38' || e.keyCode == '40') {
    return false;
  }

  query = new RegExp(queryElement.value, 'i');

  clearSelection();
  filterTabList();
  setSelection();

  return true;
}

/** Got the selected tab. */
function goToSelectedTab() {
  if (displayedTabs.length > selected) {
    chrome.tabs.update(displayedTabs[selected].id, {
      active: true,
    });
    window.close();
  }
}

/**
 * Called when tabs have been queried.
 * @param {Tab[]} t - Tabs.
 */
function onTabsQueried(t) {
  tabs = t;
  tabsElement = document.getElementById('tabs');
  buildTabList();
  filterTabList();
  setSelection();

  queryElement = document.getElementById('query');
  queryElement.onkeydown = onKeyDown;
  queryElement.onkeyup = onKeyUp;
}

document.addEventListener('DOMContentLoaded', function() {
  chrome.tabs.query({}, onTabsQueried);
});
