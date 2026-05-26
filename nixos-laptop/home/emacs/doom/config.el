;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name ""
;; user-mail-address "")

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

;; (setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))

(setq doom-font (font-spec :family "VictorMono Nerd Font" :size 20))
;; (setq doom-font (font-spec :family "monospace" :size 20))
;; (setq doom-variable-pitch-font (font-spec :family "sansSerif" :size 20))
(setq doom-variable-pitch-font (font-spec :family "Gentium" :size 20))
;; (setq doom-variable-pitch-font (font-spec :family "Noto Sans" :size 20))
;; WARNING: if you specify a size for the emoji font it will hard-lock any usage of this font to that size. It's rarely a good idea to do so!
;; (setq doom-emoji-font (font-spec :family "emoji"))
;; (setq doom-emoji-font (font-spec :family "Noto Color Emoji"))
;; don't set doom-symbol-font / main fallback unicode font
;; as it would override the more specific settings below
;; (setq doom-symbol-font (font-spec :family "Noto Serif" :size 24))

;; examples of how to configure a single unicode block
;; (after! unicode-fonts
;;   (push "Gentium" (cadr (assoc "Greek and Coptic" unicode-fonts-block-font-mapping))))

;; (after! unicode-fonts
;;   (push "Symbola" (cadr (assoc "Miscellaneous Symbols" unicode-fonts-block-font-mapping))))

;; set multiple unicode blocks at once
(after! unicode-fonts
  (dolist (unicode-block '("Greek and Coptic"
                           "Greek Extended"
                           "Ancient Greek Musical Notation"
                           "Ancient Greek Numbers"))
    (push "Gentium" (cadr (assoc unicode-block unicode-fonts-block-font-mapping)))))

(after! unicode-fonts
  (dolist (unicode-block '("Devanagari"
                           "Devanagari Extended"
                           "Vedic Extensions"))
    (push "DejaVu Sans Mono" (cadr (assoc unicode-block unicode-fonts-block-font-mapping)))))

