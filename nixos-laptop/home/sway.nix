{
  config,
  pkgs,
  lib,
  ...
}:
{
  # Sway WM
  # https://wiki.nixos.org/wiki/Sway
  services.gnome-keyring.enable = true;
  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
    # Needed to build without errors when using SwayFX.
    checkConfig = false;
    extraConfig = ''
      # SwayFX options must be configured through extraConfig.
      shadows enable
      corner_radius 11
      blur_radius 7
      blur_passes 2

      # https://wiki.nixos.org/wiki/Sway#Inhibit_swayidle/suspend_when_fullscreen
      # When you use `for_window` the command you give is not executed
      # immediately. It is stored in a list and the command is executed
      # every time a window opens or changes (eg. title) in a way that
      # matches the criteria.

      # inhibit idle for fullscreen apps
      for_window [app_id="^.*"] inhibit_idle fullscreen

      # lock the screen when the laptop lid closes
      exec swayidle -w \
           before-sleep 'swaylock -f -c 000000'

      # set background
      output "*" background ${config.home.homeDirectory}/dotfiles/background-images/totoro.png fill

      # switch to waybar
      bar {
           swaybar_command waybar
      }

      # Stenography engine
      # start Plover
      # exec plover # seems like this needs to be added to the startup section instead
      # rule to hide Plover in scratchpad
      # its app ID is: org.openstenoproject.python3
      for_window [app_id="org.openstenoproject.python3"] move scratchpad
    '';
    wrapperFeatures.gtk = true; # Fixes common issues with GTK 3 apps
    config = rec {
      modifier = "Mod4"; # Super key
      # default terminal
      terminal = "alacritty";
      startup = [
        {
          # Launch Plover stenography engine on start
          command = "plover";
        }
      ];
      # disable swaybar
      bars = [ ];
      input = {
        "type:touchpad" = {
          # Enables or disables tap for specified input device.
          tap = "enabled";
          # Enables or disables natural (inverted) scrolling for the specified input device.
          natural_scroll = "enabled";
          # Enables or disables disable-while-typing for the specified input device.
          dwt = "enabled";
        };
      };
      seat = {
        "*" = {
          # hide mouse cursor after 2 seconds idle
          hide_cursor = "2000";
          # hide mouse cursor when typing
          # hide_cursor = "when-typing enable";
        };
      };
      # use lib.mkOptionDefault to merge with default keybindings
      # otherwise all the defaults are removed
      keybindings =
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in
        lib.mkOptionDefault {
          # Logout menu
          "${modifier}+escape" = "exec wlogout";

          # Rofi
          # Application launcher (drun)
          "${modifier}+d" = "exec rofi -show drun";
          # Window switcher
          "${modifier}+tab" = "exec rofi -show window";
          # Run command
          "${modifier}+space" = "exec rofi -show run";

          # Browser
          "${modifier}+b" = "exec firefox";

          # Emacs
          "${modifier}+e" = "exec ${config.home.homeDirectory}/dotfiles/emacsclient.sh";

          ### Audio and brightness controls and similar
          # Audio Volume Controls (Sink - Output)
          "XF86AudioRaiseVolume" = "exec swayosd-client --output-volume raise";
          "XF86AudioLowerVolume" = "exec swayosd-client --output-volume lower";
          "XF86AudioMute" = "exec swayosd-client --output-volume mute-toggle";

          # Microphone Volume Control (Source - Input)
          "XF86AudioMicMute" = "exec swayosd-client --input-volume mute-toggle";

          # Caps Lock
          "--release Caps_Lock" = "exec swayosd-client --caps-lock";

          # Brightness Controls
          "XF86MonBrightnessUp" = "exec swayosd-client --brightness raise";
          "XF86MonBrightnessDown" = "exec swayosd-client --brightness lower";

          # Media Player Controls
          "XF86AudioPlay" = "exec swayosd-client --playerctl play-pause";
          "XF86AudioNext" = "exec swayosd-client --playerctl next";
        };
    };
  };
  services.swayosd = {
    enable = true;
    # OSD Margin from the top edge, 0.5 would be the screen center. May be from 0.0 - 1.0.
    topMargin = 0.9;
    # For a custom stylesheet file.
    #stylePath = "/etc/xdg/swayosd/style.css";
  };
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        # output = [
        #   "eDP-1"
        #   "HDMI-A-1"
        # ];
        modules-left = [
          "sway/workspaces"
          "sway/mode"
          "wlr/taskbar"
        ];
        modules-center = [
          "sway/window"
          # "custom/hello-from-waybar"
        ];
        modules-right = [
          # "mpd"
          # "custom/mymodule#with-css-id"
          "temperature"
        ];

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
        };
        # "custom/hello-from-waybar" = {
        #   format = "hello {}";
        #   max-length = 40;
        #   interval = "once";
        #   exec = pkgs.writeShellScript "hello-from-waybar" ''
        #     echo "from within waybar"
        #   '';
        # };
      };
    };
  };
  # automatically mount USB drives
  services.udiskie.enable = true;
  # lock screen
  # https://wiki.nixos.org/wiki/Swaylock
  programs.swaylock = {
    enable = true;
    settings = {
      image = "${config.home.homeDirectory}/dotfiles/background-images/kiki.png";
      # scaling = "center";
      color = "808080";
      font-size = 24;
      indicator-idle-visible = false;
      indicator-radius = 100;
      line-color = "ffffff";
      show-failed-attempts = true;
    };
  };
  # idling service
  # https://wiki.nixos.org/wiki/Swayidle
  services.swayidle =
    let
      # Lock command
      lock = "${pkgs.swaylock}/bin/swaylock --daemonize";
      # Sway
      display = status: "${pkgs.sway}/bin/swaymsg 'output * power ${status}'";
    in
    {
      enable = true;
      timeouts = [
        {
          timeout = 15; # in seconds
          command = "${pkgs.libnotify}/bin/notify-send 'Locking in 5 seconds' -t 5000";
        }
        {
          timeout = 20;
          command = lock;
        }
        {
          timeout = 25;
          command = display "off";
          resumeCommand = display "on";
        }
        {
          timeout = 30;
          command = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
      events = [
        {
          event = "before-sleep";
          # adding duplicated entries for the same event may not work
          command = (display "off") + "; " + lock;
        }
        {
          event = "after-resume";
          command = display "on";
        }
        {
          event = "lock";
          command = (display "off") + "; " + lock;
        }
        {
          event = "unlock";
          command = display "on";
        }
      ];
    };
  # application launcher
  programs.rofi = {
    enable = true;
    # package = pkgs.rofi-wayland;
    theme = "Indego";
    font = "monospace 16";
    extraConfig = {
      modes = "drun,run,window";
      show-icons = true;
      terminal = "alacritty";
    };
  };
  # logout menu
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        # action = "loginctl lock-session";
        action = "swaylock";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }
      {
        label = "logout";
        action = "loginctl terminate-user $USER";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
    ];
  };
}
