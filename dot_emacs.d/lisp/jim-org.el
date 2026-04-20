;;; jim-org.el --- Org mode configuration -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; Notes, agenda, capture, and nicer Org visuals.

;;; Code:

(defun jim/org-font-setup ()
  "Make Org look pleasant in a mixed-pitch setup."
  (set-face-attribute 'org-document-title nil :weight 'bold :height 1.4)
  (dolist (face-height '((org-level-1 1.25)
                         (org-level-2 1.15)
                         (org-level-3 1.1)
                         (org-level-4 1.05)))
    (set-face-attribute (car face-height) nil
                        :weight 'semibold
                        :height (cadr face-height)))
  (dolist (face '(org-block
                  org-code
                  org-table
                  org-verbatim
                  org-special-keyword
                  org-meta-line
                  org-checkbox
                  org-formula))
    (set-face-attribute face nil :inherit '(fixed-pitch)))
  (set-face-attribute 'org-tag nil :inherit '(shadow fixed-pitch))
  (when (facep 'org-indent)
    (set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))))

(use-package org
  :ensure nil
  :bind (("C-c a" . org-agenda)
         ("C-c c" . org-capture)
         ("C-c l" . org-store-link))
  :hook ((org-mode . visual-line-mode)
         (org-mode . variable-pitch-mode)
         (org-mode . (lambda () (setq-local line-spacing 0.15))))
  :config
  (setq org-directory (expand-file-name "~/org")
        org-default-notes-file (expand-file-name "inbox.org" org-directory)
        org-agenda-files
        (list (expand-file-name "inbox.org" org-directory)
              (expand-file-name "projects.org" org-directory))
        org-log-done 'time
        org-startup-indented t
        org-hide-emphasis-markers t
        org-pretty-entities t
        org-ellipsis "…"
        org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-edit-src-content-indentation 0
        org-return-follows-link t
        org-capture-templates
        '(("t" "Task" entry
           (file+headline "~/org/inbox.org" "Tasks")
           "* TODO %?\n%U\n")
          ("n" "Note" entry
           (file+headline "~/org/inbox.org" "Notes")
           "* %?\n%U\n")
          ("j" "Journal" entry
           (file+olp+datetree "~/org/journal.org")
           "* %?\nEntered on %U\n")))
  (require 'org-tempo)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (shell . t)))
  (jim/org-font-setup))

(use-package org-modern
  :after org
  :hook ((org-mode . org-modern-mode)
         (org-agenda-finalize . org-modern-agenda)))

(provide 'jim-org)
;;; jim-org.el ends here