;;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; window opacity
;; make the everything transparent
(add-to-list 'default-frame-alist '(alpha . 95))
;; make only the background transparent (doesn't seem to work)
;; (set-frame-parameter nil 'alpha-background 100)
;; (add-to-list 'default-frame-alist '(alpha-background . 100))

;; big font mode
;; set increment
;; (setq doom-big-font-increment 3)
;; disable then enable doom big font mode
;; this prevents the font size from increasing repeatedly
;; (if (display-graphic-p)
;;     (doom-big-font-mode -1))
;; (if (display-graphic-p)
;;     (doom-big-font-mode +1))

;; make sure this directory exists so DankMaterialShell can generate themes there
(make-directory "~/.config/emacs" t)
(setq custom-theme-directory "~/.config/emacs/themes/")

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one)
(setq doom-theme 'dank-emacs)

;; auto reload the theme when it changes
(setq dynamic-theme-file (concat (file-name-as-directory custom-theme-directory) (format "%s%s" doom-theme "-theme.el")))
(defun dynamic-theme-reload ()
  (load-file dynamic-theme-file)
  (doom/reload-theme))
(defun dynamic-theme-callback (event)
  (message "Event %S" event)
  (dynamic-theme-reload))
(require 'filenotify)
(file-notify-add-watch dynamic-theme-file '(change) 'dynamic-theme-callback)

;; Dashboard
;; Remove the banner
(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-banner)
;; Remove load time message
(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-loaded)
;; Remove footer
(remove-hook '+doom-dashboard-functions #'doom-dashboard-widget-footer)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)

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

;; +lookup config
;; look up words in dictionaries while in reading focused modes
(dolist (mode '(quick-sdcv-mode nov-mode))
  (set-lookup-handlers! mode
    :definition '(define-word-at-point :async t)
    :documentation '(quick-sdcv-search-at-point :async t)))
;; adjust org-mode lookup behavior
(defun org-lookup-definition-fallback-handler (orig-fun WORD &rest args)
  (if (org-in-src-block-p)
      (apply orig-fun WORD args)
    (progn
      (setq-local +lookup-definition-functions '(define-word-at-point t))
      (+lookup/definition))))
(advice-add '+org-lookup-definition-handler :around #'org-lookup-definition-fallback-handler)
(defun org-lookup-documentation-fallback-handler (orig-fun WORD &rest args)
  (if (org-in-src-block-p)
      (apply orig-fun WORD args)
    (progn
      (setq-local +lookup-documentation-functions '(quick-sdcv-search-at-point t))
      (+lookup/documentation))))
(advice-add '+org-lookup-documentation-handler :around #'org-lookup-documentation-fallback-handler)
(defun org-lookup-online-override-handler (orig-fun WORD &rest args)
  (if (eq major-mode 'org-mode)
      (progn
        (setq-local +lookup-documentation-functions '(quick-sdcv-search-at-point t))
        (+lookup/documentation))
    (apply orig-fun WORD args)))
(advice-add '+lookup-online-backend-fn :around #'org-lookup-online-override-handler);)

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

;; set default multilingual input method
;; this is the secondary input method
;; that you switch to with C-\
(setopt default-input-method "german")
(after! pyim
  (setopt default-input-method "german"))

;; functions to switch between input methods
;; as well as related settings like the current dictionary
(defun input-method-english ()
  "Switch to English input method"
  (interactive)
  (ispell-change-dictionary "en")
  (set-input-method nil))
(defun input-method-german ()
  "Switch to German input method"
  (interactive)
  (ispell-change-dictionary "de")
  (set-input-method "german"))
(defun input-method-compose ()
  "Switch to Compose input method"
  (interactive)
  (set-input-method "compose"))
(defun input-method-ancient-greek ()
  "Switch to Ancient Greek input method"
  (interactive)
  (ispell-change-dictionary "grc")
  (set-input-method "greek-ibycus4"))

;; add shortcut keys for commonly used input methods
;; they should use key combinations that can be pressed in any context
;; for example, don't use the leader key (space)
;; as it can't be accessed when entering search terms
(map! (:prefix ("C-M-S-s-i" . "Input Method")
       :desc "English" "e" #'input-method-english
       :desc "German" "d" #'input-method-german
       :desc "Compose" "c" #'input-method-compose
       :desc "Ancient Greek" "g" #'input-method-ancient-greek))

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
(setq whitespace-global-modes '(not nov-mode))
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
;; msmtp
(after! mu4e
  (setq sendmail-program (executable-find "msmtp")
	send-mail-function #'smtpmail-send-it
	message-sendmail-f-is-evil t
	message-sendmail-extra-arguments '("--read-envelope-from")
	message-send-mail-function #'message-send-mail-with-sendmail))

;; shell related fixes suggested by doom doctor
(setq shell-file-name (executable-find "bash"))
(setq-default vterm-shell (executable-find "zsh"))
(setq-default explicit-shell-file-name (executable-find "zsh"))

;; use builtin eww browser for online lookup (dictionary)
(setq +lookup-open-url-fn #'eww)

;; define-word default service
(setq define-word-default-service 'offline-wikitionary)
(setq define-word-offline-dict-directory '"/home/gabe/Dictionaries/offline-wiktionary/ding")

;; display
(display-battery-mode)

;; enable nov EPUB reader for .epub files
(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
;; nov.el configuration
;; force variable pitch font mode since it wasn't happening otherwise
(add-hook 'nov-mode-hook 'variable-pitch-mode)
;; font configuration
(defun my-nov-font-setup ()
  (face-remap-add-relative 'shr-text :family "Noto Serif"
                           :height 1.0))
(add-hook 'nov-mode-hook 'my-nov-font-setup)
;; force disabling of visible whitespace
;; not necessary if nov-mode is added to global whitespace blacklist
;; (add-hook 'nov-mode-hook
;;           (lambda () (setq-local whitespace-style nil)))
;; basic option
(setq nov-text-width t)
(setq visual-fill-column-center-text t)
(add-hook 'nov-mode-hook 'visual-line-mode)
(add-hook 'nov-mode-hook 'visual-fill-column-mode)
;; alternative option with justification
;; (setq nov-text-width t)

;; (defun my-nov-window-configuration-change-hook ()
;;   (my-nov-post-html-render-hook)
;;   (remove-hook 'window-configuration-change-hook
;;                'my-nov-window-configuration-change-hook
;;                t))

;; (defun my-nov-post-html-render-hook ()
;;   (if (get-buffer-window)
;;       (let ((max-width (pj-line-width))
;;             buffer-read-only)
;;         (save-excursion
;;           (goto-char (point-min))
;;           (while (not (eobp))
;;             (when (not (looking-at "^[[:space:]]*$"))
;;               (goto-char (line-end-position))
;;               (when (> (shr-pixel-column) max-width)
;;                 (goto-char (line-beginning-position))
;;                 (pj-justify)))
;;             (forward-line 1))))
;;     (add-hook 'window-configuration-change-hook
;;               'my-nov-window-configuration-change-hook
;;               nil t)))

;; (add-hook 'nov-post-html-render-hook 'my-nov-post-html-render-hook)

;; enable themed pdf viewing by default
(use-package pdf-tools
  :hook ((pdf-view-mode . pdf-view-themed-minor-mode)))

;; automatically update feed when opening elfeed
(add-hook! 'elfeed-search-mode-hook #'elfeed-update)
;; tag entries with media as podcasts
;; https://www.reddit.com/r/emacs/comments/g1o36p/emacs_way_to_listen_podcasts/
;; (defun ime-elfeed-podcast-tagger (entry)
;;   (when (elfeed-entry-enclosures entry)
;;     (elfeed-tag entry 'podcast)))

;; (add-hook 'elfeed-new-entry-hook #'ime-elfeed-podcast-tagger)

;; eww browser
;;
;; set eww as default emacs web browser
;; https://www.reddit.com/r/emacs/comments/lia9s0/open_links_in_elfeed_in_eww_or_other_emacs_web/
(setq browse-url-browser-function 'eww-browse-url)
;; enable readable mode by default
;; (setq eww-readable-default t)
(add-hook 'eww-after-render-hook 'eww-readable)
;; use visual-line-mode to wrap text
(add-hook 'eww-mode-hook 'visual-line-mode)

;; quick-sdcv
(use-package quick-sdcv
  ;; :ensure t
  :config
  ;; try to get it looking like nov-mode
  (add-hook 'nov-mode-hook 'visual-line-mode)
  (add-hook 'nov-mode-hook 'visual-fill-column-mode)
  :custom
  ;; not necessary now that env variable STARDICT_DATA_DIR is set
  ;; (quick-sdcv-dictionary-data-dir "~/Dictionaries/stardict/dic")
  (quick-sdcv-dictionary-prefix-symbol "►")
  (quick-sdcv-ellipsis " ▼"))
;; this doesn't seem to actually work
;; (add-to-list 'display-buffer-alist '("\\*sdcv"
;;                                      (display-buffer-pop-up-window)))
(require 'shr)
(require 'quick-sdcv)
(defun quick-sdcv--translate-result (word dictionary-list)
  "Search for WORD in DICTIONARY-LIST. Return filtered string of results."
  (let* ((args (cons word (mapcan (lambda (d) (list "-u" d)) dictionary-list)))
         (result (mapconcat
                  (lambda (result)
                    (let-alist result
                      ;; This is the original line.
                      ;; (format "-->%s\n-->%s\n%s\n\n" .dict .word .definition)))
                      ;; my changes start
                      (format "-->%s\n-->%s\n%s\n\n" .dict .word
                              ;; check for presence of html tags (poorly)
                              ;; and parse the html if they're detected
                              (if (string-match "<*>" .definition)
                                  (with-temp-buffer
                                    (shr-insert-document
                                     (with-temp-buffer
                                       (insert .definition)
                                       (libxml-parse-html-region)))
                                    (buffer-string))
                                .definition)))) ;; my changes end
                  (apply #'quick-sdcv--call-process args)
                  "")))
    (if (string-empty-p result)
        quick-sdcv-fail-notify-string
      result)))
(defun quick-sdcv--search-detail (&optional word)
  "Search WORD in `quick-sdcv-dictionary-complete-list'.
The result will be displayed in a buffer."
  (when word
    (let* ((buffer-name (quick-sdcv--get-buffer-name word))
           (buffer (get-buffer buffer-name))
           (refresh (or (not buffer)
                        ;; When the words share the same buffer, always refresh
                        (not quick-sdcv-unique-buffers)))
           (inhibit-read-only t))
      (unless buffer
        (setq buffer (quick-sdcv--get-buffer word)))

      (let ((text (quick-sdcv--search-with-dictionary
                   word
                   quick-sdcv-dictionary-complete-list)))
        (unless text
          (error "The command %s produced no output" quick-sdcv-program))

        (when (buffer-live-p buffer)
          (with-current-buffer buffer
            (when refresh
              (when quick-sdcv-verbose
                (message "[SDCV] Searching..."))
              (erase-buffer)
              (set-buffer-file-coding-system 'utf-8)  ;; Force UTF-8
              (setq quick-sdcv-current-translate-object word)
              (let ((text (quick-sdcv--search-with-dictionary
                           word
                           quick-sdcv-dictionary-complete-list)))
                (insert text))

              (goto-char (point-min))

              (when quick-sdcv-verbose
                (message "[SDCV] Finished searching `%s'."
                         quick-sdcv-current-translate-object)))
            ;; This is the original line.
            ;; (pop-to-buffer buffer)
            ;; my changes start
            ;; Change to showing the results in a popup
            (+eval-display-results-in-popup text)
            ;; Switch to the correct mode in the popup
            ;; as long as the popup has this name
            (with-current-buffer "*doom eval*"
              (quick-sdcv-mode)
              ;; turn off read only mode to avoid blocking other popup windows
              (read-only-mode -1))
            (pop-to-buffer "*doom eval*") ;;my changes end
            ))))))

(use-package sdcv-pure
  :config

  ;; set your dictionaries, see example below,
  (defvar sdcv-simple-dict
    `("~/Dictionaries/stardict/dic/Whittaker")
    "Dictionary to search")
  (defvar sdcv-multiple-dicts
    `(("~/Dictionaries/stardict/dic/Whittaker")
      ;; ("~/Dictionaries/stardict/dic/")
      ;; ("~/Dictionaries/stardict/dic/")
      ;; ("~/Dictionaries/stardict/dic/")
      ("~/Dictionaries/stardict/dic/pape_gr-de-2.4.2"))
    "List of dictionaries to search.")

  ;; keybinding example,
  (global-set-key (kbd "C-c d") 'sdcv-simple-definition)
  (global-set-key (kbd "C-c D") 'sdcv-complete-definition)
  )

(map! :leader
      (:prefix ("l" . "misc")
       :desc "RSS Feeds" "r" #'elfeed
       :desc "EMMS" "e" #'emms
       :desc "irc" "i" #'=irc
       :desc "StarDict Search at point" "d" #'quick-sdcv-search-at-point
       :desc "StarDict Search" "D" #'quick-sdcv-search-input
       :desc "Lookup word at point" "w" #'define-word-at-point
       :desc "Lookup word" "W" #'define-word
       )
      )

;; diogenes
(setq diogenes-path "/home/gabe/diogenes")
;; (require 'diogenes)
;; (setq diogenes-library-path "/path/to/diogenes")
;; (use-package diogenes
;;   :init
;;   (diogenes-path "~/Downloads/usr/local/diogenes")
;;   :bind (("C-c d" . diogenes))
;;   :commands (diogenes-ad-to-ol
;;              diogenes-ol-to-ad
;;              diogenes-utf8-to-beta
;;              diogenes-beta-to-utf8))

;; IRC Chat
(after! circe
  (set-irc-server! "irc.libera.chat"
    `(:tls t
      :port 6697
      :nick "δέλτα"
      :sasl-username "delta_epsilon_lambda_tau_alpha"
      ;; :sasl-username ,(+pass-get-user   "irc/libera.chat")
      ;; :sasl-password ,(+pass-get-secret "irc/libera.chat")
      :channels ("#emacs" "#home-manager"))))

;; Emacs Everywhere
(setq emacs-everywhere-major-mode-function #'org-mode) ; use org mode formatting
  ;;; Emacs Everywhere (Niri/Wayland)
  ;;; see: https://github.com/tecosaur/emacs-everywhere/issues/50
(after! emacs-everywhere
  (require 'ox-gfm)

  ;; Niri IPC
  (defun my-emacs-everywhere/update-niri-socket ()
    "Find and set NIRI_SOCKET (changes between sessions)."
    (let* ((rundir (format "/run/user/%d/" (user-uid)))
           (sockets (when (file-directory-p rundir)
                      (directory-files rundir nil "^niri.*sock$" t)))
           (socket-file (when (consp sockets) (concat rundir (car sockets)))))
      (if socket-file
          (setenv "NIRI_SOCKET" socket-file)
        (message "[emacs-everywhere] Could not find an active niri socket"))))

  (defun emacs-everywhere--app-info-linux-niri ()
    "Return info on the focused window via niri IPC."
    (require 'json)
    (my-emacs-everywhere/update-niri-socket)
    (let* ((json-raw (emacs-everywhere--call "niri" "msg" "-j" "focused-window"))
           (is-err (string-prefix-p "Error" json-raw)))
      (if is-err
          (error "[emacs-everywhere] %s (NIRI_SOCKET=%s)" json-raw (getenv "NIRI_SOCKET"))
        (let-alist (json-read-from-string json-raw)
          (make-emacs-everywhere-app
           :id (if (numberp .id) (number-to-string .id) .id)
           :class .app_id :title .title :geometry nil)))))

  (setq emacs-everywhere-system-configs
        (append emacs-everywhere-system-configs
                '(((wayland . niri)
                   :copy-command ("sh" "-c" "wl-copy < %f")
                   :focus-command ("niri" "msg" "action" "focus-window" "--id" "%w")
                   :info-function emacs-everywhere--app-info-linux-niri))))

  ;; ZZ: call finish directly (evil-save-and-close destroys frame before paste)
  (map! :map emacs-everywhere-mode-map :n "ZZ" #'emacs-everywhere-finish)

  ;; Paste: sleep for async focus transfer before wtype fires
  (defadvice! my/emacs-everywhere-niri-paste-a (&rest _)
    :after #'emacs-everywhere--configure-system
    (when (equal (emacs-everywhere--system-compositor) '(wayland . niri))
      (setq emacs-everywhere--paste-command
            '("sh" "-c" "sleep 0.15 && wtype -M ctrl -k v -m ctrl"))))

  ;; Empty buffer: Ctrl+A BackSpace (wl-copy can't copy empty)
  (defadvice! my/emacs-everywhere-empty-buffer-a (oldfn &optional abort)
    :around #'emacs-everywhere-finish
    (if (and emacs-everywhere-mode (not abort)
             (not (equal emacs-everywhere--contents (buffer-string)))
             (string-empty-p (buffer-string)))
        (let ((emacs-everywhere--paste-command
               '("sh" "-c" "sleep 0.15 && wtype -M ctrl -k a -m ctrl && wtype -k BackSpace")))
          (funcall oldfn abort))
      (funcall oldfn abort)))

  ;; Selection: Ctrl+A Ctrl+C before frame opens, save/restore clipboard
  (defvar my/emacs-everywhere--grabbed-text nil)

  (defadvice! my/emacs-everywhere-grab-input-a (oldfn &rest args)
    :around #'emacs-everywhere
    (setq my/emacs-everywhere--grabbed-text nil)
    (when (equal (emacs-everywhere--system-compositor) '(wayland . niri))
      (let ((saved (with-temp-buffer
                     (when (zerop (call-process "wl-paste" nil '(t nil) nil "--no-newline"))
                       (buffer-string)))))
        (call-process "wl-copy" nil nil nil "--clear")
        (call-process "wtype" nil nil nil "-M" "ctrl" "-k" "a" "-m" "ctrl")
        (sleep-for 0.05)
        (call-process "wtype" nil nil nil "-M" "ctrl" "-k" "c" "-m" "ctrl")
        (sleep-for 0.1)
        (setq my/emacs-everywhere--grabbed-text
              (with-temp-buffer
                (when (zerop (call-process "wl-paste" nil '(t nil) nil "--no-newline"))
                  (buffer-string))))
        (if (and saved (not (string-empty-p saved)))
            (with-temp-buffer
              (insert saved)
              (call-process-region (point-min) (point-max) "wl-copy" nil nil nil))
          (call-process "wl-copy" nil nil nil "--clear"))))
    (apply oldfn args))

  (defun my/emacs-everywhere-insert-selection ()
    "Insert grabbed text on Wayland, or PRIMARY on X11."
    (pcase (car (emacs-everywhere--system-compositor))
      ('wayland
       (when (and my/emacs-everywhere--grabbed-text
                  (not (string-empty-p my/emacs-everywhere--grabbed-text)))
         (insert my/emacs-everywhere--grabbed-text)))
      (_ (when-let ((selection (gui-get-selection 'PRIMARY 'UTF8_STRING)))
           (gui-backend-set-selection 'PRIMARY "")
           (insert selection))))
    (when (and (eq major-mode 'org-mode)
               (emacs-everywhere-markdown-p)
               (executable-find "pandoc"))
      (apply #'call-process-region
             (point-min) (point-max) "pandoc" t t t
             emacs-everywhere-pandoc-md-args)
      (deactivate-mark) (goto-char (point-max)))
    (cond ((bound-and-true-p evil-local-mode) (evil-insert-state))))

  (setq emacs-everywhere-init-hooks
        (mapcar (lambda (h) (if (eq h 'emacs-everywhere-insert-selection)
                                #'my/emacs-everywhere-insert-selection h))
                emacs-everywhere-init-hooks)))
