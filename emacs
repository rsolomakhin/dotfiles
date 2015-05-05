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

;; Packages.
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

;; Remember my place in the file.
(require 'saveplace)
(setq-default save-place t)

;; Automatic indentation.
(electric-indent-mode t)

;; Google style formatting for C-like languages.
(add-to-list 'load-path "~/.third_party/google-styleguide")
(require 'google-c-style)
(add-hook 'c-mode-common-hook 'google-set-c-style)

;; .h files are C++.
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; .gyp, .gypi, and .gn files are python.
(add-to-list 'auto-mode-alist '("\\.gyp\\'"  . python-mode))
(add-to-list 'auto-mode-alist '("\\.gypi\\'" . python-mode))
(add-to-list 'auto-mode-alist '("\\.gn\\'"   . python-mode))

;; Clang-format files by issuing 'clang-format-region' command.
(add-to-list 'load-path "~/chrome/src/buildtools/clang_format")
(require 'clang-format)

;; Indicate the location of the fill column.
(require 'fill-column-indicator)
(add-hook 'after-change-major-mode-hook 'fci-mode)

;; By default fill to 80 chars.
(setq-default fill-column 80)

;; Autocorrection.
(setq-default abbrev-mode t)
(read-abbrev-file "~/.abbrev_defs")
(setq save-abbrves t)

;; Standard indent is 2 chars.
(setq standard-indent 2)

;; Use spaces to indent.
(setq-default indent-tabs-mode nil)

;; Use mouse to scroll in xterm.
(xterm-mouse-mode t)

;; Git saves history, so no need for backsup.
(setq make-backup-files nil)

;; Show the colum in the status line.
(column-number-mode 1)
