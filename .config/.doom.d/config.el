;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "Gabe Saenz"
;; user-mail-address "gabesaenz@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; window transparency
;; (add-to-list 'default-frame-alist '(alpha . 70))

;; big font mode
;; set increment
;; (setq doom-big-font-increment 5)
;; disable then enable doom big font mode
;; this prevents the font size from increasing repeatedly
;; (if (display-graphic-p)
;; (doom-big-font-mode -1))
;; (if (display-graphic-p)
;; (doom-big-font-mode +1))

;; theming fix for emacsclient
(setq custom-theme-directory "/Users/gabesaenz/dotfiles/.config/.doom.d/themes/")

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one)
;; (setq doom-theme 'doom-nord)
;; (setq doom-theme 'doom-gruvbox)
(setq doom-theme 'doom-base16)
;; (setq doom-theme 'doom-gruvbox-material) ;; this is causing an error with the emacs server

;; auto reload the base16 theme when it changes
(setq base16-reload nil)
(if (equal doom-theme 'doom-base16) (setq base16-reload t))
(setq base16-theme-file (concat (file-name-as-directory custom-theme-directory) "doom-base16-theme.el"))
(defun base16-theme-reload ()
  (load-file base16-theme-file)
  (doom/reload-theme))
(defun base16-callback (event)
  (message "Event %S" event)
  (if base16-reload (base16-theme-reload)))
(require 'filenotify)
(file-notify-add-watch base16-theme-file '(change) 'base16-callback)

;; Dashboard
;; Remove the banner
(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-banner)
;; Remove load time message
(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-loaded)
;; Remove footer
(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-footer)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.



;; follow symlinks
;; https://emacs.stackexchange.com/a/41292
;; (setq find-file-visit-truename t) ; doesn't seem to work

;; add characters to devanagari-inscript input method
(with-temp-buffer
  (activate-input-method "devanagari-inscript") ;; the input method has to be triggered for `quail-package-alist' to be non-nil
  (let ((quail-current-package (assoc "devanagari-inscript" quail-package-alist)))
    (quail-define-rules ((append . t))
                        ("æ" ?ऽ)
                        (">>" ?॥))))

;; RMarkdown-mode
;; https://github.com/polymode/poly-R
(add-to-list 'auto-mode-alist '("\\.Rmd" . poly-markdown+R-mode))
;; (add-to-list 'auto-mode-alist '("\\.Rmd" . markdown-mode))
;; (add-to-list 'auto-mode-alist '("\\.Rmd\\'" . markdown-mode))
;; (define-key markdown-mode-map [M-n] nil)
;; (global-unset-key (kbd "M-n"))
;; (define-key markdown-mode-map (kbd "M-n") nil)

;; disable smartparens/automatic parentheses completion
(remove-hook 'doom-first-buffer-hook #'smartparens-global-mode)

;; whitespace
;; set white space options
(setq whitespace-style '(
                         face
                         indentation
                         tabs
                         tab-mark
                         spaces
                         space-mark
                         newline
                         newline-mark
                         trailing
                         ;; lines-tail
                         ))
;; reload white space options
(global-whitespace-toggle-options '(whitespace-style))

;; email
(set-email-account! "gmx"
                    '(;; (mu4e-sent-folder       . "")
                      ;; (mu4e-drafts-folder     . "")
                      ;; (mu4e-trash-folder      . "")
                      ;; (mu4e-refile-folder     . "")
                      (smtpmail-smtp-user     . "gabriel.saenz@gmx.de")
                      (user-mail-address      . "gabriel.saenz@gmx.de")    ;; only needed for mu < 1.4
                      (user-full-name         . "Gabriel Saenz"))
                    t)
;; offlineimap
(setq +mu4e-backend 'offlineimap)
;; msmtp
(after! mu4e
  (setq sendmail-program (executable-find "msmtp")
	send-mail-function #'smtpmail-send-it
	message-sendmail-f-is-evil t
	message-sendmail-extra-arguments '("--read-envelope-from")
	message-send-mail-function #'message-send-mail-with-sendmail))

;; customize window decoration for emacs-plus
;; This should be in early-init.el but I'm trying it here.
;; no titlebar, normal corners
;; (add-to-list 'default-frame-alist '(undecorated . t))
;; no titlebar, rounded corners
;; (add-to-list 'default-frame-alist '(undecorated-round . t))

;; fish shell related fixes suggested by doom doctor
(setq shell-file-name (executable-find "bash"))
(setq-default vterm-shell (executable-find "fish"))
(setq-default explicit-shell-file-name (executable-find "fish"))
