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
