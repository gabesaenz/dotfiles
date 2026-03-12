{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    w3m
  ];
  doom-config = {
    packages = builtins.readFile ./w3m-packages.el;
    config = builtins.readFile ./w3m-config.el;
  };
  # doesn't do much unless it's also the default browser (which it isn't currently) so commenting this out
  # xdg.desktopEntries = {
  #   "emacs-w3m" = {
  #     name = "emacs-w3m";
  #     genericName = "Emacs Web Browser";
  #     comment = "Using emacsclient";
  #     noDisplay = true;
  #     exec = ''emacsclient --eval "(browse-url (replace-regexp-in-string \"'\" \"\" \"%u\"))"'';
  #     terminal = false;
  #     settings = {
  #       X-GNOME-FullName = "Emacs w3m Web Browser";
  #       Encoding = "UTF-8";
  #       Version = "1.0";
  #       X-MultipleArgs = "false";
  #       StartupWMClass = "Firefox-esr";
  #     };
  #     type = "Application";
  #     icon = "firefox-esr";
  #     categories = [
  #       "Network"
  #       "WebBrowser"
  #     ];
  #     startupNotify = true;
  #     mimeType = [
  #       "x-scheme-handler/unknown"
  #       "x-scheme-handler/about"
  #       "text/html"
  #       "text/xml"
  #       "application/xhtml+xml"
  #       "application/xml"
  #       "application/vnd.mozilla.xul+xml"
  #       "application/rss+xml"
  #       "application/rdf+xml"
  #       "image/gif"
  #       "image/jpeg"
  #       "image/png"
  #       "x-scheme-handler/http"
  #       "x-scheme-handler/https"
  #     ];
  #   };
  # };
  # set as default browser
  # don't do this since it removes all other existing defaultApplication settings
  # xdg.mimeApps = {
  #   enable = true;
  #   defaultApplications = {
  #     "text/html" = "emacs-w3m.desktop";
  #     "x-scheme-handler/http" = "emacs-w3m.desktop";
  #     "x-scheme-handler/https" = "emacs-w3m.desktop";
  #     "x-scheme-handler/about" = "emacs-w3m.desktop";
  #     "x-scheme-handler/unknown" = "emacs-w3m.desktop";
  #   };
  # };
}
