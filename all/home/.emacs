;; Auto complete package
(add-to-list 'load-path "/usr/share/emacs/site-lisp/")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "/usr/share/emacs/site-lisp/ac-dict")
(ac-config-default)
(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)
(defvaralias 'c-basic-offset 'tab-width)
(defvaralias 'cperl-indent-level 'tab-width)


;; Load CEDET.
(global-ede-mode 1)
(semantic-mode 1)
(require 'semantic/sb)
; More advanced functionality for name completion
(require 'semantic/ia)
; System header files
(require 'semantic/bovine/gcc)

; Integration with imenu
;(defun my-semantic-hook ()
;  (imenu-add-to-menubar "TAGS"))
;(add-hook 'semantic-init-hooks 'my-semantic-hook)

; Work with Semantic
(defun my-cedet-hook ()
  (local-set-key [(control return)] 'semantic-ia-complete-symbol)
  (local-set-key "\C-c?" 'semantic-ia-complete-symbol-menu)
  (local-set-key "\C-c>" 'semantic-complete-analyze-inline)
  (local-set-key "\C-cp" 'semantic-analyze-proto-impl-toggle)
  (local-set-key "\C-cd" 'semantic-ia-show-doc)
  (local-set-key "\C-cc" 'semantic-ia-describe-class))
(add-hook 'c-mode-common-hook 'my-cedet-hook)

;; enable ctags for some languages:
;;  Unix Shell, Perl, Pascal, Tcl, Fortran, Asm
;(when (cedet-ectag-version-check t)
;  (semantic-load-enable-primary-exuberent-ctags-support))

;; Choose one of those method for Name completion
; Names completion
;(defun my-c-mode-cedet-hook ()
; (local-set-key "." 'semantic-complete-self-insert)
; (local-set-key ">" 'semantic-complete-self-insert))
;(add-hook 'c-mode-common-hook 'my-c-mode-cedet-hook)

; Names completion with auto-complete package
(defun my-c-mode-cedet-hook ()
  (add-to-list 'ac-sources 'ac-source-gtags)
  (add-to-list 'ac-sources 'ac-source-semantic))
(add-hook 'c-mode-common-hook 'my-c-mode-cedet-hook)

(setq-default semanticdb-default-save-directory "~/.emacs.d/semanticdb/")

;; Which function mode
(which-function-mode 1)


;; Load ECB
;(add-to-list 'load-path "~/ecb/")
;(require 'ecb)
;(require 'ecb-autoloads)
;(ecb-activate)

;; Load linum
(require 'linum)
(global-linum-mode 1)

; Bind key
(global-set-key (kbd "s-RET") 'complete-tag)
(lookup-key (current-global-map) (kbd "s-RET"))

;; Lua mode
(setq auto-mode-alist (cons '("\.lua$" . lua-mode) auto-mode-alist))
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)

;; Python mode
(autoload 'python-mode "python-mode.el" "Python mode." t)
(setq auto-mode-alist (append '(("/*.\.py$" . python-mode)) auto-mode-alist))

;; AucTex
(load "auctex.el" nil t t)
(require 'tex-mik)

(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)

;; You may prefer auto-fill-mode instead of visual-line-mode.
(add-hook 'LaTeX-mode-hook 'auto-fill-mode)
;(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)

(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)


;; Set emacs color
 (set-foreground-color "#D7D0C7")
 (set-background-color "#151515")


;; Set transparent
;(eval-when-compile (require 'cl))
;(defun toggle-transparency ()
; (interactive)
; (if (/=
;     (cadr (frame-parameter nil 'alpha))
;     100)
;     (set-frame-parameter nil 'alpha '(100 100))
;     (set-frame-parameter nil 'alpha '(85 50))))
;(global-set-key (kbd "C-c t") 'toggle-transparency)
;;(set-frame-parameter (selected-frame) 'alpha '(<active> [<inactive>]))
(set-frame-parameter (selected-frame) 'alpha '(75 50))
(add-to-list 'default-frame-alist '(alpha 75 50))


; Work around with some tex buffer
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Neep" :foundry "jmk" :slant normal :weight normal :height 113 :width normal))))
 '(tex-verbatim ((t (:foundry "courier" :family "*"))) t))

; Unicode font
;(require 'unicode-fonts)
;(unicode-fonts-setup)



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(describe-char-unidata-list (quote (name old-name general-category decomposition decimal-digit-value digit-value numeric-value)))
 '(inhibit-startup-screen t))

