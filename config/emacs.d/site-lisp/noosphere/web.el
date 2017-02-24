;;; noosphere/web.el --- Summary
;;; Commentary:
;;; Code:

(use-package web-mode :ensure t
  :mode (("\\.phtml\\'" . web-mode)
	 ("\\.tpl\\.php\\'" . web-mode)
	 ("\\.[agj]sp\\'" . web-mode)
	 ("\\.as[cp]x\\'" . web-mode)
	 ("\\.erb\\'" . web-mode)
	 ("\\.mustache\\'" . web-mode)
	 ("\\.djhtml\\'" . web-mode)
	 ("\\.html?\\'" . web-mode))
  :bind (:map web-mode-map ("C-c C-v" . browse-url-of-buffer)))

;; Autoload: company-web
(use-package company-web :ensure t
  :init (progn (require 'company)
	       (add-to-list 'company-backends 'company-web-html)
	       (add-to-list 'company-backends 'company-web-jade)
	       (add-to-list 'company-backends 'company-web-slim)
	       "t"))

(use-package ac-html-bootstrap :ensure t
  :init (add-hook 'web-mode-hook 'company-web-bootstrap+))

(provide 'noosphere/web)
;;; web.el ends here
