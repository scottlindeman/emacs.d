(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; User Settings
(setq user-full-name "Scott Lindeman")
(setq user-mail-address "scott.lindeman@gmail.com")

;; Window Settings
(when window-system
  (setq frame-title-format '(buffer-file-name "%f" ("%b"))))

(setq-default indicate-empty-lines t)
(when (not indicate-empty-lines)
  (toggle-indicate-empty-lines))

;; Editor Settings
(require 'cl)
(defalias 'yes-or-no-p 'y-or-n-p)

(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-;") 'comment-or-uncomment-region)
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(delete-selection-mode 1)
(show-paren-mode t)
(setq-default indent-tabs-mode nil)
(setq tab-width 2)
(defvaralias 'c-basic-offset 'tab-width)
(defvaralias 'cperl-indent-level 'tab-width)
(setq js2-basic-offset tab-width) 
(setq css-indent-offset tab-width)

(set-face-attribute 'default nil :height 100)

(setq column-number-mode t
      inhibit-startup-screen t
      initial-scratch-message nil
      transient-mark-mode t
      blink-cursor-mode t
      x-select-enable-clipboard t
      echo-keystrokes 0.1
      use-dialog-box nil
      initial-frame-alist (quote ((fullscreen . maximized))))

;; Save all tempfiles in $TMPDIR/emacs$UID/                                                    
(defconst emacs-tmp-dir (format "%s/%s%s/" "/tmp" "emacs" (user-uid)))
(setq backup-directory-alist
      `((".*" . ,emacs-tmp-dir)))
(setq auto-save-file-name-transforms
      `((".*" ,emacs-tmp-dir t)))
(setq auto-save-list-file-prefix
      emacs-tmp-dir)

;; Package Management
(load "package")
(package-initialize)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives 
             '("tromey" . "http://tromey.com/elpa/"))

(setq package-archive-enable-alist '(("melpa" deft magit)))

(defvar scott/packages '(ac-slime
                         ac-js2
                         auto-complete
                         autopair
                         clojure-mode
                         clojure-test-mode
                         coffee-mode
                         deft
                         flymake
                         flymake-css
                         flymake-python-pyflakes
                         gist
                         go-mode
                         haml-mode
                         haskell-mode
                         htmlize
                         js2-mode
                         magit
                         markdown-mode
                         marmalade
                         nrepl
                         o-blog
                         octave-mod
                         org
                         paredit
                         puppet-mode
                         restclient
                         rvm
                         scala-mode2
                         sml-mode
                         yaml-mode
                         zenburn-theme)
  "Default packages")

(defun scott/packages-installed-p ()
  (loop for pkg in scott/packages
        when (not (package-installed-p pkg)) do (return nil)
        finally (return t)))

(unless (scott/packages-installed-p)
  (message "%s" "Refreshing package database...")
  (package-refresh-contents)
  (dolist (pkg scott/packages)
    (when (not (package-installed-p pkg))
      (package-install pkg))))

;; Themes
(load-theme 'zenburn t)

;;------------------------------------------------------------------------------

;; Utilities

;;TODO: Set up ORG

; Ido
(ido-mode t)
(setq ido-enable-flex-matching t
      ido-use-virtual-buffers t)

; Autopair
(require 'autopair)

; Auto Complete
(require 'auto-complete-config)
(ac-config-default)

; Flyspell
(setq flyspell-issue-welcome-flag nil)
(setq-default ispell-program-name "aspell")
(setq-default ispell-list-command "list")

;; Cleanup
(defun untabify-buffer ()
  (interactive)
  (untabify (point-min) (point-max)))

(defun indent-buffer ()
  (interactive)
  (indent-region (point-min) (point-max)))

(defun cleanup-buffer ()
  "Perform a bunch of operations on the whitespace content of a buffer."
  (interactive)
  (indent-buffer)
  (untabify-buffer)
  (delete-trailing-whitespace))

(defun cleanup-region (beg end)
  "Remove tmux artifacts from region."
  (interactive "r")
  (dolist (re '("\\\\│\·*\n" "\W*│\·*"))
    (replace-regexp re "" nil beg end)))

(global-set-key (kbd "C-x M-t") 'cleanup-region)
(global-set-key (kbd "C-c n") 'cleanup-buffer)

;;------------------------------------------------------------------------------

;; Language Specific

; Ruby
(add-hook 'ruby-mode-hook
          (lambda ()
            (autopair-mode)))

(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Capfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Vagrantfile" . ruby-mode))

; Javascript
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-hook 'js2-mode-hook
	  (lambda ()
            (autopair-mode)
            (ac-js2-mode)))

; CSS
;;TODO: CSSLINT
;(require 'flymake-css)
(add-hook 'css-mode-hook
          (lambda ()
            (autopair-mode)))
            ;(flymake-css-load)))

; Python
;;NOTE: Remember to install pyflakes via pip
(require 'flymake-python-pyflakes)
(add-hook 'python-mode-hook
          (lambda ()
            (autopair-mode)
            (flymake-python-pyflakes-load)))

; R
;; ESS STUFF
(add-to-list 'load-path "elpa/ess-20140716.2033/lisp")
(autoload 'R-mode "ess-site.el" "ESS" t)
(add-to-list 'auto-mode-alist '("\\.R$" . R-mode))
