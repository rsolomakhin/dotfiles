;; Copyright 2015 Rouslan Solomakhin
;;
;; Licensed under the Apache License, Version 2.0 (the "License");
;; you may not use this file except in compliance with the License.
;; You may obtain a copy of the License at
;;
;;     http://www.apache.org/licenses/LICENSE-2.0
;;
;; Unless required by applicable law or agreed to in writing, software
;; distributed under the License is distributed on an "AS IS" BASIS,
;; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;; See the License for the specific language governing permissions and
;; limitations under the License.

;; Package management.
(require 'cask "~/.third_party/cask/cask.el")
(cask-initialize)
(require 'pallet)
(pallet-mode t)

;; Remember my place in the file.
(require 'saveplace)
(setq-default save-place t)

;; Automatic indentation.
(electric-indent-mode t)

;; Google style formatting for C-like languages.
(require 'google-c-style)
(add-hook 'c-mode-common-hook 'google-set-c-style)

;; .h files are C++.
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; .gyp, .gypi, and .gn files are python.
(add-to-list 'auto-mode-alist '("\\.gyp\\'"  . python-mode))
(add-to-list 'auto-mode-alist '("\\.gypi\\'" . python-mode))
(add-to-list 'auto-mode-alist '("\\.gn\\'"   . python-mode))

;; Clang-format files by issuing 'clang-format-region' command.
(require 'clang-format)

;; Indicate the location of the fill column.
(require 'fill-column-indicator)
(add-hook 'after-change-major-mode-hook 'fci-mode)

;; Workaround for fill column indicator causing C-p to skip lines in Emacs 24.3.
(when (and (= 24 emacs-major-version) (= 3 emacs-minor-version))
  (make-variable-buffer-local 'line-move-visual)
  (defadvice previous-line (around avoid-jumpy-fci activate)
    (if (and (symbol-value 'fci-mode) (> (count-lines 1 (point)) 0))
        (prog (fci-mode -1) ad-do-it (fci-mode 1))
      ad-do-it)))

;; By default fill to 80 chars.
(setq-default fill-column 80)

;; Standard indent is 2 chars.
(setq standard-indent 2)

;; Use spaces to indent.
(setq-default indent-tabs-mode nil)

;; Use mouse to scroll in xterm.
(xterm-mouse-mode t)

;; Show the colum in the status line.
(column-number-mode 1)

;; Hippie expand.
(global-set-key "\M-/" 'hippie-expand)

;; Save recent files.
(recentf-mode 1)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)
