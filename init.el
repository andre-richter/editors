;; Loading files
(let ((default-directory  "~/.emacs.d/lisp/"))
  (normal-top-level-add-to-load-path '("."))
  (normal-top-level-add-subdirs-to-load-path))

;; In emacs nw mode, CTRL+Backspace produces C-h. Also, make it delete, not
;; kill, the last word.
(defun my-delete-word (arg)
  (interactive "p")
  (delete-region
   (point)
   (progn
     (forward-word arg)
     (point))))
(defun backward-delete-word (arg)
  (interactive "p")
  (my-delete-word (- arg)))
(global-set-key (kbd "C-h") 'backward-delete-word)

;; Font size
(set-face-attribute 'default nil :height 140)

;; Scroll line by line when reaching window edges with arrow keys
(setq scroll-step 1 scroll-conservatively 10000)

;; Mouse in terminal mode
;; https://gist.github.com/ftrain/8443721
(require 'xt-mouse)
(xterm-mouse-mode)
(require 'mouse)
(xterm-mouse-mode t)
(defun track-mouse (e))

(setq mouse-wheel-follow-mouse 't)

;; Scroll only a single line per Mouse wheel turn
(defvar alternating-scroll-down-next t)
(defvar alternating-scroll-up-next t)

(defun alternating-scroll-down-line ()
  (interactive "@")
  (when alternating-scroll-down-next
    (scroll-down-line))
  (setq alternating-scroll-down-next (not alternating-scroll-down-next)))

(defun alternating-scroll-up-line ()
  (interactive "@")
  (when alternating-scroll-up-next
    (scroll-up-line))
  (setq alternating-scroll-up-next (not alternating-scroll-up-next)))

(global-set-key (kbd "<mouse-4>") 'alternating-scroll-down-line)
(global-set-key (kbd "<mouse-5>") 'alternating-scroll-up-line)

;; No startup message
(setq inhibit-startup-message t)

;; No menubar
(menu-bar-mode -1)

;; Shows matching parenthesis
(show-paren-mode 1)

;; Shows column numbers
(column-number-mode 1)

;; Show line numbers...
(global-linum-mode 1)

;; ...but not in speedbar
(add-hook 'speedbar-mode-hook (lambda () (linum-mode -1)))

;; Add a single space between line number and buffer
(setq linum-format "%d ")

;; Default windows size
(if window-system
    (set-frame-size (selected-frame) 120 45))

;; Show file full path in title bar
(setq-default frame-title-format
	      (list '((buffer-file-name " %f"
					(dired-directory
					 dired-directory
					 (revert-buffer-function " %b"
								 ("%b - Dir:  " default-directory)))))))

;; Delete trailing whitespace on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Don't save backup files in working directory
(setq backup-directory-alist '(("." . "~/.emacs-backups"))
      backup-by-copying t    ; Don't delink hardlinks
      version-control t      ; Use version numbers on backups
      delete-old-versions t  ; Automatically delete excess backups
      kept-new-versions 20   ; how many of the newest versions to keep
      kept-old-versions 5    ; and how many of the old
      )

;;Melpa
(require 'package)
(package-initialize)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; Integrate clipboard with X11
(xclip-mode 1)

;; Load color Theme
(load-theme 'lush t)

;; C settings
;;
;; Use linux kernel style
(setq c-default-style "linux")

;; Various add-ons for C/C++ syntax highlighting
;;
;; Function calls
(mapc (lambda (mode)
        (font-lock-add-keywords
         mode
         `((,(concat
	      "\\<\\([_a-zA-Z0-9]*\\)\\>" ; Function name
	      "(")                        ; Paren for function invocation
	    1 'font-lock-function-name-face))))
      '(c-mode c++-mode))

;; Struct member assignment
(mapc (lambda (mode)
        (font-lock-add-keywords
         mode
         `((,(concat
	      "[[:space:]]\\."                  ; Whitespace followed by period
	      "\\([[:alpha:]][[:alnum:]_]*\\)") ; Member name
	    1 'font-lock-variable-name-face))))
      '(c-mode c++-mode))

;; Non-digit array index
(mapc (lambda (mode)
        (font-lock-add-keywords
         mode
         `((,(concat
	      "\\["                ; Opening bracket
	      "\\([[:alnum:]]+\\)" ; Index
	      "\\]")               ; Closing bracket
	    1 'font-lock-constant-face))))
      '(c-mode c++-mode))

;; Digits
(mapc (lambda (mode)
        (font-lock-add-keywords
         mode
         `((, "\\<[[:digit:]]+\\>" 0 'font-lock-constant-face))))
      '(c-mode c++-mode))

;; Member selection via object name
(mapc (lambda (mode)
        (font-lock-add-keywords
         mode
         `((,(concat
	      "\\."                 ; period
	      "\\([[:alnum:]_]+\\)" ; member name
	      "[^h>]")              ; don't catch header files
	    1 'font-lock-variable-name-face))))
      '(c-mode c++-mode))


;; Member selection via pointer
(mapc (lambda (mode)
        (font-lock-add-keywords
         mode
         `((,(concat
	      "->"                   ; arrow
	      "\\([[:alnum:]_]+\\)") ; member name
	    1 'font-lock-variable-name-face))))
      '(c-mode c++-mode))

;; Address
(mapc (lambda (mode)
        (font-lock-add-keywords
         mode
         `((,(concat
	      "\\(&\\)"      ; Ampersand
	      "[[:alpha:]]") ; Address object
	    1 'font-lock-keyword-face))))
      '(c-mode c++-mode))

;; Digits
(mapc (lambda (mode)
        (font-lock-add-keywords
         mode
         `((, "\\<nullptr\\>" 0 'font-lock-constant-face))))
      '(c++-mode))

;; switch to auto-fill-mode automatically when opening a .tex file
;; and load reftex mode
(setq reftex-plug-into-AUCTeX t)
(add-hook 'LaTeX-mode-hook
	  '(lambda()
	     (reftex-mode t)
	     ))

;; add make file as option to TeX commands
(eval-after-load "tex"
  '(add-to-list 'TeX-command-list '("Make" "make" TeX-run-command nil t)))

;; correlation between pdf viewer and emacs sources
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-source-correlate-mode t)
 '(TeX-source-correlate-start-server t)
 '(helm-gtags-auto-update t)
 '(helm-gtags-ignore-case t)
 '(helm-gtags-path-style (quote relative))
 '(package-selected-packages
   (quote
    (rust-mode git-gutter yaml-mode xclip toml-mode rubocop nasm-mode multiple-cursors markdown-mode lush-theme json-mode helm-gtags dts-mode dockerfile-mode)))
 '(reftex-toc-split-windows-horizontally t))

'(reftex-use-external-file-finders t)
(setq reftex-ref-macro-prompt nil)

;; LaTeX spacing
(defun latex-spaces-only ()
  (setq LaTeX-indent-level 4)
  (setq LaTeX-item-indent -2))
(add-hook 'LaTeX-mode-hook 'latex-spaces-only)

;; Compilation stuff (from https://github.com/c02y/dotemacs.d/blob/master/init.el)
(require 'compile)
(setq compilation-last-buffer nil)
;; save all modified buffers without asking before compilation
(setq compilation-ask-about-save nil)
(defun compile-again (ARG)
  "Run the same compile as the last time.
First split the current source code window in a given size if
no existed window contains *compilation* buffer.
With a prefix argument or no last time, this acts like M-x compile,
and you can reconfigure the compile args."
  (interactive "p")
  (if (not (get-buffer-window "*compilation*"))
      (split-window-vertically -10))
  (if (and (eq ARG 1) compilation-last-buffer)
      (recompile)
    (call-interactively 'compile)))

(global-set-key (kbd "C-c m") 'compile-again)

(setq compilation-finish-functions
      (lambda (buf str)
	(if (null (string-match ".*exited abnormally.*" str))
	    ;;no errors, make the compilation window go away in a few seconds
	    (progn
	      (run-at-time
	       "1 sec" nil 'delete-windows-on
	       (get-buffer-create "*compilation*"))
	      (message "No Compilation Errors!")))))

;; User customization for Verilog mode
(setq verilog-indent-level             4
      verilog-indent-level-module      4
      verilog-indent-level-declaration 4
      verilog-indent-level-behavioral  4
      verilog-indent-level-directive   1
      verilog-case-indent              2
      verilog-auto-newline             nil
      verilog-auto-indent-on-newline   t
      verilog-tab-always-indent        t
      verilog-auto-endcomments         t
      verilog-minimum-comment-distance 40
      verilog-indent-begin-after-if    t
      verilog-auto-lineup              '(all))

;; Align with spaces only when doing align-regexp
(defadvice align-regexp (around align-regexp-with-spaces)
  "Never use tabs for alignment."
  (let ((indent-tabs-mode nil))
    ad-do-it))
(ad-activate 'align-regexp)

;;
;; helm stuff
;;
(require 'helm)
(require 'helm-config)

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t)

(helm-mode 1)

(global-set-key (kbd "M-x") 'helm-M-x)
(setq helm-M-x-fuzzy-match t) ;; optional fuzzy matching for helm-M-x

(global-set-key (kbd "M-y") 'helm-show-kill-ring)

(global-set-key (kbd "C-x b") 'helm-mini)
(setq helm-buffers-fuzzy-matching t
      helm-recentf-fuzzy-match    t)

(global-set-key (kbd "C-x C-f") 'helm-find-files)

(when (executable-find "ack-grep")
  (setq helm-grep-default-command "ack-grep -Hn --no-group --no-color %e %p %f"
        helm-grep-default-recurse-command "ack-grep -H --no-group --no-color %e %p %f"))

(setq helm-semantic-fuzzy-match t
      helm-imenu-fuzzy-match    t)

(global-set-key (kbd "C-c h o") 'helm-occur)

;; Semantic mode for helm
(semantic-mode 1)

;;; Enable helm-gtags-mode
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'asm-mode-hook 'helm-gtags-mode)

;; customize


;; key bindings
(with-eval-after-load 'helm-gtags
  (define-key helm-gtags-mode-map (kbd "M-t") 'helm-gtags-find-tag)
  (define-key helm-gtags-mode-map (kbd "M-r") 'helm-gtags-find-rtag)
  (define-key helm-gtags-mode-map (kbd "M-s") 'helm-gtags-find-symbol)
  (define-key helm-gtags-mode-map (kbd "M-g M-p") 'helm-gtags-parse-file)
  (define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
  (define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)
  (define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack))

;; Multiple cursors settings
(require 'multiple-cursors)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)

(global-set-key (kbd "C-t") 'mc/mark-next-like-this)
;;(global-set-key (kbd "C-q") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-t") 'mc/mark-all-like-this)

;; Auto close parens
(electric-pair-mode 1)

;; NASM mode
(add-hook 'nasm-mode-hook
	  (lambda () (setq-default nasm-basic-offset 4)))

;; In some modes, never use tabs to indent, only spaces
(defun spaces-only ()
  (setq indent-tabs-mode nil)
  (setq tab-width 4))
(add-hook 'verilog-mode-hook 'spaces-only)
(add-hook 'dockerfile-mode-hook 'spaces-only)
(add-hook 'asm-mode-hook 'spaces-only)

;; Adjust auto-fill-mode for Markdown
(defun my-markdown-mode-hook ()
  (auto-fill-mode t))

(add-hook 'markdown-mode-hook 'my-markdown-mode-hook)

(setq-default fill-column 80)
(setq-default show-trailing-whitespace t)

(defun c-lineup-arglist-tabs-only (ignored)
  "Line up argument lists by tabs, not spaces"
  (let* ((anchor (c-langelem-pos c-syntactic-element))
	 (column (c-langelem-2nd-pos c-syntactic-element))
	 (offset (- (1+ column) anchor))
	 (steps (floor offset c-basic-offset)))
    (* (max steps 1)
       c-basic-offset)))

(add-hook 'c-mode-common-hook
	  (lambda ()
	    ;; Add kernel style
	    (c-add-style
	     "linux-tabs-only"
	     '("linux" (c-offsets-alist
			(arglist-cont-nonempty
			 c-lineup-gcc-asm-reg
			 c-lineup-arglist-tabs-only))))))

(add-hook 'c-mode-hook
	  (lambda ()
	    (let ((filename (buffer-file-name)))
	      ;; Enable kernel mode for the appropriate files
	      (when (and filename
			 (string-match (expand-file-name "/opt/git")
				       filename))
		(setq indent-tabs-mode t)
		(setq show-trailing-whitespace t)
		(c-set-style "linux-tabs-only")))))

(setq ruby-indent-level 4)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
