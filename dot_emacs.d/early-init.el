;;; early-init.el --- Early startup settings -*- lexical-binding: t; -*-

(setq package-enable-at-startup nil
      frame-inhibit-implied-resize t
      frame-resize-pixelwise t
      native-comp-async-report-warnings-errors 'silent
      fast-but-imprecise-scrolling t
      redisplay-skip-fontification-on-input t
      inhibit-compacting-font-caches t)

(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

(when (fboundp 'menu-bar-mode)
  (menu-bar-mode -1))
