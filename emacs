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

;; Manage package dependencies in cask.
(require 'cask "~/.third_party/cask/cask.el")
(cask-initialize)

;; Update the cask file when installing packages.
(require 'pallet)
(pallet-mode t)

;; Remember my place in file.
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

;; By default fill to 80 chars.
(setq-default fill-column 80)

;; Standard indent is 2 chars.
(setq standard-indent 2)

;; Use spaces to indent.
(setq-default indent-tabs-mode nil)

;; Show the colum in the status line.
(column-number-mode 1)

;; Save recent files.
(recentf-mode 1)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

;; No need to type out yes or no.
(defalias 'yes-or-no-p 'y-or-n-p)

;; Snippets.
(require 'yasnippet)
(yas-global-mode 1)

;; Show matching paren.
(setq show-paren-delay 0)
(show-paren-mode 1)

;; Complete anything.
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(define-key company-active-map (kbd "\C-n") 'company-select-next)
(define-key company-active-map (kbd "\C-p") 'company-select-previous)
(define-key company-active-map (kbd "\C-d") 'company-show-doc-buffer)
(define-key company-active-map (kbd "<tab>") 'company-complete)

;; Highlight long lines.
(require 'whitespace)
(setq whitespace-style '(face indentation trailing empty lines-tail))
(global-whitespace-mode 1)
