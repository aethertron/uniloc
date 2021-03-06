;;; package --- Summary
;;; Commentary:
;;; Code:
(server-start)
;; load settings / customize
(setq custom-file (concat user-emacs-directory "settings.el"))
(load custom-file)
;;
(load-theme 'deeper-blue)
;; -- Minor Modes Begin --
(electric-pair-mode 1)
(show-paren-mode 1)
(column-number-mode 1)
(ido-mode 1)
;; -- Minor Modes End --
;; global-config
(setq truncate-lines 1)
;;(set-frame-parameter (selected-frame) 'alpha '(85 50))

;;
(setq mouse-autoselect-window t)
;; -- window management related --
(windmove-default-keybindings)
;; ctrl-tab support
(global-set-key (kbd "<C-tab>") 'next-multiframe-window)
(global-set-key (kbd "<C-iso-lefttab>") 'previous-multiframe-window)
;; get rid of ibm's page keys if bound
(global-unset-key (kbd "<XF86Back>"))
(global-unset-key (kbd "<XF86Forward>"))
;; -- window management end --

;; -- Paths/Packages Etc
;; site-lisp
(setq site-lisp "~/.emacs.d/site-lisp")
(add-to-list 'load-path site-lisp)

;; packages
(require 'package)
(setq package-archives '())

;; add package archives
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "https://marmalade-repo.org/packages/"))

;; initialize packages and grab use-package
(package-initialize)  ;; add elpa to the load path?
(require 'use-package) ;; note: if fail, install use-package manually
;; -- Path/Packages End



;; ** global key mapping
;; *** remove stuff
(global-unset-key (kbd "C-z")) 		;remove suspend frame

;; *** Bind to commands from kafkalib
(require 'kafkalib/etc)
(global-set-key (kbd "C-c t") 'rename-buffer)
(global-set-key (kbd "C-c x") 'kafkalib/launch-shell)
(global-set-key (kbd "C-c h") 'hl-line-mode)
(global-set-key (kbd "C-c f") 'find-file-at-point)
(global-set-key (kbd "C-c w") 'kafkalib/copy-buffer-filename)
(global-set-key (kbd "C-c r") 'toggle-truncate-lines) ; pneumonic: (r)otate text
(global-set-key (kbd "<f5>") 'revert-buffer)
;; **** Bring in open lines
(global-unset-key (kbd "C-o"))
(global-unset-key (kbd "C-O"))
(global-set-key (kbd "C-o") 'kafkalib/open-next-line)
(global-set-key (kbd "C-S-o") 'kafkalib/open-prev-line)

;; *** Swap indentation commands
(global-set-key (kbd "M-m") 'move-beginning-of-line)
(global-set-key (kbd "C-a") 'back-to-indentation)

(require 'kafkabro/org)
(require 'kafkabro/emacs-lisp)
(require 'kafkabro/dired)
(require 'kafka/c-config)

;; remove tool-bar
(require 'menu-bar)
(menu-bar-showhide-tool-bar-menu-customize-disable)

;; - smex -
(use-package smex :ensure t)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

;; * company mode
(use-package company :ensure t
  :bind (:map company-mode-map
	      ("C-M-i" . company-complete)
	      ;;("C-M-S-i" . completion-at-point) ; using helm-company instead
	 :map company-active-map
	      ("M-p" . nil)
	      ("M-n" . nil)
	      ("C-p" . company-select-previous-or-abort)
	      ("C-n" . company-select-next-or-abort)))
(global-company-mode)

;; * ivy begin
(use-package ivy :ensure t
  :config (ivy-mode)
  :bind
  ("C-x C-b" . ivy-switch-buffer)
  )



(use-package counsel :ensure t
  :bind
  ("M-x" . counsel-M-x)
  ("C-x C-f" . counsel-find-file)
  ;; help commands
  ("C-h f" . counsel-describe-function)
  ("C-h v" . counsel-describe-variable)
  ("C-h b" . counsel-descbinds)
  ("M-s l" . counsel-ag)
  )


;; projectile
(use-package projectile :ensure t
  :config (projectile-global-mode))

;; helm
;;(require 'noosphere/helm-config)


;; local packages
(use-package elpakit :ensure t)
;; (require 'nispio/package-config)


;; - avy -
(use-package avy :ensure t)
(global-set-key (kbd "C-;") 'avy-goto-word-or-subword-1)

;; * multiple cursors begin
(use-package multiple-cursors :ensure t)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "M-s M-s") 'mc--mark-symbol-at-point)
(global-set-key (kbd "C-c C->") 'mc/mark-more-like-this-extended)

;; * multiple cursors end

;; - buffer-move -
(use-package buffer-move :ensure t)
(global-set-key (kbd "<C-M-tab>") 'buf-move-right)
(global-set-key (kbd "<C-M-S-iso-lefttab>") 'buf-move-left)
(global-set-key (kbd "<C-S-up>")     'buf-move-up)
(global-set-key (kbd "<C-S-down>")   'buf-move-down)
(global-set-key (kbd "<C-S-left>")   'buf-move-left)
(global-set-key (kbd "<C-S-right>")  'buf-move-right)

;; move-text
(use-package move-text :ensure t :config (move-text-default-bindings))

;; - which-key
(use-package which-key :ensure t)
(which-key-mode 1)


(use-package ws-butler :ensure t)
(ws-butler-global-mode)

;; * line
(use-package page-break-lines :ensure t)
(global-page-break-lines-mode)

;; * dumb-jump
(use-package dumb-jump :ensure t)

;; * comint mode
(defun kafka/comint-mode-hook ()
  (local-set-key (kbd "M-p") 'comint-previous-matching-input-from-input))
(add-hook 'comint-mode-hook 'kafka/comint-mode-hook)
;; discover-my-major
(use-package discover-my-major :ensure t)
;; discover
;;(use-package discover :ensure t)

;; ** semantic mode
(require 'semantic)
(semantic-mode 1)
(global-semanticdb-minor-mode)

;; ** flycheck config
(when (load "flycheck" t)
      (use-package flycheck :ensure t)
      (global-flycheck-mode)
      (use-package flycheck-pos-tip :ensure t)
      (flycheck-pos-tip-mode)
      (defun kafkalib/flycheck-mode-hook ()
	(local-set-key (kbd "C-c e") 'flycheck-display-error-at-point)
	(local-set-key (kbd "C-.") 'flycheck-next-error)
	(local-set-key (kbd "C-,") 'flycheck-previous-error)
	)
      (add-hook 'flycheck-mode-hook 'kafkalib/flycheck-mode-hook)

      ;; flycheck is not my thing at the moment
      ;;(use-package eclim :ensure t)	; flycheck errored on builld w/o eclim
      ;;(use-package flycheck-tip :ensure t)
      ;;(local-set-key (kbd "C-c e") 'flycheck-tip-cycle)
      )

;; * ace-link begin
(use-package ace-link :ensure t)
(ace-link-setup-default "f")
;; * ace-link end

;; gnuplot begin
;; (use-package gnuplot :ensure t)
;; (use-package gnuplot-mode :ensure t)

;; zygosphere
(use-package zygospore :ensure t)
(global-set-key (kbd "C-x 1") 'zygospore-toggle-delete-other-windows)

;; undo tree
(use-package undo-tree :ensure t)
(global-undo-tree-mode 1)

;; diredp
(use-package dired+ :ensure t)


;; * major modes

;; ** shell begin
(defun wgs85/shell-mode-hook ()
  "Config for shell mode!"
  (orgtbl-mode))
(add-hook 'shell-mode-hook 'wgs85/shell-mode-hook)

;; ** json mode
(use-package json-mode :ensure t)	; importing this allows flycheck to work with json

;; ** python mode
;; *** elpy enable: requires pip install of python packages:
;;     pip install jedi flake8 importmagic autopep8 yapf
(use-package elpy :ensure t)
(elpy-enable)

(defun wgs85/python-mode-hook ()
  "Python mode hook."
  ;;(dumb-jump 1) ; should we use dumb-jump?
  (orgtbl-mode))
(add-hook 'python-mode 'wgs85/python-mode-hook)


;; ** markdown mode
(use-package markdown-mode :ensure t)
(use-package markdown-mode+ :ensure t)
(use-package markdown-preview-eww :ensure t)
(use-package markdown-preview-mode :ensure t)

;; ** web-mode
(require 'noosphere/web)


;;  * execute local elisp
(when (load "local" t)
  (message "Running local elisp code"))


;; * machine-specific config
(defun wgs85/fathertron-config ()
  "Geeknote begin."
  (set-face-attribute 'default nil :height 90)
  (use-package geeknote :ensure t)
  ;; * geeknote end

  ;; - spotify
  (use-package spotify :ensure t)
  (spotify-enable-song-notifications)

  ;; * magit
  (use-package magit :ensure t)

  )

(when (or (string= system-name "fatherTron-Manjaro")
	  (string= system-name "fatherTron-Manjaro.Home")
	  (string= system-name "ft-apr")
	  (string= system-name "ft-apr.Home")
	  )
  (wgs85/fathertron-config))
(put 'dired-find-alternate-file 'disabled nil)
(put 'narrow-to-region 'disabled nil)
