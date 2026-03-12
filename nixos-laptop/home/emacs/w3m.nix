{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    w3m
  ];
  doom-config = {
    packages = builtins.readFile ./w3m-packages.el;
    config = builtins.readFile ./w3m-config.el;
  };
  ### add a desktop entry
  # [Desktop Entry]
  # Name=emacs-w3m
  # GenericName=Emacs Web Browser
  # X-GNOME-FullName=Emacs w3m Web Browser

  # Encoding=UTF-8
  # Version=1.0
  # Comment=Using emacsclient
  # NoDisplay=true

  # Exec=emacsclient --eval "(browse-url (replace-regexp-in-string \"'\" \"\" \"%u\"))"

  # Terminal=false
  # X-MultipleArgs=false
  # Type=Application
  # Icon=firefox-esr
  # Categories=Network;WebBrowser;
  # StartupWMClass=Firefox-esr
  # StartupNotify=true
  # MimeType=x-scheme-handler/unknown;x-scheme-handler/about;text/html;text/xml;application/xhtml+xml;application/xml;application/vnd.mozilla.xul+xml;application/rss+xml;application/rdf+xml;image/gif;image/jpeg;image/png;x-scheme-handler/http;x-scheme-handler/https;

  ### set as default browser
  # xdg-settings set default-web-browser emacs-w3m.desktop

}
