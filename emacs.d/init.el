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

(if (functionp 'scroll-bar-mode) (scroll-bar-mode 0))
(if (functionp 'tool-bar-mode) (tool-bar-mode 0))
(menu-bar-mode 0)

(add-hook 'find-file-hook 'elide-head)
(defalias 'yes-or-no-p 'y-or-n-p)
(electric-pair-mode)
(global-set-key (kbd "C-x C-r") 'recentf-open-files)
(global-set-key (kbd "C-x b") 'bs-show)
(recentf-mode)
(savehist-mode)
(windmove-default-keybindings)

(add-hook 'prog-mode-hook (lambda ()
                            (if (functionp 'global-company-mode)
                                (global-company-mode))))
(add-hook 'c++-mode-hook 'ycmd-mode)
(add-hook 'ycmd-mode-hook
          (lambda ()
            (company-ycmd-setup)
            (flycheck-mode)
            (flycheck-ycmd-setup)))
(set-variable 'ycmd-server-command '("python" "-u"))
(add-to-list 'ycmd-server-command (expand-file-name "~/.ycmd/ycmd") t)
(set-variable 'ycmd-global-config
              "~/chrome/src/tools/vim/chromium.ycm_extra_conf.py")
(when (not (display-graphic-p))
  (setq flycheck-indication-mode nil))

(add-hook 'go-mode-hook
          (lambda ()
            (ycmd-mode)
            (add-hook 'before-save-hook 'gofmt-before-save)))

(add-hook 'java-mode-hook (lambda ()
                            (setq c-basic-offset 4)
                            (setq fill-column 100)))

(defun install-my-packages ()
  (interactive)
  (package-initialize)
  (package-refresh-contents)
  (mapc
   (lambda (p)
     (or (package-installed-p p)
         (package-install p)))
   '(clang-format company-ycmd flycheck-ycmd go-mode google-c-style))
  (message "Done."))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(bs-default-sort-name "by filename")
 '(c-mode-common-hook (quote (google-set-c-style)))
 '(column-number-mode t)
 '(compilation-always-kill t)
 '(compilation-ask-about-save nil)
 '(compilation-auto-jump-to-first-error t)
 '(compilation-scroll-output (quote first-error))
 '(compilation-window-height 20)
 '(compile-command "ninja -Cout/Debug -l10 -j10")
 '(custom-enabled-themes (quote (tango-dark)))
 '(electric-indent-mode t)
 '(elide-head-headers-to-hide (quote (("Copyright .... The Chromium Authors" . "found in the LICENSE file\\.") ("Copyright" . "limitations under the License\\."))))
 '(fill-column 80)
 '(global-whitespace-mode t)
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(kill-whole-line t)
 '(linum-delay t)
 '(package-archives (quote (("melpa" . "http://melpa.org/packages/") ("gnu" . "http://elpa.gnu.org/packages/"))))
 '(require-final-newline t)
 '(save-place t nil (saveplace))
 '(sentence-end-double-space nil)
 '(sh-basic-offset 2)
 '(sh-indentation 2)
 '(show-trailing-whitespace t)
 '(standard-indent 2)
 '(tab-width 2)
 '(uniquify-buffer-name-style (quote forward) nil (uniquify))
 '(vc-follow-symlinks t)
 '(vc-handled-backends (quote (Git)))
 '(vc-initial-comment t)
 '(whitespace-line-column nil)
 '(whitespace-style (quote (trailing space-before-tab empty space-after-tab face lines))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(mode-line ((t (:background "grey75" :foreground "black"))))
 '(mode-line-inactive ((t (:inherit mode-line :background "grey90" :foreground "grey20" :weight light)))))
