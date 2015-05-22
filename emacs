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

;; Set the font.
(cond
 ((string-equal system-type "gnu/linux")
  (add-to-list 'default-frame-alist
               '(font . "Ubuntu Mono:pixelsize=15")))
 ((string-equal system-type "windows-nt")
  (custom-set-faces
   '(default ((t (:family "Consolas" :foundry "outline" :slant normal
                          :weight normal :height 120 :width normal)))))))

;; .h files are C++.
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; .gyp, .gypi, and .gn files are python.
(add-to-list 'auto-mode-alist '("\\.gyp\\'"  . python-mode))
(add-to-list 'auto-mode-alist '("\\.gypi\\'" . python-mode))
(add-to-list 'auto-mode-alist '("\\.gn\\'"   . python-mode))

;; By default fill to 80 chars.
(setq-default fill-column 80)

;; Standard indent is 2 chars.
(setq standard-indent 2)

;; Use spaces to indent.
(setq-default indent-tabs-mode 0)

;; Show the column in the status line.
(column-number-mode)

;; Save recent files.
(recentf-mode 1)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

;; No need to type out yes or no.
(defalias 'yes-or-no-p 'y-or-n-p)

;; Automatic indentation.
(electric-indent-mode)

;; Do not put tilde files everywhere.
(setq make-backup-files 0)

;; Do not put hashtag files everywhere.
(auto-save-mode 0)

;; Remove trailing whitespace.
(add-hook 'write-file-hooks #'delete-trailing-whitespace)

;; Revert any buffer associated with a file when the file changes on disk.
(global-auto-revert-mode)

;; Save minibuffer history across sessions.
(savehist-mode)

;;;;;;;;;;;;;;;;;;;;;;
;; Custom functions ;;
;;;;;;;;;;;;;;;;;;;;;;

;; Open chromium source code browser at the current cursor position.
(defun open-chromium-src ()
  (interactive)
  (browse-url
   (format "https://code.google.com/p/chromium/codesearch#chromium/src/%s&l=%s"
	   (replace-regexp-in-string ".*chrome/src/"
				     ""
				     (buffer-file-name))
	   (line-number-at-pos))))

;; Relaunch the last compile command and see the compile progress.
(defun recompile-in-full-screen ()
  (interactive)
  (recompile)
  (switch-to-buffer "*compilation*")
  (delete-other-windows)
  (end-of-buffer))

;; Open the header, source, and tests side-by-side.
(defun split-related-files-from-header ()
  (interactive)
  (delete-other-windows)
  (split-window-right)
  (windmove-right)
  (find-file (replace-regexp-in-string
	      ".h$" ".cc" (buffer-file-name)))
  (split-window-right)
  (windmove-right)
  (find-file (replace-regexp-in-string
	      ".cc$" "_unittest.cc" (buffer-file-name)))
  (balance-windows)
  (windmove-left)
  (windmove-left))

;;;;;;;;;;;;;;;;;;
;; Key bindings ;;
;;;;;;;;;;;;;;;;;;

;; Compilation.
(global-set-key [(C-f5)] 'compile)
(global-set-key [(f5)] 'recompile-in-full-screen);

;;;;;;;;;;;;;;;;;;;;;;;
;; Built-in packages ;;
;;;;;;;;;;;;;;;;;;;;;;;

;; Enable server mode everywhere.
(require 'server)
(unless (server-running-p)
  (server-start))

;; Remember my place in file.
(require 'saveplace)
(setq-default save-place t)

;; Move quickly between windows.
(require 'windmove)
(windmove-default-keybindings)

;;;;;;;;;;;;;;;;;;;;;;;;;
;; Downloaded packages ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

;; Manage package dependencies in cask.
(require 'cask "~/.third_party/cask/cask.el")
(cask-initialize)

;; Update the cask file when installing packages.
(require 'pallet)
(pallet-mode t)

;; Google style formatting for C-like languages.
(require 'google-c-style)
(add-hook 'c-mode-common-hook 'google-set-c-style)

;; Clang-format files by issuing 'clang-format-region' command.
(require 'clang-format)

;; Snippets.
(require 'yasnippet)
(yas-global-mode)

;; Complete anything.
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(define-key company-active-map (kbd "\C-n") 'company-select-next)
(define-key company-active-map (kbd "\C-p") 'company-select-previous)
(define-key company-active-map (kbd "\C-d") 'company-show-doc-buffer)
(define-key company-active-map (kbd "<tab>") 'company-complete)

;; Semantic completion server.
(cond
 ((string-equal system-type "gnu/linux")
  (require 'ycmd)
  (add-hook 'after-init-hook #'global-ycmd-mode)
  (set-variable 'ycmd-server-command '("python"))
  (add-to-list 'ycmd-server-command (expand-file-name "~/.third_party/ycmd/ycmd") t)
  (set-variable 'ycmd-global-config
		"~/chrome/src/tools/vim/chromium.ycm_extra_conf.py")
  (require 'company-ycmd)
  (company-ycmd-setup)))

;; Highlight pasted lines.
(require 'volatile-highlights)
(volatile-highlights-mode t)

;; Be smart with paren pairs.
(require 'smartparens-config)
(smartparens-global-mode)

;; Enable editing .proto files.
(require 'protobuf-mode)

;; Git.
(require 'magit)
(setq magit-last-seen-setup-instructions "1.4.0")

;; Move the buffer around.
(require 'buffer-move)
(global-set-key [(C-S-up)] 'buf-move-up)
(global-set-key [(C-S-down)] 'buf-move-down)
(global-set-key [(C-S-left)] 'buf-move-left)
(global-set-key [(C-S-right)] 'buf-move-right)

;;;;;;;;;;;
;; Theme ;;
;;;;;;;;;;;

;; (load-theme 'molokai t)
;; (load-theme 'solarized-dark t)
;; (load-theme 'tango-dark t)
;; (load-theme 'wombat t)
(load-theme 'zenburn t)
