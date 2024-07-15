;;; emacs --- customization file

;;; Emacs customization file
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;;; Code:
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(use-package try :ensure t)
(use-package which-key :ensure t :config (which-key-mode))

(require 'server)
(if (not (server-running-p))
    (progn
      (server-start)))

(add-to-list 'load-path "~/.emacs.d/lisp")

(autoload 'm68k-mode "m68k-mode" "Major mode for editing m68k code." nil t)
;;(setq auto-mode-alist (append (list (cons "\\.s$" 'm68k-mode)
;;                                     (cons "\\.asm$" 'm68k-mode))
;;                              auto-mode-alist))

(setq m68k-indent-level       8
      m68k-indent-level-2     8
      m68k-auto-indent        nil
      m68k-toggle-completions nil)

(use-package modern-cpp-font-lock
  :ensure t)

(use-package flycheck
  :ensure t
  :init
  :config
  ;;(setq flycheck-check-syntax-automatically '(save mode-enable))
  ;;(setq flycheck-idle-change-delay 4)
  )

;; irony was used before LSP
;;(use-package irony
;;  :ensure t
;;  :defer t
;;  :init
;;  (add-hook 'c++-mode-hook 'irony-mode)
;;  (add-hook 'c-mode-hook 'irony-mode)
;;  (add-hook 'objc-mode-hook 'irony-mode)
;;  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
;;  :config
;;  (add-hook 'irony-mode-hook
;;            (lambda()
;;              (define-key irony-mode-map [remap completion-at-point]
;;                'irony-completion-at-point-async)
;;              (define-key irony-mode-map [remap complete-symbol]
;;                'irony-completion-at-point-async))))

;; auto-complete is older substitude for company
;;(use-package auto-complete
;;   :ensure t
;;   :init
;;   (progn
;;     (ac-config-default)
;;     (global-auto-complete-mode t)
;;     ))

(use-package yasnippet
   :ensure t
   :init
   (yas-global-mode 1))

(use-package yasnippet-snippets         ; Collection of snippets
  :ensure t)

(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0.0)
  (setq company-minimum-prefix-length 1)
  :init
  (add-hook 'after-init-hook 'global-company-mode)
  :after
  (add-to-list 'company-backends 'company-yasnippet)
  )

(use-package ido
  :ensure t
  :init
  (ido-mode t))

(use-package geben
  :ensure t)

(defun php-debug ()
  "Run current PHP script for debugging with geben."
  (interactive)
  (call-interactively 'geben)
  (shell-command
    (concat "XDEBUG_CONFIG='idekey=my-php-559' /usr/bin/php "
    (buffer-file-name) " &"))
  )

;; https://emacs.cafe/emacs/javascript/setup/2017/04/23/emacs-setup-javascript.html
;; http://elpa.gnu.org/packages/js2-mode.html
(use-package js2-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode)))

(use-package web-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.css\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
  (add-hook 'web-mode-hook
            (lambda ()
              (setq tab-width 2)
              (ggtags-mode 1)
              (delete-selection-mode t)
	      (define-key web-mode-map ["\C-tab"] 'company-complete)
              ;;(define-key web-mode-map "[F5]" 'php-debug)
              )))

;; https://github.com/AdamNiederer/ng2-mode
(use-package ng2-mode
  :ensure t
  )

;; https://emacs-lsp.github.io/lsp-mode/
(use-package lsp-mode
   :ensure t
   :init
   (setq lsp-keymap-prefix "C-c l")
   (setq lsp-enable-indentation nil)
   (setq lsp-enable-dap-auto-configure nil)
   (setq gc-cons-threshold 100000000)
   (setq read-process-output-max (* 1024 1024)) ;; 1mb
   :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
          (c-mode . lsp)
	  (c++-mode . lsp)
          (ng2-mode . lsp)
          (js2-mode . lsp)
          (typescript-mode . lsp)
          ;; if you want which-key integration
          (lsp-mode . lsp-enable-which-key-integration))
   :config
   :commands lsp)

;;(with-eval-after-load 'typescript-mode (add-hook 'typescript-mode-hook #'lsp))

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

(use-package lsp-treemacs
  :ensure t
  :commands
  lsp-treemacs-errors-list)

(use-package dap-mode
  :ensure t
  )

(require 'dap-chrome)

(use-package ggtags
  :ensure t)

(use-package projectile
  :ensure t
  :init
  (projectile-mode 1)
  :bind (:map projectile-mode-map
              ("s-p" . projectile-command-map)
              ("C-c p" . projectile-command-map)))

(use-package org
  :mode (("\\.org$" . org-mode))
  :ensure t
  :config
  (progn
    ;; config stuff
    ))

(use-package multi-term
  :ensure t
  )

(use-package sr-speedbar
  :ensure t
  )

(use-package pretty-speedbar
  :ensure t
  :config
  (progn
    (setq pretty-speedbar-icon-fill "#FFFFFF") ;; Fill color for all non-folder icons.
    (setq pretty-speedbar-icon-stroke "#DCDCDC") ;; Stroke color for all non-folder icons.
    (setq pretty-speedbar-icon-folder-fill "#D9B3FF") ;; Fill color for all folder icons.
    (setq pretty-speedbar-icon-folder-stroke "#CC00CC") ;; Stroke color for all folder icons.
    (setq pretty-speedbar-about-fill "#EFEFEF") ;; Fill color for all icons placed to the right of the file name, including checks and locks.
    (setq pretty-speedbar-about-stroke "#DCDCDC") ;; Stroke color for all icons placed to the right of the file name, including checks and locks.
    (setq pretty-speedbar-signs-fill "#594968") ;; Fill color for plus and minus signs used on non-folder icons.
    ;; Increase the indentation for better useability.
    (setq speedbar-indentation-width 3)
    ;; Add Markdown Header support
    (speedbar-add-supported-extension ".md")
    (setq speedbar-update-flag nil)
    ;; Disable checkmarks
    (setq speedbar-vc-do-check nil)
    (add-hook 'speedbar-mode-hook (lambda()
                                    ;; Disable word wrapping in speedbar if you always enable it globally.
                                    (visual-line-mode 0) 
                                    ;; Change speedbar's text size.  May need to alter the icon size if you change size.
                                    (text-scale-adjust -1)
                                    ))
    ))


(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay        0.5
          treemacs-directory-name-transformer      #'identity
          treemacs-display-in-side-window          t
          treemacs-eldoc-display                   'simple
          treemacs-file-event-delay                2000
          treemacs-file-extension-regex            treemacs-last-period-regex-value
          treemacs-file-follow-delay               0.2
          treemacs-file-name-transformer           #'identity
          treemacs-follow-after-init               t
          treemacs-expand-after-init               t
          treemacs-find-workspace-method           'find-for-file-or-pick-first
          treemacs-git-command-pipe                ""
          treemacs-goto-tag-strategy               'refetch-index
          treemacs-header-scroll-indicators        '(nil . "^^^^^^")
          treemacs-hide-dot-git-directory          t
          treemacs-indentation                     2
          treemacs-indentation-string              " "
          treemacs-is-never-other-window           nil
          treemacs-max-git-entries                 5000
          treemacs-missing-project-action          'ask
          treemacs-move-forward-on-expand          nil
          treemacs-no-png-images                   nil
          treemacs-no-delete-other-windows         t
          treemacs-project-follow-cleanup          nil
          treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                        'left
          treemacs-read-string-input               'from-child-frame
          treemacs-recenter-distance               0.1
          treemacs-recenter-after-file-follow      nil
          treemacs-recenter-after-tag-follow       nil
          treemacs-recenter-after-project-jump     'always
          treemacs-recenter-after-project-expand   'on-distance
          treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
          treemacs-project-follow-into-home        nil
          treemacs-show-cursor                     nil
          treemacs-show-hidden-files               t
          treemacs-silent-filewatch                nil
          treemacs-silent-refresh                  nil
          treemacs-sorting                         'alphabetic-asc
          treemacs-select-when-already-in-treemacs 'move-back
          treemacs-space-between-root-nodes        t
          treemacs-tag-follow-cleanup              t
          treemacs-tag-follow-delay                1.5
          treemacs-text-scale                      nil
          treemacs-user-mode-line-format           nil
          treemacs-user-header-line-format         nil
          treemacs-wide-toggle-width               70
          treemacs-width                           35
          treemacs-width-increment                 1
          treemacs-width-is-initially-locked       t
          treemacs-workspace-switch-cleanup        nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)
    (when treemacs-python-executable
      (treemacs-git-commit-diff-mode t))

    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))

    (treemacs-hide-gitignored-files-mode nil))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t d"   . treemacs-select-directory)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

;;(use-package treemacs-evil
;;  :after (treemacs evil)
;;  :ensure t)

;;(use-package treemacs-projectile
;;  :after (treemacs projectile)
;;  :ensure t)

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :ensure t)

;;(use-package treemacs-magit
;;  :after (treemacs magit)
;;  :ensure t)

(use-package treemacs-persp ;;treemacs-perspective if you use perspective.el vs. persp-mode
  :after (treemacs persp-mode) ;;or perspective vs. persp-mode
  :ensure t
  :config (treemacs-set-scope-type 'Perspectives))

(use-package treemacs-tab-bar ;;treemacs-tab-bar if you use tab-bar-mode
  :after (treemacs)
  :ensure t
  :config (treemacs-set-scope-type 'Tabs))

(defun make-scratch ()
  "Make scratch."
  (interactive)
  (if (get-buffer "*scratch*")
      (switch-to-buffer (get-buffer "*scratch*"))
    (progn
      (switch-to-buffer (get-buffer-create "*scratch*"))
      (emacs-lisp-mode))))

(defun buffer-mode (&optional buffer-or-name)
  "Returns the major mode associated with a buffer.
If buffer-or-name is nil return current buffer's mode."
  (buffer-local-value 'major-mode
   (if buffer-or-name (get-buffer buffer-or-name) (current-buffer))))

(defun isBufferCppMode ()
  (setq name (cdr (assoc 'mode-name (buffer-local-variables))))
  (if (stringp name)
      (if (string-match ".*[Cc]\\+\\+.*" name)
          t
        nil)
    nil))

(add-hook 'c-mode-common-hook
          (lambda ()
            (linum-mode)
            (ggtags-mode 1)
            (delete-selection-mode t)

            (setq tab-width 2)
            (setq display-fill-column-indicator t)
            (setq c-max-one-liner-length 100)
            (setq case-fold-search t)

            ;; * LSP *
            (setq lsp-diagnostics-provider :none)
            (setq lsp-headerline-breadcrumb-enable nil)
            ;;(setq lsp-completion-enable t)
             
            ;; code line analyze result will be shown only in modeline 
            (setq lsp-ui-sideline-enable nil)
            (setq lsp-modeline-diagnostics-enable t)
            
            (setq flycheck-select-checker "c/c++-cppcheck")
            (flycheck-mode)
            ))

(add-hook 'asm-mode-hook
          (lambda ()
            (linum-mode)
            (ggtags-mode 1)
            (delete-selection-mode t)
            (company-mode 0)

            (setq tab-width 8)
            (setq indent-tabs-mode t)
            (setq tab-always-indent nil)
            (setq display-fill-column-indicator t)
	    (setq display-fill-column-indicator-column 79)
            (setq case-fold-search t)
            
            ;; you can use `comment-dwim' (M-;) for this kind of behaviour anyway
            ;(local-unset-key (vector asm-comment-char))
            ))

(defconst zbr-c-style
  '(
    (tab-width . 2)
    (c-basic-offset . 2)
    (c-comment-only-line-offset . (0 . 0))
    
    (c-hanging-braces-alist . ((defun-open before)
			       (defun-open after)
			       (namespace-open after)))    
    (c-offsets-alist . (
                        (topmost-intro . 0)
                        (topmost-intro-cont . 0)
                        (arglist-cont-nonempty . +)
                        (defun-open . 0)
                        (defun-close . 0)
                        (defun-block-intro . +)

                        (statement . 0)
                        (substatement-open . 0)
                        (block-close . 0)
                        
                        (inline-open . 0)
                        (inline-close . 0)

                        (innamespace . 0)
                        (caselabel . 0)
                        ))
    (c-block-comment-prefix . ""))
  "C/C++ Programming Style.")
(c-add-style "zbr" zbr-c-style)

;; (defun vs-build (name)
;;   "VS build configuration NAME."
;;   (interactive)
;;   (setq sln (replace-regexp-in-string "\\\\" "/" project-sln t t))
;;   (setq compile-command (concat "cd \"" sln "\"" " & devenv cpp.sln /build " name ))
;;   (compile compile-command)
;;   )

;; (defun vs-rebuild (name)
;;   "VS rebuild configuration NAME."
;;   (interactive)
;;   (setq sln (replace-regexp-in-string "\\\\" "/" project-sln t t))
;;   (setq compile-command (concat "cd \"" sln "\"" " & devenv cpp.sln /rebuild " name ))
;;   (compile compile-command)
;;   )

(defvar project nil "")
(defvar src nil "")
(defvar bmk nil "")
(defvar project-sln nil "")

(defun projects()
  "Projects"
  (interactive)
  ;;(setenv "PATH" (concat "C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\Professional\\Common7\\IDE;" (getenv "PATH")))
  ;;(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

  (setq project "~/projects")
  (setq src (concat src project))
             
  (setq vc-handled-backends nil) ;; disable git 
  
  (setq company-minimum-prefix-length 1
        company-idle-delay 0.0)

  (lsp-treemacs-sync-mode 1)
  
  (setq bmk (concat project "\\emacs.bmk"))
  (if (file-exists-p bmk)
      (bookmark-load bmk))

  (setq c-default-style "zbr")
  (dired src)
  (server-force-stop)
)

(add-hook 'emacs-startup-hook
          (lambda ()

            (global-set-key (kbd "<f1>") 'projectile-compile-project)
            (global-set-key (kbd "<f2>") 'projectile-run-project)
            
            (global-set-key (kbd "<f7>") 'treemacs)
            (global-set-key (kbd "<f8>") 'whitespace-mode)
            (global-set-key (kbd "<f9>") 'ff-find-related-file)
            (global-set-key (kbd "<C-f9>") 'revert-buffer)
            
            (define-key projectile-mode-map [?\s-d] 'projectile-find-dir)
            (define-key projectile-mode-map [?\s-p] 'projectile-switch-project)
            (define-key projectile-mode-map [?\s-f] 'projectile-find-file)
            (define-key projectile-mode-map [?\s-g] 'projectile-grep)
            
            (projects)
            (treemacs)
            ))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(tango-dark))
 '(gdb-many-windows t)
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(make-backup-files nil)
 '(package-check-signature nil)
 '(package-selected-packages
   '(xref gnu-elpa-keyring-update dap-mode dap-chrome pretty-speedbar sr-speedbar multi-term lsp-treemacs lsp-ui org-plus-contrib js2-mode lsp-mode ng2-mode company-irony-c-headers yasnippet-snippets yasnippet company-irony modern-cpp-font-lock company-jedi company magit projectile web-mode s php-mode json-mode iedit ggtags color-theme))
 '(projectile-auto-discover nil)
 '(show-paren-mode t)
 '(speedbar-show-unknown-files t)
 '(speedbar-update-flag nil)
 '(sql-product 'mysql)
 '(sr-speedbar-default-width 50)
 '(sr-speedbar-max-width 100)
 '(sr-speedbar-right-side nil)
 '(tool-bar-mode nil)
 '(truncate-lines t)
 '(warning-suppress-types '((lsp-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Victor Mono" :foundry "UKWN" :slant normal :weight normal :height 140 :width normal))))
 '(geben-backtrace-fileuri ((t (:foreground "salmon" :weight bold))))
 '(whitespace-space ((t (:foreground "darkgray")))))

;;; .emacs ends here
