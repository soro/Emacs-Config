(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; always install default packages if they aren't present
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar default-packages '(starter-kit
                           starter-kit-lisp
                           starter-kit-bindings
                           starter-kit-eshell
                           magit
                           magithub
                           gist
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
(load-theme 'solarized-dark 't)

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

;; load mark multiple
(add-to-list 'load-path "~/.emacs.d/vendor/mark-multiple/")
(require 'inline-string-rectangle)
(global-set-key (kbd "C-x r t") 'inline-string-rectangle)

(require 'mark-more-like-this)
(global-set-key (kbd "C-<") 'mark-previous-like-this)
(global-set-key (kbd "C->") 'mark-next-like-this)
(global-set-key (kbd "C-M-m") 'mark-more-like-this)

;; load expand region
(add-to-list 'load-path "~/.emacs.d/vendor/expand-region/")
(require 'expand-region)
(global-set-key (kbd "C-@") 'er/expand-region)

;; load ensime
(add-to-list 'load-path "~/.emacs.d/vendor/ensime/elisp/")
(require 'ensime)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

;; set up abbrevs for unicode symbols
(define-abbrev-table 'global-abbrev-table '(
    ("alpha" "α" nil 0)
    ("beta" "β" nil 0)
    ("gamma" "γ" nil 0)
    ("theta" "θ" nil 0)
    ("inf" "∞" nil 0)
    ("|@|" " ⊛" nil 0)
    ("forever" "∞" nil 0)
    ("jjoin" "μ" nil 0)
    ("cojoin" "υ" nil 0)
    ("copure" "ε" nil 0)
    ("comap" "∙" nil 0)
    ("mmap" "∘" nil 0)
    ("ppure" "η" nil 0)
    ("kleisli" "☆" nil 0)
    ("cokleisli" "★" nil 0)
    ("dual" "σ" nil 0)
    ("equal" "≟" nil 0)
    ("notequal" "≠" nil 0)
    ("sum" "∑" nil 0)
    ("aany" "∃" nil 0)
    ("aall" "∀" nil 0)
    ("ttraverse" "↦" nil 0)
    ("ar1" "→" nil 0)
    ("ar2" "⇒" nil 0)
    ("ppure" "η" nil 0)
    ))
;; ===========

;; emulate vims *
(require 'thingatpt)

(defun my-isearch-yank-word-or-char-from-beginning ()
  "Move to beginning of word before yanking word in isearch-mode."
  (interactive)
  ;; Making this work after a search string is entered by user
  ;; is too hard to do, so work only when search string is empty.
  (if (= 0 (length isearch-string))
      (beginning-of-thing 'word))
  (isearch-yank-word-or-char)
  ;; Revert to 'isearch-yank-word-or-char for subsequent calls
  (substitute-key-definition 'my-isearch-yank-word-or-char-from-beginning 
			     'isearch-yank-word-or-char
			     isearch-mode-map))

(add-hook 'isearch-mode-hook
 (lambda ()
   "Activate my customized Isearch word yank command."
   (substitute-key-definition 'isearch-yank-word-or-char 
			      'my-isearch-yank-word-or-char-from-beginning
			      isearch-mode-map)))
;; =============

(server-start)
