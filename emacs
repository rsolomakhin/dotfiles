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
 '(auto-save-default nil)
 '(backup-directory-alist (quote (("." . "~/.emacs.d/backups"))))
 '(column-number-mode t)
 '(company-backends
   (quote
    (company-ycmd company-nxml company-css company-eclim company-semantic company-capf company-files
                  (company-dabbrev-code company-keywords)
                  company-dabbrev)))
 '(company-idle-delay 0.15)
 '(custom-enabled-themes (quote (wombat)))
 '(dynamic-completion-mode t)
 '(fill-column 80)
 '(indent-tabs-mode nil)
 '(menu-bar-mode nil)
 '(package-archives
   (quote
    (("melpa" . "https://melpa.org/packages/")
     ("gnu" . "http://elpa.gnu.org/packages/"))))
 '(package-selected-packages
   (quote
    (flycheck-ycmd company-ycmd flycheck company fzf google-c-style clang-format)))
 '(revert-without-query (quote (".*")))
 '(safe-local-variable-values
   (quote
    ((c++-mode
      (c-file-style . "WebKit"))
     (c-mode
      (c-file-style . "WebKit")))))
 '(scroll-bar-mode nil)
 '(standard-indent 2)
 '(tool-bar-mode nil)
 '(url-show-status nil)
 '(vc-follow-symlinks t)
 '(ycmd-global-config "~/chrome/src/tools/vim/chromium.ycm_extra_conf.py")
 '(ycmd-parse-conditions (quote (save new-line mode-enabled)))
 '(ycmd-server-command (quote ("ycmd-server-helper"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(package-initialize)
(define-key (current-global-map) "\C-t" 'fzf)

(windmove-default-keybindings)

;; Run this to install package-selected-packages:
;; (package-refresh-contents)
;; (package-install-selected-packages)

(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)
(add-hook 'c-mode-common-hook (lambda () (local-set-key (kbd "TAB") 'clang-format-region)))
(add-hook 'java-mode-hook (lambda () (setq c-basic-offset 4 fill-column 100)))

(c-add-style "WebKit" '("Google"
                        (c-basic-offset . 4)
                        (fill-column . 120)
                        (c-offsets-alist . ((innamespace . 0)
                                            (access-label . -)
                                            (case-label . 0)
                                            (member-init-intro . +)
                                            (topmost-intro . 0)
                                            (arglist-cont-nonempty . +)))))

(add-hook 'c++-mode-hook        'ycmd-mode)
(add-hook 'c-mode-hook          'ycmd-mode)
(add-hook 'java-mode-hook       'ycmd-mode)
(add-hook 'javascript-mode-hook 'ycmd-mode)

(add-hook 'prog-mode-hook 'company-mode)
(add-hook 'prog-mode-hook 'flycheck-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)

(company-ycmd-setup)
(flycheck-ycmd-setup)
