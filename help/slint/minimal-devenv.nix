{
  pkgs,
  # lib,
  # config,
  # inputs,
  ...
}:

{
  packages = with pkgs; [
    ### Slint dependencies
    fontconfig
    wayland # required for winit backend to build
    libxkbcommon # required for winit backend to build
    libGL # required for winit backend or the window won't render
    # pkg-config # not required but might be necessary later?
  ];
  env.LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath (
    with pkgs;
    [
      libxkbcommon
      libGL
      wayland
      # xorg.libX11 # not required but might be necessary later?
    ]
  )}";
  languages.rust = {
    enable = true;
    ### The below options don't work -- possibly because of a nix bug that could be fixed soon.
    # channel = "stable";
    # toolchainFile = ./rust-toolchain.toml;
  };
}
