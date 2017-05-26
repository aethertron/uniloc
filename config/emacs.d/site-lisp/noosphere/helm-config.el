

;; * helm modes begin
(use-package helm :ensure t)
(global-set-key (kbd "M-s o") 'helm-occur) ;; remap occur to helm-occur
(global-set-key (kbd "C-h a") 'helm-apropos) ;; remap apropos to helm-apropos
(global-set-key (kbd "M-X") 'helm-M-x)
(global-set-key (kbd "C-x C-b") 'helm-mini) ; buffer-list -> helm-mini, list with narrowing
(global-set-key (kbd "C-x r b") 'helm-bookmarks)
(global-set-key (kbd "C-x c i") 'helm-semantic-or-imenu)
(global-set-key (kbd "C-h p") 'helm-list-elisp-packages)
;; ** helm swoop
(use-package helm-swoop :ensure t)
(global-set-key (kbd "M-s i") 'helm-swoop)
(global-set-key (kbd "M-s I") 'helm-swoop-back-to-last-point)
(global-set-key (kbd "M-s M-i i") 'helm-multi-swoop)
(global-set-key (kbd "M-s M-i I") 'helm-multi-swoop-all)
(global-set-key (kbd "M-s M-i o") 'helm-multi-swoop-org)

;; ** helm desc key
(use-package helm-descbinds :ensure t)
(helm-descbinds-mode t)
;; ** helm-ag
(use-package helm-ag :ensure t)
;; ** helm-company
(use-package helm-company :ensure t
  :bind (:map company-mode-map ("C-M-S-i" . helm-company)
	 :map company-active-map ("C-M-S-i" . helm-company)))
;; * helm end

;; * nispio section begin
(require 'nispio/helm-silver)
(require 'nispio/helm-extra)
(require 'nispio/mc-extra)
(nispio/mc-setup-mark-lines)
(nispio/setup-helm-apropos)
(global-set-key (kbd "C-h A") 'nispio/helm-customize-group)
(global-set-key (kbd "C-h M-a") 'nispio/helm-customize-option)
(global-set-key (kbd "M-s p") 'helm-silver-project-root) ; "project"
(global-set-key (kbd "M-s l") 'helm-silver-cwd) ; "location"
(global-set-key (kbd "M-s u") 'helm-silver-home) ; "user"
;; * nispio section end

;; - helm-spotify
(use-package helm-spotify :ensure t)

(provide 'noosphere/helm-config)
;;; helm-config.el ends here
