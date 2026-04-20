;;; jim-completion.el --- Minibuffer and in-buffer completion -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; Completion stack for fast navigation and lightweight coding support.

;;; Code:

(defun jim/completion-capf-setup ()
  "Add lightweight fallback completion sources for the current buffer."
  (add-hook 'completion-at-point-functions #'cape-file nil t)
  (add-hook 'completion-at-point-functions #'cape-dabbrev nil t))

(add-hook 'prog-mode-hook #'jim/completion-capf-setup)
(add-hook 'conf-mode-hook #'jim/completion-capf-setup)

(use-package vertico
  :init
  (vertico-mode 1)
  :custom
  (vertico-cycle t))

(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides
        '((file (styles basic partial-completion)))))

(use-package corfu
  :init
  (global-corfu-mode 1)
  :custom
  (corfu-auto t)
  (corfu-auto-prefix 2)
  (corfu-cycle t)
  (corfu-popupinfo-delay '(0.4 . 0.2))
  :config
  (corfu-popupinfo-mode 1))

(use-package cape
  :after corfu
  :bind ("C-c p" . cape-prefix-map))

(use-package marginalia
  :after vertico
  :init
  (marginalia-mode 1))

(use-package consult
  :bind (("C-s" . consult-line)
         ("C-c f" . consult-fd)
         ("C-c g" . consult-ripgrep)
         ("C-c o" . consult-outline)
         ("C-c t" . consult-theme)
         ("C-x b" . consult-buffer)
         ("M-y" . consult-yank-pop)
         :map minibuffer-local-map
         ("C-r" . consult-history))
  :custom
  (consult-narrow-key "<")
  :config
  (consult-customize
   consult-ripgrep consult-git-grep consult-grep
   :preview-key '(:debounce 0.3 any)))

(use-package embark
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)
         ("C-h B" . embark-bindings))
  :init
  (setq prefix-help-command #'embark-prefix-help-command))

(use-package embark-consult
  :after (embark consult)
  :hook (embark-collect-mode . consult-preview-at-point-mode))

(provide 'jim-completion)
;;; jim-completion.el ends here
