;;; jim-git.el --- Git integration -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; Version-control tools.

;;; Code:

(use-package magit
  :bind (("C-x g" . magit-status)))

(provide 'jim-git)
;;; jim-git.el ends here
