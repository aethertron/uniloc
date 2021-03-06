;;; package --- Summary
;;; Commentary:
;;; Code:
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(buffer-move-behavior (quote move))
 '(comint-prompt-read-only nil)
 '(company-backends
   (quote
    (company-web-slim company-web-jade company-web-html company-bbdb company-nxml company-css company-eclim company-irony company-semantic company-clang company-xcode company-cmake company-capf company-files
		      (company-dabbrev-code company-gtags company-etags company-keywords)
		      company-oddmuse company-dabbrev)))
 '(company-idle-delay 0.3)
 '(company-minimum-prefix-length 2)
 '(default-frame-alist (quote ((font . "DejaVu Sans Mono-10.5"))))
 '(dired-auto-revert-buffer t)
 '(dired-guess-shell-alist-user (quote (("\\.pdf\\'" "evince"))))
 '(dired-hide-details-hide-information-lines t)
 '(dired-listing-switches "-alh --group-directories-first")
 '(dired-omit-files "^\\.?#\\|^\\.$\\|^\\.\\.$\\|^\\..*$")
 '(display-time-24hr-format t)
 '(display-time-day-and-date t)
 '(flycheck-display-errors-delay 0.2)
 '(flycheck-pos-tip-mode t)
 '(helm-ag-base-command "ag --nocolor --nogroup --smart-case")
 '(helm-boring-buffer-regexp-list
   (quote
    ("\\` " "\\*helm" "\\*helm-mode" "\\*Echo Area" "\\*Minibuf" "\\*.*\\*")))
 '(helm-mini-default-sources
   (quote
    (helm-source-buffers-list helm-source-bookmarks helm-source-recentf helm-source-buffer-not-found)))
 '(helm-split-window-default-side (quote right))
 '(ido-auto-merge-work-directories-length -1)
 '(ido-use-virtual-buffers (quote auto))
 '(magit-log-arguments
   (quote
    ("--graph" "--color" "--decorate" "--patch" "-n256")))
 '(markdown-coding-system nil)
 '(markdown-command "markdown-it")
 '(menu-bar-mode nil)
 '(org-M-RET-may-split-line nil)
 '(org-agenda-custom-commands
   (quote
    (("n" "Agenda and all TODO's"
      ((agenda "" nil)
       (alltodo "" nil))
      nil)
     ("p" "Primary: Agenda and Autotimers"
      ((agenda "" nil)
       (tags "AUTOTIMER:daily:" nil))
      nil nil)
     ("x" "Export agenda" agenda "" nil
      ("~/Dropbox/todo/agenda.txt" "~/Dropbox/todo/agenda.html")))))
 '(org-agenda-dim-blocked-tasks nil)
 '(org-agenda-files "~/.emacs.d/site-lisp/org-agenda-files")
 '(org-agenda-skip-deadline-if-done nil)
 '(org-agenda-skip-scheduled-if-done nil)
 '(org-agenda-skip-timestamp-if-done nil)
 '(org-agenda-span (quote day))
 '(org-agenda-start-on-weekday nil)
 '(org-agenda-start-with-follow-mode nil)
 '(org-archive-reversed-order t)
 '(org-babel-load-languages
   (quote
    ((python . t)
     (emacs-lisp . t)
     (js . t)
     (sh . t)
     (org . t)
     (sqlite . t)
     (ditaa . t)
     (plantuml . t)
     (dot . t))))
 '(org-capture-after-finalize-hook nil)
 '(org-capture-templates
   (quote
    (("g" "gym set" entry
      (clock)
      "set %U")
     ("c" "feed cats" table-line
      (file+olp "~/kafkanet/org/cats.org" "Assorted Care" "Feed Cats Twice Daily")
      "|%U|1/2|3/4|no|1|1/2|no|standard|separated | " :table-line-pos "I+1")
     ("w" "weight" table-line
      (file+headline "~/kafkanet/org/body.org" "Weight")
      "|#|%U|%^{weight}| " :table-line-pos "I+1"))))
 '(org-catch-invisible-edits (quote show))
 '(org-clock-clocked-in-display (quote both))
 '(org-clock-in-switch-to-state nil)
 '(org-clock-into-drawer nil)
 '(org-clock-mode-line-total (quote current))
 '(org-clock-out-switch-to-state nil)
 '(org-clock-report-include-clocking-task t)
 '(org-clocktable-defaults
   (quote
    (:maxlevel 2 :lang "en" :scope file :block nil :wstart 1 :mstart 1 :tstart nil :tend nil :step nil :stepskip0 t :fileskip0 t :tags nil :emphasize nil :link nil :narrow 40! :indent t :formula nil :timestamp nil :level nil :tcolumns nil :formatter nil)))
 '(org-columns-skip-archived-trees nil)
 '(org-completion-use-ido t)
 '(org-confirm-babel-evaluate nil)
 '(org-disputed-keys
   (quote
    (([(shift up)]
      .
      [(meta shift p)])
     ([(shift down)]
      .
      [(meta shift n)])
     ([(shift left)]
      .
      [(meta \[)])
     ([(shift right)]
      .
      [(meta \])])
     ([(control shift right)]
      .
      [(meta control \[)])
     ([(control shift left)]
      .
      [(meta control \])]))))
 '(org-enforce-todo-checkbox-dependencies t)
 '(org-enforce-todo-dependencies t)
 '(org-export-backends (quote (ascii html icalendar latex md odt)))
 '(org-file-apps
   (quote
    ((auto-mode . emacs)
     ("\\.mm\\'" . default)
     ("\\.x?html?\\'" . default)
     ("\\.pdf\\'" . "evince %s"))))
 '(org-goto-max-level 5)
 '(org-habit-following-days 2)
 '(org-habit-show-all-today nil)
 '(org-habit-show-habits-only-for-today nil)
 '(org-icalendar-alarm-time 30)
 '(org-icalendar-combined-agenda-file "~/Dropbox/todo/agenda.ics")
 '(org-icalendar-include-todo t)
 '(org-icalendar-store-UID t)
 '(org-insert-heading-respect-content t)
 '(org-list-demote-modify-bullet (quote (("-" . "+") ("+" . "1.") ("1." . "1)"))))
 '(org-log-into-drawer t)
 '(org-modules
   (quote
    (org-bbdb org-bibtex org-docview org-gnus org-habit org-info org-irc org-mhe org-rmail org-w3m)))
 '(org-refile-targets (quote ((org-agenda-files :maxlevel . 3))))
 '(org-replace-disputed-keys t)
 '(org-return-follows-link t)
 '(org-reverse-note-order t)
 '(org-sparse-tree-open-archived-trees nil)
 '(org-special-ctrl-a/e t)
 '(org-startup-align-all-tables t)
 '(org-time-clocksum-use-fractional t)
 '(org-todo-keywords
   (quote
    ((sequence "TODO(t!)" "STARTED(s!)" "BLOCKED(b@/!)" "DOING(d)" "PAUSE(p)" "|" "DONE(o!)" "CANCEL(x@)"))))
 '(org-treat-insert-todo-heading-as-state-change t)
 '(package-selected-packages
   (quote
    (elpakit flycheck-rtags rtags projectile ac-html-bootstrap company-web web-mode counsel htmlize company-irony irony irony-eldoc move-text latex-extra latex-pretty-symbols latex-preview-pane latex-unicode-math-mode auctex markdown-mode markdown-mode+ markdown-preview-eww markdown-preview-mode helm-company minesweeper flycheck-pos-tip flycheck-tip eclim company-mode anaconda-mode elpy ws-butler page-break-lines avy helm json-mode flycheck dired+ undo-tree zygospore which-key use-package spotify smex multiple-cursors monky magit helm-swoop helm-descbinds helm-ag gnuplot-mode gnuplot geeknote dumb-jump discover-my-major discover buffer-move ace-link)))
 '(revert-without-query (quote (".*")))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-scrollbar-bg ((t (:background "grey14"))))
 '(company-scrollbar-fg ((t (:background "white smoke"))))
 '(company-tooltip ((t (:background "gray" :foreground "black"))))
 '(font-lock-comment-delimiter-face ((t (:foreground "chartreuse"))))
 '(font-lock-comment-face ((t (:foreground "salmon")))))
