;;; c-config --- Summary
;;; Commentary:
;;; Code:

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(global-ede-mode)
(defun kafka/c-mode-common-hook ()
  "Setup keybindings etc."
  (local-set-key (kbd "M-.") 'semantic-ia-fast-jump)
  ;; Jump to include file
  ;;   mneumonic: "&" is reference
  (local-set-key (kbd "M-7") 'senator-go-to-up-reference)
  ;; bind describe class, looks very useful
  ;;   mneumonic: "This equals"
  (local-set-key (kbd "C-=") 'semantic-ia-describe-class)
  ;;   playing with C-z for local mode stuff
  (local-set-key (kbd "C-z d") 'semantic-ia-describe-class)
  ;; Find references
  ;;   mneumonic: # is number of occurences
  (local-set-key (kbd "M-3") 'semantic-symref)
  ;; Senator code folding until semantic gets working
  ;;   mneumonic: "*" is expand/contract
  (local-set-key (kbd "M-8") 'senator-fold-tag-toggle)
  )
(add-hook 'c-mode-common-hook 'kafka/c-mode-common-hook)


;;; Create (uniloc) projects here.
(ede-cpp-root-project "test_proj" :file "~/uniloc/test/cpp_proj/readme.org"
		      :include-path '("/proj" "/testlib"))



(provide 'kafka/c-config)
