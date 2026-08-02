{
  config,
  pkgs,
  lib,
  ...
}:
{
  ### DankMaterialShell (DMS)
  programs.dms-shell = {
    enable = true;
    systemd = {
      enable = true; # Systemd service for auto-start
      restartIfChanged = true; # Auto-restart dms.service when dms-shell changes
    };
    # Core features
    enableSystemMonitoring = true; # System monitoring widgets (dgop)
    enableVPN = true; # VPN management widget
    enableDynamicTheming = true; # Wallpaper-based theming (matugen)
    enableAudioWavelength = true; # Audio visualizer (cava)
    enableCalendarEvents = true; # Calendar integration (khal)
    enableClipboardPaste = true; # Pasting from the clipboard history (wtype)
  };

  ### DMS Greeter
  services.displayManager.dms-greeter = {
    enable = true;
    compositor = {
      name = "niri"; # Required. Can be also "hyprland" or "sway"
      # Optional custom compositor configuration
      customConfig = ''
        input {
          keyboard {
            // Enable numlock on startup, omitting this setting disables it.
            numlock
          }

          touchpad {
            tap
            natural-scroll
          }
        }

        cursor {
          hide-when-typing
          // Hide the cursor after one second of inactivity.
          hide-after-inactive-ms 1000
        }

        hotkey-overlay {
          // Disable the "Important Hotkeys" pop-up at startup.
          skip-at-startup
        }
      '';
    };

    # Sync your user's DankMaterialShell theme with the greeter. You'll probably want this
    configHome = "${config.users.users.gabe.home}";

    # Custom config files for non-standard config locations
    # configFiles = [
    #   "/home/yourusername/.config/DankMaterialShell/settings.json"
    # ];

    # Save the logs to a file
    logs = {
      save = true;
      path = "/tmp/dms-greeter.log";
    };

    # Custom Quickshell Package
    # quickshell.package = pkgs.quickshell;
  };
}
