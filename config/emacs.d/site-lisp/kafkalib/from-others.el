;; from JPM

;; Received [2017-03-24 Fri]
(defun jpm/highlight-indentation ()
  "Highlights indentation levels."
  (interactive)
  (let ((indentation (cond ((eq major-mode 'python-mode)
                            (if (boundp 'python-indent)
                                python-indent default-indentation))
                           ((eq major-mode 'c-mode)
                            (if (boundp 'c-basic-offset)
                                c-basic-offset default-indentation))
                           ((eq major-mode 'c++-mode)
                            (if (boundp 'c-basic-offset)
                                c-basic-offset default-indentation))
                           (default-indentation))))
    (font-lock-add-keywords nil `((,(format "\\( \\) \\{%s\\}" (- indentation 1)) 1 'fringe)))))
