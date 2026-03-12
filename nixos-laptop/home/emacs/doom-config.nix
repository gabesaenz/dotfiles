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
    init = lib.mkBefore (builtins.readFile ./doom/init.el);
    custom = lib.mkBefore (builtins.readFile ./doom/custom.el);
    packages = lib.mkBefore (builtins.readFile ./doom/packages.el);
    config = lib.mkBefore (builtins.readFile ./doom/config.el);
    config-org = lib.mkBefore (builtins.readFile ./doom/config.org);
    theme = lib.mkBefore (builtins.readFile ./doom/themes/doom-base16-theme.el);
  };
}
