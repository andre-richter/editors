;; Font size
(set-face-attribute 'default nil :height 140)

;; No startup message
(setq inhibit-startup-message t)

;; No toolbar
(tool-bar-mode -1)

;; Shows matching parenthesis
(show-paren-mode 1)

;; Shows column numbers
(column-number-mode 1)

;; Show line Numbers
(global-linum-mode 1)

;; Disable all version control
(setq vc-handled-backends nil)

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
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/") t)

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
(add-hook 'LaTeX-mode-hook
	  '(lambda()
	     ;(turn-on-auto-fil)lem
	     (setq fill-column 80)))

;; LaTeX spacing
(defun latex-spaces-only ()
  (setq LaTeX-indent-level 8)
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

;; In verliog mode, never use tabs to indent, only spaces
(defun verilog-spaces-only ()
  (setq indent-tabs-mode nil)
  (setq tab-width 4))
(add-hook 'verilog-mode-hook 'verilog-spaces-only)

;; Align with spaces only when doing align-regexp
(defadvice align-regexp (around align-regexp-with-spaces)
  "Never use tabs for alignment."
  (let ((indent-tabs-mode nil))
    ad-do-it))
(ad-activate 'align-regexp)

(add-hook 'after-init-hook 'global-company-mode)

(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

;; replace the `completion-at-point' and `complete-symbol' bindings in
;; irony-mode's buffers by irony-mode's function
(defun my-irony-mode-hook ()
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async))
(add-hook 'irony-mode-hook 'my-irony-mode-hook)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

(eval-after-load 'company
  '(add-to-list 'company-backends 'company-irony))

(eval-after-load 'company
  '(add-to-list 'company-backends 'company-files))

(require 'company-irony-c-headers)
;; Load with `irony-mode` as a grouped backend
(eval-after-load 'company
  '(add-to-list
    'company-backends '(company-irony-c-headers company-irony)))

(global-set-key (kbd "C-c f") 'company-files)
(global-set-key (kbd "C-c c") 'company-complete)