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
                           paredit
                           smex
                           ido-ubiquitous
                           idle-highlight-mode
                           workgroups
                           yasnippet
                           undo-tree
                           slime
                           scala-mode
                           clojure-mode
                           http-twiddle
                           bookmark+
                           auctex
                           magit
                           magithub
                           gist))
;; magit-gh-pulls doesn't work because of a borken dependency on eieio
;; 1.4

;; (dolist (pac default-packages)
;;   (when (not (package-installed-p pac))
;;     (package-install pac)))

(set-default-font "-misc-mensch-medium-r-normal--14-0-0-0-p-0-iso8859-15")

;; setup helm
(add-to-list 'load-path "~/.emacs.d/vendor/helm")
(require 'helm-config)
(helm-mode 1)

;; load magit
(require 'magit)

;; load jira mode
;;(require 'jira)
;;(setq jira-url "https://patchy.onjira.com/secure/Dashboard.jspa")

;; yes, i've given in once again, the seductive powers of evil are just too great
(add-to-list 'load-path "~/.emacs.d/evil")
(require 'evil)
(evil-mode 1)
;; remove all keybindings from insert-state keymap
(setcdr evil-insert-state-map nil) 
;; but [escape] should switch back to normal state
(define-key evil-insert-state-map [escape] 'evil-normal-state)

;; adjust cursor colors
(defun cofi/evil-cursor ()
  "Change cursor color according to evil-state."
  (let ((default "OliveDrab4")
        (cursor-colors '((insert . "dark orange")
                         (emacs  . "sienna")
                         (visual . "white"))))
    (setq cursor-type (if (eq evil-state 'visual)
                          'hollow
                        'bar))
    (set-cursor-color (def-assoc evil-state cursor-colors default))))

;; remove all keybindings from insert-state keymap
(setcdr evil-insert-state-map nil) 
;; but [escape] should switch back to normal state
(define-key evil-insert-state-map [escape] 'evil-normal-state)

;; adjust cursor colors
(defun cofi/evil-cursor ()
  "Change cursor color according to evil-state."
  (let ((default "OliveDrab4")
        (cursor-colors '((insert . "dark orange")
                         (emacs  . "sienna")
                         (visual . "white"))))
    (setq cursor-type (if (eq evil-state 'visual)
                          'hollow
                        'bar))
    (set-cursor-color (def-assoc evil-state cursor-colors default))))

;; make i go into emacs state and esc switch back to normal mode
(define-key evil-emacs-state-map [escape] 'evil-force-normal-state)
(define-key evil-emacs-state-map "\C-o" 'evil-execute-in-normal-state)

(setq evil-default-cursor t)
(add-to-list 'evil-emacs-state-modes 'el-get-package-menu-mode)
(add-to-list 'evil-emacs-state-modes 'magit-log-edit-mode)
(add-to-list 'evil-emacs-state-modes 'org-mode)

;; surround.vim for evil - not quite as nice as paredit but can
;; sometimes be useful
(add-to-list 'load-path "~/.emacs.d/vendor/evil-surround/")
(require 'surround)
(add-hook 'evil-mode-hook (surround-mode 1))

;; rebind command and option on osx
(when (eq system-type 'darwin)
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'hyper))

;; provide a bit more tiling feel to emacs buffers
(global-set-key (kbd "H-j") (lambda () (interactive) (enlarge-window 5)))
(global-set-key (kbd "H-k") (lambda () (interactive) (enlarge-window -5)))
(global-set-key (kbd "H-l") (lambda () (interactive) (enlarge-window -5 t)))
(global-set-key (kbd "H-h") (lambda () (interactive) (enlarge-window 5 t)))

;; set up ack and a half
(add-to-list 'load-path "~/.emacs.d/vendor/ack-and-a-half/")
(autoload 'ack-and-a-half-same "ack-and-a-half" nil t)
(autoload 'ack-and-a-half "ack-and-a-half" nil t)
(autoload 'ack-and-a-half-find-file-same "ack-and-a-half" nil t)
(autoload 'ack-and-a-half-find-file "ack-and-a-half" nil t)
(defalias 'ack 'ack-and-a-half)
(defalias 'ack-same 'ack-and-a-half-same)
(defalias 'ack-find-file 'ack-and-a-half-find-file)
(defalias 'ack-find-file-same 'ack-and-a-half-find-file-same)

;; window and session management
(require 'workgroups)
(workgroups-mode 't)
(setq wg-prefix-key (kbd "C-c w"))
(desktop-save-mode 't)

;; haskell support
(load "~/.emacs.d/vendor/haskell-mode/haskell-site-file")
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)

;; racket support
(load-file "~/.emacs.d/vendor/geiser/elisp/geiser.el")
(setq geiser-active-implementations '(racket))

;; load solarized-dark with no check
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(add-to-list 'custom-theme-load-path "~/.emacs.d/vendor/solarized-theme/")
(add-to-list 'load-path "~/.emacs.d/vendor/solarized-theme/")
(load-theme 'solarized-dark 't)

;; A quick & ugly PATH solution for Emacs on Mac OSX
(when (string-equal "darwin" (symbol-name system-type))
  (setenv "PATH" (concat "/Users/soro/.cabal/bin:/usr/local/homebrew/bin:/Applications/Racket/bin:/usr/local/bin" (getenv "PATH")))
  (setq exec-path (append exec-path '("/Users/soro/.cabal/bin" "/usr/local/homebrew/bin" "/Applications/Racket/bin" "/usr/local/bin"))))

;; load mark multiple
(add-to-list 'load-path "~/.emacs.d/vendor/mark-multiple/")
(require 'inline-string-rectangle)
(global-set-key (kbd "C-x r t") 'inline-string-rectangle)

(require 'mark-more-like-this)
(global-set-key (kbd "C-<") 'mark-previous-like-this)
(global-set-key (kbd "C->") 'mark-next-like-this)
(global-set-key (kbd "C-M-m") 'mark-more-like-this)

;; load iy-go-to-char
(add-to-list 'load-path "~/.emacs.d/vendor/go-to-char/")
(require 'iy-go-to-char)
(global-set-key (kbd "M-n") 'iy-go-to-char)
(global-set-key (kbd "M-N") 'iy-go-to-char-backward)
(global-set-key (kbd "C-c ;") 'iy-go-to-char-continue)
(global-set-key (kbd "C-c ,") 'iy-go-to-char-continue-backward)

;; load expand region
(add-to-list 'load-path "~/.emacs.d/vendor/expand-region/")
(require 'expand-region)
(global-set-key (kbd "C-@") 'er/expand-region)

;; load ensime
(add-to-list 'load-path "~/.emacs.d/vendor/ensime/elisp/")
(require 'ensime)
;;(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

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
    ("zero" "∅" nil 0)
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



(global-set-key (kbd "H-t") (lambda () (interactive) (helm-find-files)))

(defun helm-find-files ()
  (interactive)
  (helm 'helm-c-source-git-project-files))

(defvar helm-c-source-git-project-files-cache nil "(path signature cached-buffer)")
(defvar helm-c-source-git-project-files
  '((name . "Files from Current GIT Project")
    (init . (lambda ()
              (let* ((git-top-dir (magit-get-top-dir (if (buffer-file-name)
                                                         (file-name-directory (buffer-file-name))
                                                       default-directory)))
                     (top-dir (if git-top-dir
                                  (file-truename git-top-dir)
                                default-directory))
                     (default-directory top-dir)
                     (signature (magit-rev-parse "HEAD")))

                (unless (and helm-c-source-git-project-files-cache
                             (third helm-c-source-git-project-files-cache)
                             (equal (first helm-c-source-git-project-files-cache) top-dir)
                             (equal (second helm-c-source-git-project-files-cache) signature))
                  (if (third helm-c-source-git-project-files-cache)
                      (kill-buffer (third helm-c-source-git-project-files-cache)))
                  (setq helm-c-source-git-project-files-cache
                        (list top-dir
                              signature
                              (helm-candidate-buffer 'global)))
                  (with-current-buffer (third helm-c-source-git-project-files-cache)
                    (dolist (filename (mapcar (lambda (file) (concat default-directory file))
                                              (magit-git-lines "ls-files")))
                      (insert filename)
                      (newline))))
                (helm-candidate-buffer (third helm-c-source-git-project-files-cache)))))

    (type . file)
    (candidates-in-buffer)))

(add-hook 'isearch-mode-hook
 (lambda ()
   "Activate my customized Isearch word yank command."
   (substitute-key-definition 'isearch-yank-word-or-char 
			      'my-isearch-yank-word-or-char-from-beginning
			      isearch-mode-map)))
;; =============

;; Growl utilities
(defvar growlnotify (executable-find "growlnotify") "Path to growlnotify")
(defun growl (title message)
  "Display notification with title and message"
  (flet ((encode (str) (encode-coding-string str (keyboard-coding-system))))
    (start-process "growlnotify" nil 
                   growlnotify
                   "-t" (encode title)
                   "-a" "Emacs"
                   "-n" "Emacs"
                   "-m" (encode message))))


(server-start)
