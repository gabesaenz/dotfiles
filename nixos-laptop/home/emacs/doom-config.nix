{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.doom-config = {
    init = lib.mkOption {
      type = lib.types.lines;
    };
    custom = lib.mkOption {
      type = lib.types.lines;
    };
    packages = lib.mkOption {
      type = lib.types.lines;
    };
    config = lib.mkOption {
      type = lib.types.lines;
    };
    config-org = lib.mkOption {
      type = lib.types.lines;
    };
    theme = lib.mkOption {
      type = lib.types.lines;
    };
  };
  config.doom-config = {
    init = builtins.readFile ./doom/init.el;
    custom = builtins.readFile ./doom/custom.el;
    packages = builtins.readFile ./doom/packages.el;
    config = builtins.readFile ./doom/config.el;
    config-org = builtins.readFile ./doom/config.org;
    theme = builtins.readFile ./doom/themes/doom-base16-theme.el;
  };
}
