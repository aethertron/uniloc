(require 'nispio/misc-utils)

(setq-default tab-width 4)
(setq-default c-basic-offset 4)

;; Set up indenting in C/C++
(defvar my-cc-style
  '("linux"
	(c-offsets-alist . ((innamespace . [0])
						(label . c-basic-offset))))
  "A custom indentation style based on the `linux' style")
(c-add-style "my-cc-style" my-cc-style)
(add-to-list 'c-default-style (cons 'other "my-cc-style"))

(setq comint-scroll-to-bottom-on-input t)
(setq compilation-scroll-output 'first-error)
;(setq-default comint-move-point-for-output 'others)
(setq-default comint-move-point-for-output nil)

;; Set up C-mode specific keybindings
(defun nispio/c-mode-keys-hook ()
  (local-set-key (kbd "M-.") 'helm-gtags-dwim)
  (local-set-key (kbd "<M-return>") 'nispio/c-insert-braces)
  (local-set-key (kbd "C-c i") 'nispio/insert-include-guards)
  (local-set-key (kbd "C-c C-c") 'nispio/compile-c)
  (local-set-key (kbd "<S-f5>") 'nispio/run-debugger))
(add-hook 'c-mode-common-hook 'nispio/c-mode-keys-hook)

;; Shortcut for opening and closing braces in c-mode
(defun nispio/c-insert-braces (&optional start end)
  (interactive "r")
  (let ((marker (point-marker))
        text)
    (when (use-region-p)
      (setq text (buffer-substring-no-properties start end))
      (delete-region start end))
    (insert (mapconcat 'identity `("{" ,text "}") "\n"))
    (c-indent-region marker (point) 'quiet)
    (goto-char marker)
    (forward-line 1)
    (c-indent-line)))


;; Insert include guards at the top and bottom of a file
(defun nispio/insert-include-guards (&optional arg)
  (interactive)
  (let* ((src-file (file-name-nondirectory buffer-file-name))
		 (file-parts (split-string src-file "[.-]"))
		 (include-guard (mapconcat 'upcase `("" ,@file-parts "") "_")))
	(setq include-guard (read-string "Include guard: " include-guard))
	(save-excursion
	  (save-restriction
		(widen)
		(goto-char (point-min))
        (insert-before-markers "#ifndef " include-guard
                               "\n#define " include-guard "\n\n")
		(goto-char (point-max))
        (insert "\n#endif // " include-guard "\n")))))

;; Make C mode use C++-style commenting
(add-hook 'c-mode-hook (lambda () (setq comment-start "// " comment-end  "")))

;; Configure GDB for debugging
(setq gdb-show-main t)
;;(setq gdb-many-windows t)
(put 'debug-command 'safe-local-variable 'stringp)

;; Call the compiler and save the compile command when in C
(defun nispio/compile-c (&optional arg)
  (interactive "P")
  (when arg (makunbound 'compile-command))
  (unless (boundp 'compile-command)
    (let* ((src-file (file-name-nondirectory buffer-file-name))
           (src-ext (file-name-extension src-file))
           (src-base (file-name-base src-file))
           (src-compiler (if (string= src-ext "cpp") "g++" "gcc"))
           (my-guess (concat src-compiler " -g3 -ggdb -o " src-base " " src-file)))
      (setq-local compile-command (read-string "Compile command: " my-guess))
      (when (y-or-n-p "Save file-local variable compile-command?")
        (add-file-local-variable 'compile-command compile-command))))
  (compile compile-command t))

;; Run the debugger and save the debug command when in C
(defun nispio/run-debugger (&optional arg)
  (interactive "P")
  (when arg (makunbound 'debug-command))
  (unless (boundp 'debug-command)
    (let* ((src-base (file-name-base buffer-file-name))
           (my-guess (concat "gdb -i=mi " src-base)))
      (setq-local debug-command (read-string "Run gdb (like this): " my-guess))
      (when (y-or-n-p "Save file-local variable debug-command?")
        (add-file-local-variable 'debug-command debug-command))))
  (unless (window-resizable-p nil 1)
	(split-window-below))
  (gdb debug-command)
  (with-current-buffer gud-comint-buffer
	(nispio/set-window-size nil 12)
	(set-window-dedicated-p nil t)
	(when (display-graphic-p)
	  (tool-bar-mode 1)
	  (add-hook 'kill-buffer-hook (lambda () (tool-bar-mode -1)) t t)))
  (add-hook 'kill-buffer-hook 'nispio/delete-window-maybe t t))

(defun nispio/stop-debugging ()
  (interactive)
  (let* ((buffer (get-buffer gud-comint-buffer))
		 (proc (and buffer (get-buffer-process buffer))))
	(when (and proc (process-live-p proc))
	  (message "Killing GUD comint buffer process...")
	  (kill-process proc)
	  (while (process-live-p proc) nil)
	  (message "Exit debugger"))
	(kill-buffer buffer)))

;; Run debugger in another (maximized) frame
(defun nispio/debug-other-frame ()
  (interactive)
  (select-frame (make-frame))
  (setq nispio/fullscreen-p t)
  (nispio/maximize-frame)
  (nispio/run-debugger))

;; Set a Watch Expression in the debugger
(defun nispio/gud-watch-expression (&optional arg)
  (interactive "P")
  (if arg
      (call-interactively gud-watch)
    (gud-watch '(4))))

(defun nispio/set-clear-breakpoint (&optional arg)
  "Set/clear breakpoint on current line"
  (interactive "P")
  (if (or (buffer-file-name) (derived-mode-p 'gdb-disassembly-mode))
      (if (eq (car (fringe-bitmaps-at-pos (point))) 'breakpoint)
          (gud-remove nil)
        (gud-break nil))))

(defun nispio/toggle-breakpoint (&optional arg)
  "Enable/disable breakpoint on current line"
  (interactive "P")
  (save-excursion
    (forward-line 0)
    (dolist (overlay (overlays-in (point) (point)))
      (when (overlay-get overlay 'put-break)
        (setq obj (overlay-get overlay 'before-string))))
    (when (and (boundp 'obj) (stringp obj))
      (gud-basic-call
       (concat
        (if (get-text-property 0 'gdb-enabled obj)
            "-break-disable "
          "-break-enable ")
        (get-text-property 0 'gdb-bptno obj))))))

(defun nispio/clear-all-breakpoints (&optional arg)
  "Clear all breakpoints"
  (interactive "P")
  (gud-basic-call "delete breakpoints"))

(defun nispio/enable-breakpoints (&optional arg)
  "Enable/Disable all breakpoints at once"
  (interactive "P")
  (gud-basic-call "enable breakpoints"))

(defun nispio/disable-breakpoints (&optional arg)
  "Enable/Disable all breakpoints at once"
  (interactive "P")
  (gud-basic-call "disable breakpoints"))

(defun nispio/mouse-toggle-breakpoint (event)
  "Set/clear breakpoint in left fringe/margin at mouse click.
If not in a source or disassembly buffer just set point."
  (interactive "e")
  (mouse-minibuffer-check event)
  (let ((posn (event-end event)))
    (with-selected-window (posn-window posn)
      (if (or (buffer-file-name) (derived-mode-p 'gdb-disassembly-mode))
      (if (numberp (posn-point posn))
          (save-excursion
        (goto-char (posn-point posn))
        (if (eq (car (fringe-bitmaps-at-pos (posn-point posn)))
                'breakpoint)
            (gud-remove nil)
          (gud-break nil)))))
      (posn-set-point posn))))

(defun nispio/attach (pid)
  "Attach gdb to a running process"
  (interactive "nAttach to process id: ")
  (comint-send-string gud-comint-buffer (format "attach %d\n" pid))
  (sit-for 3)
  (gud-cont nil))

;; Set up GUD specific keybindings
(defun nispio/gdb-mode-keys-hook ()
  ;; Mouse Actions
  (define-key gud-minor-mode-map [left-margin mouse-1] 'nispio/mouse-toggle-breakpoint)
  (define-key gud-minor-mode-map [double-mouse-1] 'gud-until)
  (define-key gud-minor-mode-map [mouse-3] 'mouse-set-point)
  (define-key gud-minor-mode-map [double-mouse-3] 'gud-print)
  (define-key gud-minor-mode-map [mouse-2] 'gud-watch)
  ;; Keyboard Actions
  (define-key gud-minor-mode-map [f5] 'gud-cont) ; "Continue"
  (define-key gud-minor-mode-map [f6] 'gud-watch)
  (define-key gud-minor-mode-map [S-f6] 'gud-until)
  (define-key gud-minor-mode-map [S-f5] 'nispio/stop-debugging) ; "Stop Debugging"
  (define-key gud-minor-mode-map [C-S-f5] 'gud-run) ; "Restart""
  (define-key gud-minor-mode-map [f8] 'nispio/enable-breakpoints) ; "Toggle Breakpoint"
  (define-key gud-minor-mode-map [S-f8] 'nispio/disable-breakpoints) ; "Toggle Breakpoint"
  (define-key gud-minor-mode-map [f9] 'nispio/set-clear-breakpoint) ; "Toggle Breakpoint"
  (define-key gud-minor-mode-map [C-f9] 'nispio/toggle-breakpoint) ; "Disable/Enable Breakpoint"
  (define-key gud-minor-mode-map [C-S-f9] 'nispio/clear-all-breakpoints) ; "Delete all Breakpoints"
  (define-key gud-minor-mode-map [S-f9] 'nispio/gud-watch-expression) ; "Quick Watch"
  (define-key gud-minor-mode-map [f10] 'gud-next) ; "Step over"
  (define-key gud-minor-mode-map [S-f10] 'gud-stepi)
  (define-key gud-minor-mode-map [f11] 'gud-step) ; "Step into""
  (define-key gud-minor-mode-map [S-f11] 'gud-finish)) ; "Step out of"
;; gud-jump       ; Set execution address to current line
;; gud-refresh    ; Fix up a possibly garbled display, and redraw the arrow
;; gud-tbreak     ; Set temporary breakpoint at current line
(add-hook 'gdb-mode-hook 'nispio/gdb-mode-keys-hook)



(defun nispio/setup-gud-toolbar ()
  ;; Modify existing buttons in the GUD toolbar
  (let ((menu gud-tool-bar-map))
	(dolist (x '((go :visible nil)
				 (cont :visible t)
				 (cont :help "Continue (gud-cont)" )
				 (next menu-item "Step Over")
				 (next :help "Step Over (gud-next)")
				 (step menu-item "Step Into")
				 (step :help "Step Into (gud-step)")
				 (finish :help "Step Out (gud-finish)")
				 (finish menu-item "Step Out")
				 (finish :vert-only nil)
				 (up :vert-only t)
				 (down :vert-only t))
			   gud-tool-bar-map)
	  (nispio/menu-item-property menu (car x) (cadr x) (caddr x)))

	;; Add Attach to Process button to GUD toolbar
	(define-key-after menu [attach]
	  '(menu-item "Attach" nispio/attach
				  :help "Attach To Running Process"
				  :enable (not gud-running)
				  :image (image :type xpm :file "attach.xpm")
				  :vert-only t)
	  'watch)

	;; Add Stop Debugging button to GUD toolbar
	(define-key-after menu [exit]
	  '(menu-item "Quit Debugging" nispio/stop-debugging
				  :help (let ((key (where-is-internal 'nispio/stop-debugging nil t)))
						  (format "Exit GUD %s" (key-description key)))
				  :image (image :type xpm :file "exit.xpm")
				  :vert-only t))))

(add-hook 'gdb-mode-hook 'nispio/setup-gud-toolbar)




;; Set up hotkeys for transitioning between windows in gdb
;; (source: http://markshroyer.com/2012/11/emacs-gdb-keyboard-navigation/)
(defun gdb-comint-buffer-name ()
  (buffer-name gud-comint-buffer))
(defun gdb-source-buffer-name ()
  (buffer-name (window-buffer gdb-source-window)))

(defun gdb-select-window (header)
  "Switch directly to the specified GDB window.
Moves the cursor to the requested window, switching between
`gdb-many-windows' \"tabs\" if necessary in order to get there.

Recognized window header names are: 'comint, 'locals, 'registers,
'stack, 'breakpoints, 'threads, and 'source."

  (interactive "Sheader: ")

  (let* ((header-alternate (case header
                             ('locals      'registers)
                             ('registers   'locals)
                             ('breakpoints 'threads)
                             ('threads     'breakpoints)))
         (buffer (intern (concat "gdb-" (symbol-name header) "-buffer")))
         (buffer-names (mapcar (lambda (header)
                                 (funcall (intern (concat "gdb-"
                                                          (symbol-name header)
                                                          "-buffer-name"))))
                               (if (null header-alternate)
                                   (list header)
                                 (list header header-alternate))))
         (window (if (eql header 'source)
                     gdb-source-window
                   (or (get-buffer-window (car buffer-names))
                       (when (not (null (cadr buffer-names)))
                         (get-buffer-window (cadr buffer-names)))))))

    (when (not (null window))
      (let ((was-dedicated (window-dedicated-p window)))
        (select-window window)
        (set-window-dedicated-p window nil)
        (when (member header '(locals registers breakpoints threads))
          (switch-to-buffer (gdb-get-buffer-create buffer))
          (setq header-line-format (gdb-set-header buffer)))
        (set-window-dedicated-p window was-dedicated))
      t)))

(defvar nispio/gdb-window-map (make-sparse-keymap)
  "Keymap for selecting GDB windows")

;; Use global keybindings for the window selection functions so that they
;; work from the source window too...
(let ((map nispio/gdb-window-map))
  (mapcar (lambda (el)
            (let ((key    (car el))
                  (header (cdr el)))
              (define-key map (read-kbd-macro key) #'(lambda ()
                                                       (interactive)
                                                       (gdb-select-window header)))))
          '(("c" . comint)
            ("l" . locals)
            ("r" . registers)
            ("u" . source)
            ("s" . stack)
            ("b" . breakpoints)
            ("t" . threads))))



(require 'semantic)
(require 'semantic/ia)
(require 'semantic/bovine/gcc)
(global-semanticdb-minor-mode 1)
(global-semantic-idle-scheduler-mode 1)
(global-semantic-stickyfunc-mode 1)
(global-semantic-highlight-func-mode 1)
(semantic-mode 1)

(defun my-semantic-hook ()
  (imenu-add-to-menubar "TAGS"))
(add-hook 'semantic-init-hooks 'my-semantic-hook)

(defun disable-semantic-idle-summary-mode ()
  (semantic-idle-summary-mode 0))
(add-hook 'semantic-mode-hook 'disable-semantic-idle-summary-mode)

(semantic-add-system-include
 (substitute-in-file-name "$XMDISK/xm/inc")
 'c++-mode)
(semantic-add-system-include
 (substitute-in-file-name "$XMDISK/xm/include")
 'c++-mode)

(require 'ede)
(global-ede-mode t)

(nispio/after 'ede
  ;; File containing local project roots on this machine
  (with-demoted-errors "Error loading local projects: %s"
    (let ((file "~/.emacs.d/local-projects.el"))
      (when (file-exists-p file)
        (load-file file)))))

  ;; ;; Create a project for xmidas
  ;; (ede-cpp-root-project "xmidas"
  ;;                       :name "xmidas"
  ;;                       :file (substitute-in-file-name "$XMDISK/xm/version.txt")
  ;;                       :include-path '("/inc"
  ;;                                       "/include"
  ;;                                       "/include/midas"
  ;;                                       )
  ;;                       :targets 'nil
  ;;                       :spp-table '(("__cplusplus" . 1))
  ;;                       )

(defun nispio/semantic-ia-fast-jump (point)
  "Modification of semantic-ia-fast-jump to use push-mark"
  (interactive "d")
  (let* ((ctxt (semantic-analyze-current-context point))
	 (pf (and ctxt (reverse (oref ctxt prefix))))
	 (first (car pf)) (second (nth 1 pf)))
    (cond
     ((semantic-tag-p first)
	  (push-mark)
      (when (fboundp 'push-tag-mark) (push-tag-mark))
      (semantic-ia--fast-jump-helper first))
     ((semantic-tag-p second)
	  (push-mark)
      (when (fboundp 'push-tag-mark) (push-tag-mark))
      (let ((secondclass (car (reverse (oref ctxt prefixtypes)))))
	(cond
	 ((and (semantic-tag-with-position-p secondclass)
	       (y-or-n-p (format "Could not find `%s'.  Jump to %s? "
							 first (semantic-tag-name secondclass))))
	  (semantic-ia--fast-jump-helper secondclass))
	 ((and (semantic-tag-p second)
	       (y-or-n-p (format "Could not find `%s'.  Jump to %s? "
				 first (semantic-tag-name second))))
	  (semantic-ia--fast-jump-helper second)))))
     ((semantic-tag-of-class-p (semantic-current-tag) 'include)
      (require 'semantic/decorate/include)
	  (push-mark)
      (when (fboundp 'push-tag-mark) (push-tag-mark))
      (semantic-decoration-include-visit))
     (t (error "Could not find suitable jump point for %s" first)))))

(define-key my-map (kbd "H-j") 'nispio/semantic-ia-fast-jump)



(autoload 'doxymacs-mode "doxymacs")
;(add-hook 'c-mode-common-hook 'doxymacs-mode)



;; Python code checking via flymake and pylint
(setq nispio/pylint-name "epylint.py")
(when (load "flymake" t)
  (defun nispio/flymake-python-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list nispio/pylint-name (list local-file))))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" nispio/flymake-python-init)))

(add-hook 'python-mode-hook 'flymake-mode-on)

(defun nispio/set-python-keys ()
  (local-set-key [remap fill-paragraph] 'python-fill-paragraph))
(add-hook 'python-mode-hook 'nispio/set-python-keys)



;; flymake rules for C++ header files
(defun nispio/flymake-header-init ()
  (flymake-master-make-init
   'flymake-get-include-dirs
   '("\\.\\(?:c\\(?:c\\|pp\\|xx\\|\\+\\+\\)?\\|CC\\)\\'")
   "[ \t]*#[ \t]*include[ \t]*\"\\([[:word:]0-9/\\_.]*%s\\)\""))

(add-to-list 'flymake-allowed-file-name-masks
			 '("\\.h\\(h\\|pp\\)?\\'"
			   nispio/flymake-header-init
			   flymake-master-cleanup))

(add-to-list 'flymake-allowed-file-name-masks
			 '("\\.\\(?:c\\(?:c\\|pp\\|xx\\|\\+\\+\\)?\\)\\'"
			   flymake-simple-make-init))




;; Add keybindings to jump between errors in flymake
(defun nispio/add-flymake-keys ()
  (local-set-key (kbd "M-n") 'flymake-goto-next-error)
  (local-set-key (kbd "M-p") 'flymake-goto-prev-error))
(add-hook 'flymake-mode-hook 'nispio/add-flymake-keys)

;; ;; Disable the window that 'pops' when flymake can't be enabled.
(setq flymake-gui-warnings-enabled nil)

;; ;; Activate flymake by default
;; (add-hook 'find-file-hook 'flymake-mode-on)

;; Do logging of errors for flymake
(setq flymake-log-level 0)



(provide 'nispio/dev-utils)
