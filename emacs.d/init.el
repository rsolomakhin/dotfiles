;; -*- lisp -*-
;;
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

;;;;;;;;;;;;;;;;;;;;;;;
;; Built-in settings ;;
;;;;;;;;;;;;;;;;;;;;;;;

;; Don't show the welcome screen.
(setq inhibit-startup-message t)

;; Turn off the menu bar, menu bar, and scrollbar.
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)

;; .h files are C++.
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; By default fill to 80 chars.
(setq-default fill-column 80)

;; Standard indent is 2 chars.
(setq standard-indent 2)

;; Use spaces to indent.
(setq-default indent-tabs-mode 0)

;; Show the column in the status line.
(column-number-mode)

;; No need to type out yes or no.
(defalias 'yes-or-no-p 'y-or-n-p)

;; Do not put tilde files everywhere.
(setq make-backup-files 0)

;; Do not put hashtag files everywhere.
(auto-save-mode 0)

;; Save minibuffer history across sessions.
(savehist-mode)

;; Scroll compilation buffer until the first error.
(setq compilation-scroll-output 'first-error)

;;;;;;;;;;;;;;;;;;;;;;
;; Builtin packages ;;
;;;;;;;;;;;;;;;;;;;;;;

;; Remember my place in file.
(require 'saveplace)
(setq-default save-place t)

;;;;;;;;;;;;;;;;;;;;;;;;;
;; Downloaded packages ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

;; Google
(require 'google-c-style)
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)

;; Clang format.
(require 'clang-format)
(add-hook 'c-mode-common-hook
	  (function (lambda ()
		      (local-set-key (kbd "TAB") 'clang-format-region))))
