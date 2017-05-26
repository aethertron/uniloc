;;; c-config --- Summary
;;; Commentary:
;;; Code:

(use-package rtags :ensure t)
(use-package flycheck-rtags :ensure t)

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; ensure that we use only rtags checking
;; https://github.com/Andersbakken/rtags#optional-1
(defun setup-flycheck-rtags ()
  (interactive)
  (flycheck-select-checker 'rtags)
  ;; RTags creates more accurate overlays.
  (setq-local flycheck-highlighting-mode nil)
  (setq-local flycheck-check-syntax-automatically nil))

;; only run this if rtags is installed
(when (require 'rtags nil :noerror)
  ;; make sure you have company-mode installed
  (require 'company)
  (define-key c-mode-base-map (kbd "M-.")
    (function rtags-find-symbol-at-point))
  (define-key c-mode-base-map (kbd "M-,")
    (function rtags-find-references-at-point))
  ;; disable prelude's use of C-c r, as this is the rtags keyboard prefix
  ;; (define-key prelude-mode-map (kbd "C-c r") nil)
  ;; install standard rtags keybindings. Do M-. on the symbol below to
  ;; jump to definition and see the keybindings.
  (rtags-enable-standard-keybindings)
  ;; comment this out if you don't have or don't use helm
  ;; (setq rtags-use-helm t)
  ;; company completion setup
  (setq rtags-autostart-diagnostics t)
  (rtags-diagnostics)
  (setq rtags-completions-enabled t)
  (push 'company-rtags company-backends)
  (global-company-mode)
  (define-key c-mode-base-map (kbd "<C-tab>") (function company-complete))
  ;; use rtags flycheck mode -- clang warnings shown inline
  (require 'flycheck-rtags)
  ;; c-mode-common-hook is also called by c++-mode
  (add-hook 'c-mode-common-hook #'setup-flycheck-rtags))

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
  ;; ede mode
  ;;(ede-minor-mode 1)
  ;; irony
  ;; (irony-mode)
  ;;
  ;; (ede-cpp-root-project "test_proj" :file "~/uniloc/test/cpp_proj/readme.org" :include-path '("/proj" "/testlib"))
  )
(add-hook 'c-mode-common-hook 'kafka/c-mode-common-hook)


;;; Create (uniloc) projects here.


(provide 'kafka/c-config)
