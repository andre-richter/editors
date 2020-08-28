#!/usr/bin/emacs --script

(require 'package)
(package-initialize)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; Fix HTTP1/1.1 problems
(setq url-http-attempt-keepalives nil)

(package-refresh-contents)

(package-install 'lush-theme)
(package-install 'rubocop)
(package-install 'helm)
(package-install 'helm-gtags)
(package-install 'multiple-cursors)
(package-install 'markdown-mode)
(package-install 'dockerfile-mode)
(package-install 'dts-mode)
(package-install 'toml-mode)
(package-install 'yaml-mode)
(package-install 'nasm-mode)
(package-install 'json-mode)
(package-install 'xclip)

