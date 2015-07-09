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

(add-to-list 'load-path "~/.emacs.d/lisp/company-mode")

(autoload
  'clang-format
  "~/.emacs.d/lisp/clang-format/clang-format"
  "Format code"
  t)

(autoload
  'google-set-c-style
  "~/.emacs.d/lisp/styleguide/google-c-style")

(autoload
  'company-mode
  "~/.emacs.d/lisp/company-mode/company")

(defalias 'yes-or-no-p 'y-or-n-p)
(savehist-mode t)

(add-to-list 'auto-mode-alist '("DEPS" . python-mode))
(add-to-list 'auto-mode-alist '("\\.gn" . python-mode))
(add-to-list 'auto-mode-alist '("\\.gyp" . python-mode))
(add-to-list 'auto-mode-alist '("\\.gypi" . python-mode))
(add-to-list 'auto-mode-alist '("\\.h" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.mm" . objc-mode))

(add-hook 'prog-mode-hook 'company-mode)
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'after-save-hook
          (lambda ()
            (if (string= (buffer-name) "init.el")
                (byte-compile-file "~/.emacs.d/init.el"))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
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
 '(make-backup-files nil)
 '(menu-bar-mode nil)
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
