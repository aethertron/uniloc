;;; c-config --- Summary
;;; Commentary:
;;; Code:

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(global-ede-mode)
(defun kafka/c-mode-common-hook ()
  "Setup keybindings etc."
  (local-set-key (kbd "M-.") 'semantic-ia-fast-jump)
  (local-set-key (kbd "M-.") 'semantic-ia-describe-class)
    )
(add-hook 'c-mode-common-hook 'kafka/c-mode-common-hook)


;;; Create (uniloc) projects here.
(ede-cpp-root-project "test_proj" :file "~/uniloc/test/cpp_proj/readme.org"
		      :include-path '("/proj" "/testlib"))



(provide 'kafka/c-config)
