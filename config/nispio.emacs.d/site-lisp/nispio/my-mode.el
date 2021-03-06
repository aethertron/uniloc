(require 'easy-mmode)
(require 'nispio/key-utils)

(defvar my-map (make-sparse-keymap)
  "Keymap for my personal key bindings")

(define-minor-mode my-mode
  "A minor mode which provides my personal key bindings."
  nil " MY" my-map)

(defun my-mode-maybe ()
  "Enable minor my-mode in the current buffer, unless in minibuffer"
  (if (not (minibufferp (current-buffer)))
      (my-mode 1)))

(define-global-minor-mode my-global-mode my-mode my-mode-maybe)

(defun enable-my-global-mode ()
  "Command to enable my-global-mode"
  (interactive)
  (my-global-mode 1)
  (setq-default my-mode 1)
  (message "my-global-mode enabled"))

(defun disable-my-global-mode ()
  "Command to disable my-global-mode"
  (interactive)
  (my-global-mode -1)
  (setq-default my-mode nil)
  (message "my-global-mode disabled"))

(global-set-key (kbd "<C-m>")
 (defun meta-return (&optional arg)

   (interactive "p")
   (execute-kbd-macro [M-return]) arg))

(defun nispio/fake-M-RET ()
  "Simulating pressing M-RET"
  (interactive)
  (let ((command (key-binding [M-return])))
    (setq last-command-event [M-return])
    (setq this-command command)
    (call-interactively command)))

;; If not in a TTY, Unbind C-m, C-i, and C-[ so we can use them elsewhere
(if (not (display-graphic-p))
    (setq tty-keys t)
  (define-key input-decode-map [?\C-m] [C-m])
  (define-key input-decode-map [?\C-i] [C-i])
  (define-key input-decode-map [?\C-\[] [C-\[])
  (define-key local-function-key-map [C-m] [?\C-m])
  (define-key local-function-key-map [C-i] [?\C-i])
  (define-key local-function-key-map [C-\[] [?\C-\[])
  (setq tty-keys nil))

;; Turn C-] into a sticky "hyper" modifier
(define-key local-function-key-map [?\C-\]] 'event-apply-hyper-modifier)
(define-key global-map [?\C-\]] nil)

;; Set up basic keybindings
(define-key my-map (kbd "<pause>") 'disable-my-global-mode)
(define-key my-map (kbd "M-0") 'delete-window)
(define-key my-map (kbd "M-1") 'delete-other-windows)
(define-key my-map (kbd "<M-tab>") 'next-multiframe-window)
(define-key my-map (kbd "<M-iso-lefttab>") 'previous-multiframe-window)
(define-key my-map (kbd "<C-tab>") 'next-multiframe-window)
(define-key my-map (kbd "<C-iso-lefttab>") 'previous-multiframe-window)
(define-key my-map (kbd "C-x <f1>") 'nispio/buffer-file-name)
;(define-key my-map (kbd "<f11>") 'nispio/toggle-fullscreen)
(define-key my-map (kbd "C-j") 'newline-and-indent)
;(define-key my-map (kbd "<C-m>") 'nispio/fake-M-RET)
(define-key my-map [remap list-buffers] 'ibuffer)
(define-key my-map (kbd "<menu>") 'menu-bar-open)
(define-key my-map (kbd "C-H-]") 'abort-recursive-edit)
(define-key my-map (kbd "H-e") 'nispio/eval-and-replace)
(define-key my-map (kbd "C-h o") 'describe-face)

(provide 'nispio/my-mode)
