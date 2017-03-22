

(defun kafkabro/dired-mode-hook ()
  (hl-line-mode)
  (dired-omit-mode))

(add-hook 'dired-mode-hook 'kafkabro/dired-mode-hook)

(provide 'kafkabro/dired)
