;;; jim-core.el --- Core editing defaults -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; Built-in Emacs behavior, startup tuning, filesystem paths, and fonts.

;;; Code:

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

(add-hook
 'emacs-startup-hook
 (lambda ()
   (setq gc-cons-threshold (* 64 1024 1024)
         gc-cons-percentage 0.1)))

(setq inhibit-startup-message t
      inhibit-startup-screen t
      initial-scratch-message ";; scratch buffer\n\n"
      ring-bell-function #'ignore
      use-dialog-box nil
      use-short-answers t
      sentence-end-double-space nil
      load-prefer-newer t
      vc-follow-symlinks t
      auto-window-vscroll nil
      read-process-output-max (* 1024 1024))

(defconst jim/var-directory
  (expand-file-name "var/" user-emacs-directory))

;; Keep transient editor state under ~/.emacs.d/var without leaving
;; backup or auto-save files in project directories.
(dolist (directory
         (list jim/var-directory
               (expand-file-name "auto-save/" jim/var-directory)))
  (make-directory directory t))

(setq make-backup-files nil
      create-lockfiles nil
      delete-by-moving-to-trash t
      save-interprogram-paste-before-kill t
      kill-do-not-save-duplicates t
      require-final-newline t
      scroll-margin 2
      scroll-conservatively 101
      global-auto-revert-non-file-buffers t
      auto-revert-verbose nil
      auto-save-file-name-transforms
      `((".*" ,(expand-file-name "auto-save/" jim/var-directory) t))
      custom-file
      (expand-file-name "custom.el" user-emacs-directory)
      recentf-save-file
      (expand-file-name "recentf" jim/var-directory)
      savehist-file
      (expand-file-name "savehist" jim/var-directory)
      save-place-file
      (expand-file-name "saveplace" jim/var-directory)
      uniquify-buffer-name-style 'forward
      uniquify-after-kill-buffer-p t
      uniquify-ignore-buffers-re "^\\*")

(load custom-file 'noerror)
(require 'uniquify)

(setq-default indent-tabs-mode nil
              tab-width 4
              fill-column 88)

(setq tab-always-indent 'complete)

(delete-selection-mode 1)
(electric-pair-mode 1)
(savehist-mode 1)
(save-place-mode 1)
(recentf-mode 1)
(global-auto-revert-mode 1)
(repeat-mode 1)
(blink-cursor-mode -1)
(show-paren-mode 1)
(column-number-mode 1)
(global-hl-line-mode 1)
(global-display-line-numbers-mode 1)

(when (fboundp 'pixel-scroll-precision-mode)
  (pixel-scroll-precision-mode 1))

(dolist (hook '(eshell-mode-hook
                shell-mode-hook
                term-mode-hook
                vterm-mode-hook
                org-mode-hook))
  (add-hook hook (lambda () (display-line-numbers-mode 0))))

(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)
(add-hook 'text-mode-hook #'visual-line-mode)

(defun jim/apply-fonts (&optional frame)
  "Apply per-platform fonts to FRAME."
  (with-selected-frame (or frame (selected-frame))
    (when (display-graphic-p)
      (cond
       ((eq system-type 'darwin)
        (when (find-font (font-spec :name "SF Mono"))
          (set-face-attribute 'default nil :family "SF Mono" :height 150)
          (set-face-attribute 'fixed-pitch nil :family "SF Mono" :height 1.0))
        (when (find-font (font-spec :name "SF Pro Text"))
          (set-face-attribute 'variable-pitch nil :family "SF Pro Text" :height 1.0)))))))

(add-hook 'after-init-hook #'jim/apply-fonts)
(add-hook 'after-make-frame-functions #'jim/apply-fonts)

(provide 'jim-core)
;;; jim-core.el ends here
