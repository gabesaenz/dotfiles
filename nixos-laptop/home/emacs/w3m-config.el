;; w3m web browser config

;; https://www.emacswiki.org/emacs/emacs-w3m
(setq browse-url-browser-function 'w3m-browse-url)
(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
;; optional keyboard short-cut
(global-set-key "\C-xm" 'browse-url-at-point)

;; https://github.com/emacs-w3m/emacs-w3m?tab=readme-ov-file
(require 'w3m-load)
(require 'mime-w3m)
