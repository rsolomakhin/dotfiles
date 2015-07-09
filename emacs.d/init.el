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

(defalias 'yes-or-no-p 'y-or-n-p)
(savehist-mode)
(windmove-default-keybindings)

(add-to-list 'auto-mode-alist '("\\.gn" . python-mode))
(add-to-list 'auto-mode-alist '("\\.gyp" . python-mode))
(add-to-list 'auto-mode-alist '("\\.gypi" . python-mode))
(add-to-list 'auto-mode-alist '("\\.h" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.mm" . objc-mode))

(add-hook 'prog-mode-hook
          (lambda ()
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

(add-hook 'go-mode-hook
          (lambda ()
            (ycmd-mode)
            (add-hook 'before-save-hook 'gofmt-before-save)))

(add-hook 'java-mode-hook
          (lambda ()
            (setq c-basic-offset 4)
            (setq fill-column 100)))

(defun install-my-packages ()
  (interactive)
  (package-initialize)
  (package-refresh-contents)
  (setq compilation-auto-jump-to-first-error nil)
  (mapc
   (lambda (p)
     (or (package-installed-p p)
         (package-install p)))
   '(clang-format company-ycmd flycheck-ycmd go-mode google-c-style markdown-mode))
  (message "Done."))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(c-mode-common-hook (quote (google-set-c-style)))
 '(column-number-mode t)
 '(compilation-always-kill t)
 '(compilation-ask-about-save nil)
 '(compilation-auto-jump-to-first-error t)
 '(compilation-window-height 20)
 '(compile-command "ninja -Cout/Debug -l10 -j10")
 '(fill-column 80)
 '(find-file-hook (quote (global-font-lock-mode-check-buffers save-place-find-file-hook)))
 '(indent-tabs-mode nil)
 '(linum-delay t)
 '(package-archives (quote (("melpa" . "http://melpa.org/packages/") ("gnu" . "http://elpa.gnu.org/packages/"))))
 '(python-indent-guess-indent-offset nil)
 '(python-indent-offset 2)
 '(require-final-newline t)
 '(save-place t nil (saveplace))
 '(sentence-end-double-space nil)
 '(sh-basic-offset 2)
 '(standard-indent 2)
 '(tab-width 2)
 '(uniquify-buffer-name-style (quote forward) nil (uniquify)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
