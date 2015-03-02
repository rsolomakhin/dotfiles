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

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

(require 'fill-column-indicator)

(defun my-java-mode-hook ()
  (setq indent-tabs-mode nil)
  (setq c-basic-offset 4)
  (setq fill-column 100)
  (electric-indent-mode))
(add-hook 'java-mode-hook 'my-java-mode-hook)

(load "~/.third_party/google-styleguide/google-c-style.el")
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(defun my-c-mode-common-hook ()
  (setq fill-column 80))
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

(defun my-sh-mode-hook ()
  (setq indent-tabs-mode nil)
  (setq sh-basic-offset 2)
  (setq fill-column 80)
  (electric-indent-mode))
(add-hook 'sh-mode-hook 'my-sh-mode-hook)
(add-to-list 'auto-mode-alist '("bashrc" . sh-mode))

(defun my-js-mode-hook ()
  (setq indent-tabs-mode nil)
  (setq js-basic-offset 2)
  (setq fill-column 80)
  (electric-indent-mode))
(add-hook 'js-mode-hook 'my-js-mode-hook)

(load "~/chrome/src/buildtools/clang_format/script/clang-format.el")
(global-set-key [C-M-tab] 'clang-format-region)

(load "~/.emacs.d/packages/find-things-fast/find-things-fast.el")
(add-to-list 'ftf-filetypes "*.java")
(add-to-list 'ftf-filetypes "*.xml")
(global-set-key '[f1] 'ftf-find-file)
(global-set-key '[f2] 'ftf-grepsource)
(global-set-key '[f4] 'ftf-gdb)
(global-set-key '[f5] 'ftf-compile)

(setq-default inhibit-startup-message t)
(setq-default next-error-highlight t)

(require 'saveplace)
(setq-default save-place t)
