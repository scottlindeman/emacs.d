(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;General startup preferences
(delete-selection-mode t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(blink-cursor-mode t)
(show-paren-mode t)
(column-number-mode t)
(menu-bar-mode 0)
;;Start with split screen
(split-window-horizontally)
(other-window 1)
(shell)
(other-window 1)
(set-face-attribute 'default nil :height 100)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)

;;Save all tempfiles in $TMPDIR/emacs$UID/                                                        
(defconst emacs-tmp-dir (format "%s/%s%s/" "/tmp" "emacs" (user-uid)))
(setq backup-directory-alist
      `((".*" . ,emacs-tmp-dir)))
(setq auto-save-file-name-transforms
      `((".*" ,emacs-tmp-dir t)))
(setq auto-save-list-file-prefix
      emacs-tmp-dir)

;;Themes
(load-theme 'wombat)

;; -- File associations --
;; Rails
(setq auto-mode-alist (cons '("Gemfile" . ruby-mode) auto-mode-alist))
;; Javascript
(setq auto-mode-alist (cons '("\\.js$" . js2-mode) auto-mode-alist))
;; Octave
(setq auto-mode-alist (cons '("\\.m$" . octave-mode) auto-mode-alist))

;;Load nxhtml
(load "~/.emacs.d/nxhtml/autostart.el")

;;Package management
(require 'package)
(package-initialize)

;;flymake hooks
(require 'flymake-gjshint)
(add-hook 'js-mode-hook 'flymake-gjshint:load)

(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives 
	     '("tromey" . "http://tromey.com/elpa/"))
(add-to-list 'package-archives 
	     '("marmalade" . "http://marmalade-repo.org/packages/"))
