;; Copyright 2016 Rouslan Solomakhin
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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(backup-directory-alist (quote (("." . "~/.emacs.d/backups"))))
 '(custom-enabled-themes (quote (wombat)))
 '(dynamic-completion-mode t)
 '(fill-column 80)
 '(indent-tabs-mode nil)
 '(package-archives
   (quote
    (("melpa" . "https://melpa.org/packages/")
     ("gnu" . "http://elpa.gnu.org/packages/"))))
 '(package-selected-packages (quote (fill-column-indicator fzf)))
 '(revert-without-query (quote (".*")))
 '(safe-local-variable-values
   (quote
    ((c++-mode
      (c-file-style . "WebKit"))
     (c-mode
      (c-file-style . "WebKit")))))
 '(standard-indent 2)
 '(vc-follow-symlinks t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(package-initialize)
(define-key (current-global-map) "\C-t" 'fzf)

;; Run this to install package-selected-packages:
;; (package-refresh-contents)
;; (package-install-selected-packages)

;; https://chromium.googlesource.com/chromium/src/+/master/docs/emacs.md
(load "~/.emacs.d/google-c-style.el")
(load "~/chrome/src/buildtools/clang_format/script/clang-format.el")

(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'fci-mode)
(add-hook 'c-mode-common-hook
          (function (lambda () (local-set-key (kbd "TAB") 'clang-format-region))))
(add-hook 'java-mode-hook (lambda () (set-fill-column '100)))

(c-add-style "WebKit" '("Google"
                        (c-basic-offset . 4)
                        (fill-column . 120)
                        (c-offsets-alist . ((innamespace . 0)
                                            (access-label . -)
                                            (case-label . 0)
                                            (member-init-intro . +)
                                            (topmost-intro . 0)
                                            (arglist-cont-nonempty . +)))))
