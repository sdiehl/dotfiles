
(load-file (let ((coding-system-for-read 'utf-8))
                (shell-command-to-string "agda-mode locate")))

(setq agda2-include-dirs
      (list "." (expand-file-name "~/agda-base")))

; Viper mode emulates basic vi keys, part of emacs.
;(setq viper-mode t)

(require 'agda2)


;(require 'viper)

; Vimpulse emulates some more advanced vim keys, needs to be downloaded
; and put into emacs load-path.
; http://www.emacswiki.org/emacs/vimpulse.el
; (require 'vimpulse)

; Rect-mark improves visual mode (I think), also needs to be downloaded
; and put into emacs load-path.
; http://www.emacswiki.org/cgi-bin/wiki/download/rect-mark.el
; (require 'rect-mark)

; If you choose level 5 (I think you should) when viper asks what
; skill level you are, you will get access to all of emacs key
; bindings on top of vi's -- this can be annoying, when you by accident
; use some of emacs' bindings. The following disables some emacs bindings
; you probably won't miss anyway:

(global-unset-key (kbd "M-k"))
(global-unset-key (kbd "M-j"))
(global-unset-key (kbd "M-h"))
(global-unset-key (kbd "M-l"))
(global-unset-key (kbd "M-o"))
;(global-unset-key (kbd "C-x C-l"))
;(global-unset-key (kbd "C-x C-d"))
(global-unset-key (kbd "M-:"))
(global-unset-key (kbd "M-u"))

; If you use emacs from a terminal you want to add the following bindings,
; for some reason they work in GUI mode but not in terminal mode.
(global-set-key (kbd "C-c ,") 'agda2-goal-and-context)
(global-set-key (kbd "C-c .") 'agda2-goal-and-context-and-inferred)
(global-set-key (kbd "C-c C-@") 'agda2-give)
