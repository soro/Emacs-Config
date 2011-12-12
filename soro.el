(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

(server-start)

;; window and session management
(require 'workgroups)
(workgroups-mode 't)
(setq wg-prefix-key (kbd "C-c w"))
(desktop-save-mode 't)

;; load zenburn with check set to false
(load-theme 'zenburn 't)

;; load textmate-mode for peepopen
(textmate-mode)
