;;; jim-languages.el --- Language-specific editing support -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; Lightweight support for scripting and quick edits across a few languages.

;;; Code:

(require 'seq)

(defconst jim/eglot-required-programs
  '((python-mode "basedpyright-langserver" "pyright-langserver" "pylsp"
                 "pyrefly" "jedi-language-server" "ruff" "ruff-lsp")
    (python-ts-mode "basedpyright-langserver" "pyright-langserver" "pylsp"
                    "pyrefly" "jedi-language-server" "ruff" "ruff-lsp")
    (ruby-mode "ruby-lsp" "solargraph")
    (ruby-ts-mode "ruby-lsp" "solargraph")
    (go-ts-mode "gopls")
    (rust-ts-mode "rust-analyzer")
    (swift-mode "sourcekit-lsp"))
  "Executables that enable Eglot support for each major mode.")

(defun jim/set-local-compile-command (command)
  "Set buffer-local `compile-command' to COMMAND when non-nil."
  (when command
    (setq-local compile-command command)))

(defun jim/maybe-enable-eglot ()
  "Start Eglot when a suitable server executable exists for `major-mode'."
  (let ((programs (alist-get major-mode jim/eglot-required-programs)))
    (when (and programs (seq-some #'executable-find programs))
      (eglot-ensure))))

(defun jim/file-compile-command (program)
  "Build a compile command for PROGRAM against the current file."
  (when buffer-file-name
    (format "%s %s" program (shell-quote-argument buffer-file-name))))

(defun jim/python-setup ()
  "Configure Python editing."
  (setq-local python-shell-interpreter "python3")
  (jim/set-local-compile-command (jim/file-compile-command "python3"))
  (jim/maybe-enable-eglot))

(defun jim/ruby-setup ()
  "Configure Ruby editing."
  (jim/set-local-compile-command (jim/file-compile-command "ruby"))
  (jim/maybe-enable-eglot))

(defun jim/swift-setup ()
  "Configure Swift editing."
  (jim/set-local-compile-command (jim/file-compile-command "swift"))
  (jim/maybe-enable-eglot))

(defun jim/go-setup ()
  "Configure Go editing."
  (jim/set-local-compile-command
   (cond
    ((locate-dominating-file default-directory "go.mod") "go test ./...")
    (buffer-file-name
     (format "go run %s" (shell-quote-argument buffer-file-name)))))
  (jim/maybe-enable-eglot))

(defun jim/rust-setup ()
  "Configure Rust editing."
  (let ((cargo-root (locate-dominating-file default-directory "Cargo.toml")))
    (when cargo-root
      (jim/set-local-compile-command
       (format "cargo test --manifest-path %s"
               (shell-quote-argument
                (expand-file-name "Cargo.toml" cargo-root))))))
  (jim/maybe-enable-eglot))

(defun jim/makefile-setup ()
  "Configure Makefile editing."
  (setq-local indent-tabs-mode t)
  (jim/set-local-compile-command "make -k")
  (jim/completion-capf-setup))

(use-package eglot
  :ensure nil
  :bind (:map eglot-mode-map
         ("C-c e r" . eglot-rename)
         ("C-c e a" . eglot-code-actions)
         ("C-c e f" . eglot-format-buffer))
  :custom
  (eglot-autoshutdown t)
  :config
  (add-to-list 'eglot-server-programs
               `((ruby-mode ruby-ts-mode)
                 . ,(eglot-alternatives
                     '(("ruby-lsp")
                       ("solargraph" "stdio")))))
  (add-to-list 'eglot-server-programs
               '((swift-mode) "sourcekit-lsp")))

(use-package treesit-auto
  :if (fboundp 'treesit-available-p)
  :custom
  (treesit-auto-install 'prompt)
  (treesit-auto-langs '(python ruby go rust))
  :config
  (when (treesit-available-p)
    (treesit-auto-add-to-auto-mode-alist 'all)
    (global-treesit-auto-mode 1)))

(use-package python
  :ensure nil
  :custom
  (python-indent-offset 4)
  :hook ((python-mode . jim/python-setup)
         (python-ts-mode . jim/python-setup)))

(use-package ruby-mode
  :ensure nil
  :hook ((ruby-mode . jim/ruby-setup)
         (ruby-ts-mode . jim/ruby-setup)))

(use-package swift-mode
  :mode ("\\.swift\\'" . swift-mode)
  :hook (swift-mode . jim/swift-setup))

(use-package go-ts-mode
  :ensure nil
  :hook (go-ts-mode . jim/go-setup))

(use-package rust-ts-mode
  :ensure nil
  :hook (rust-ts-mode . jim/rust-setup))

(use-package make-mode
  :ensure nil
  :hook ((makefile-mode . jim/makefile-setup)
         (makefile-gmake-mode . jim/makefile-setup)))

(provide 'jim-languages)
;;; jim-languages.el ends here
