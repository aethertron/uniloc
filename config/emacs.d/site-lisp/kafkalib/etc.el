;;; package --- Summary
;;; Commentary:
;;; Code:
(require 'org)



;;; utilities, buffer related
(defun kafkalib/org-insert-current-time-stamp (ts_mode)
  "Insert org formatted time-stamp with current time, add prefix arg for active. TS_MODE is time stamp mode."
  (interactive "p")
  (if (= ts_mode 1)  (org-insert-time-stamp (current-time) "t" 1)
    (if (= ts_mode 4) (insert (format-time-string "%Y-%m-%d"))
      (insert (substring (format-time-string (org-time-stamp-format 1 1)) 1 -1)))))


(defun kafkalib/launch-shell (arg)
  (interactive "p")
  (if (= arg 1) (shell (let ((elems (split-string (helm-current-directory) "/" t)))
			 (concat (-last-item elems) " (/"
				 (s-join "/" (-slice elems 0 (- (length elems) 1))) "/)")))
    (if (= arg 4) (shell (read-string "shell buffer name: ")))))


(defun kafkalib/copy-buffer-filename ()
  "Copies current buffer filename into kill ring."
  (interactive)
  (if buffer-file-name (progn (kill-new buffer-file-name)
			      (message "Copied \"%s\" to kill ring." buffer-file-name))))


;;; editing text

(defun kafkalib/open-next-line (arg)
  "Move to next line and then open line, vi-style. ARG: number of lines"
  (interactive "p")
  (end-of-line)
  (open-line arg)
  (forward-line 1)
  (indent-according-to-mode))


(defun kafkalib/open-prev-line (arg)
  "Move to prev line and then open line, vi-style. ARG: number of lines"
  (interactive "p")
  (beginning-of-line)
  (open-line arg)
  (indent-according-to-mode))


(provide 'kafkalib/etc)
;;; etc.el ends here
