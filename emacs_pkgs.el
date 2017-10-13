#!/usr/bin/emacs --script

(require 'package)
(package-initialize)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

;; Fix HTTP1/1.1 problems
(setq url-http-attempt-keepalives nil)

(package-refresh-contents)

(package-install 'lush-theme)
(package-install 'rubocop)
(package-install 'company)
(package-install 'irony)
(package-install 'company)
(package-install 'company-irony)
(package-install 'company-irony-c-headers)
(package-install 'helm)
(package-install 'helm-gtags)
(package-install 'sr-speedbar)
(package-install 'multiple-cursors)
(package-install 'markdown-mode)
(package-install 'dockerfile-mode)
(package-install 'dts-mode)
(package-install 'rust-mode)
(package-install 'toml-mode)
(package-install 'nasm-mode)
(package-install 'json-mode)
(package-install 'xclip)
(package-install 'racer)
