(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

;; always install default packages if they aren't present
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar default-packages '(starter-kit
                           starter-kit-lisp
                           starter-kit-bindings
                           starter-kit-eshell
                           magit
                           paredit
                           smex
                           ido-ubiquitous
                           idle-highlight-mode
                           workgroups
                           yasnippet
                           undo-tree
                           slime
                           scala-mode
                           http-twiddle
                           bookmark+
                           auctex))

(dolist (pac default-packages)
  (when (not (package-installed-p pac))
    (package-install pac)))


;; window and session management
(require 'workgroups)
(workgroups-mode 't)
(setq wg-prefix-key (kbd "C-c w"))
(desktop-save-mode 't)

;; haskell support
(load "~/.emacs.d/vendor/haskell-mode/haskell-site-file")

;; racket support
(load-file "~/.emacs.d/vendor/geiser/elisp/geiser.el")
(setq geiser-active-implementations '(racket))

;; load zenburn with check set to false
(load-theme 'zenburn 't)

;; load textmate-mode for peepopen
(textmate-mode)

;; A quick & ugly PATH solution for Emacs on Mac OSX
(when (string-equal "darwin" (symbol-name system-type))
  (setenv "PATH" (concat "/Users/soro/.cabal/bin:/usr/local/homebrew/bin:/Applications/Racket/bin:" (getenv "PATH")))
  (setq exec-path (append exec-path '("/Users/soro/.cabal/bin" "/usr/local/homebrew/bin" "/Applications/Racket/bin"))))

;; proof general and Coq
(load-file "~/.emacs.d/vendor/ProofGeneral/generic/proof-site.el")
(setq auto-mode-alist (cons '("\.v$" . coq-mode) auto-mode-alist))
(autoload 'coq-mode "coq" "Major mode for editing Coq vernacular." t)

(setq slime-net-coding-system 'utf-8-unix)

;; set up agda mode
(load-file (let ((coding-system-for-read 'utf-8))
             (shell-command-to-string "agda-mode locate")))

(server-start)
