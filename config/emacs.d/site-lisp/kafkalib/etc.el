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
  "Launches a shell with a unique name.  ARG: shell type."
  (interactive "P")
  (shell (concat  (substring (pwd) 10))))


(defun kafkalib/copy-buffer-filename ()
  "Copies current buffer filename into kill ring."
  (interactive)
  (if buffer-file-name (progn (kill-new buffer-file-name)
			      (message "Copied \"%s\" to kill ring." buffer-file-name))))


(provide 'kafkalib/etc)
;;; etc.el ends here
