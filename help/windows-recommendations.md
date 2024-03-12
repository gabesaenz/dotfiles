# Learn Rust
 - [ ] https://www.rust-lang.org/learn
 - [ ] [Easy Rust](https://dhghomon.github.io/easy_rust/Chapter_1.html)
 - [ ] [Exercism](https://exercism.org/tracks/rust)
 - [ ] [LifetimeKata](https://tfpk.github.io/lifetimekata/)
   - Macros:
     - [ ] [MacroKata](https://github.com/tfpk/macrokata)
     - [ ] [The Little Book of Rust Macros](https://veykril.github.io/tlborm/)
 - [ ] [Ratatui](https://ratatui.rs/)
   - [ ] [Ratatui Guides](https://ratatui.rs/tutorials/hello-world/)
 - [ ] [Tauri](https://beta.tauri.app/guides/)
 - [ ] [Sycamore](https://sycamore-rs.netlify.app/docs/getting_started/installation)

# Uninstall manually installed programs then reinstall below
 - [x] rustup
 - [x] git

# Install

## Using winget (see: https://winget.run/):
 - [x] rustup
 - [x] git
 - [x] WindowsTerminal
 - [x] OhMyPosh
 - [x] VisualStudioCode
 - [x] micro (installed via nix on Ubuntu)
 - [ ] Notepad++
 - [x] Neovim (installed via nix on Ubuntu)
 - [ ] Emacs

## Window Tiling Manager
 - [x] [whkd](https://github.com/LGUG2Z/whkd)
   - windows hotkey daemon, used by komorebi
 - [x] [komorebi](https://github.com/LGUG2Z/komorebi)
   - window tiling manager, uses wkhd

## Usability
 - [x] [LittleTips](https://github.com/chenjing1294/LittleTips)
   - displays shortcut keys for the active window
 - [x] [Vimium](https://vimium.github.io/)

## Windows Subsystem for Linux
 - [x] [Install](https://learn.microsoft.com/en-us/windows/wsl/install)
   - [Running Linux commands from Windows and vice versa](https://learn.microsoft.com/en-us/windows/wsl/filesystems#run-linux-tools-from-a-windows-command-line)
   - [Running Linux GUI apps](https://learn.microsoft.com/en-us/windows/wsl/tutorials/gui-apps)

# Configure

## Windows Terminal
 - [x] [Themes](https://windowsterminalthemes.dev/)
 - [YouTube:  Make Windows Terminal look amazing!](https://www.youtube.com/watch?v=AK2JE2YsKto)

## OhMyPosh
 - [x] [Install Fonts](https://ohmyposh.dev/docs/installation/fonts)

## [direnv](https://direnv.net/)
 - [ ] [Install](https://direnv.net/docs/installation.html)

## Notepad++
 - [ ] [Install Nord Theme](https://github.com/nordtheme/notepadplusplus)
 - [ ] Install Catpuccin Theme

## micro
 - [ ] [Install Nord Theme](https://github.com/KiranWells/micro-nord-tc-colors/)
 - [ ] Install Catpuccin Theme

## Visual Studio Code
 - [ ] [Install Nord Theme](https://marketplace.visualstudio.com/items?itemName=arcticicestudio.nord-visual-studio-code)
 - [x] Install Catpuccin Theme

## Neovim
 - [ ] Install Neovide
 - [ ] Install Nord Theme
 - [ ] Install Catpuccin Theme
 - [ ] Work through the tutorial.

## Notepad++
 - [ ] [Install Nord Theme](https://github.com/nordtheme/notepadplusplus)
 - [ ] Install Catpuccin Theme

# Color Palettes
 - [Catpuccin](https://github.com/catppuccin)
 - [Nord](https://www.nordtheme.com/)
 - [Solarized](https://ethanschoonover.com/solarized/)
 - [Gruvbox](https://github.com/morhetz/gruvbox)

# Fonts
 - [Korean Coding Font](https://github.com/naver/d2codingfont)
   - [x] Install (possibly using oh-my-posh font manager or winget?)
   - [x] Use in Windows Terminal
   - [x] Use in other places?
   - This has some spacing issues. Maybe it will work better with WSL.
     - [ ] Install on WSL using nix.

# Change appearance of Windows
 - [Windows 10, more like MacOS...](https://www.youtube.com/watch?v=uCVc-7z-toE)
   - :x: ~~[PowerToys](https://github.com/microsoft/PowerToys?tab=readme-ov-file#via-winget)~~ (not available on older versions of Windows 10)
     - :x: ~~Mac Style Spotlight Search~~
   - [x] [TaskbarX](https://chrisandriessen.nl/taskbarx)
   - [x] [Taskbar Groups](https://github.com/tjackenpacken/taskbar-groups?tab=readme-ov-file#-how-to-download-taskbar-groups)
   - [ ] [QuickLook](https://github.com/QL-Win/QuickLook?tab=readme-ov-file#downloadinstallation)
   - [ ] [Files](https://github.com/files-community/Files)
 - [How to Rice Windows.](https://dev.to/ananddhruv295/how-to-rice-windows-2h12)
 - https://www.ricing.chloechantelle.com/
   - [Examples](https://www.dropbox.com/sh/gnwhuxk3fi9cqdc/AABCPc3tJBnzC0pYS_jY_6Xla/W10?e=1&preview=66.png)
 - [Example](https://imgur.com/gallery/Rsdhm5k)
 - [Example](https://www.reddit.com/r/desktops/comments/u66glg/windows_10_rice_jetblack/)
 - [Ricing Windows in 2020](https://gist.github.com/triplrrr/d2250db71f0b3a93ed60daa65fe5668f)
 - [Rainmeter](https://www.rainmeter.net/)

## Windows 10 Themes
 - [x] [Catpuccin Theme](https://www.youtube.com/watch?v=kvpZx_SP2SM)
   - [Written Instructions](https://github.com/niivu/Windows-10-themes)
   - [Theme Gallery](https://www.deviantart.com/niivu/gallery/89254379/windows-10)

# Install Doom Emacs
 - [ ] [Documentation](https://github.com/doomemacs/doomemacs/blob/master/docs/getting_started.org)
   - [ ] Use [this example](https://github.com/hlissner/dotfiles/blob/master/modules/editors/emacs.nix) as a model for instaling with nix.
 - [ ] Do the vi and emacs tutorials.
 - [ ] Install Nord Theme
 - [ ] Install Catpuccin Theme

# Install Nix
 - [x] [Nix Windows service](https://nixos.org/download#nix-install-windows)
 - [x] [Home Manager](https://nix-community.github.io/home-manager/#sec-install-standalone)
   - :x: Will setting [this](https://nix-community.github.io/home-manager/options.xhtml#opt-programs.home-manager.path) fix the error?
     ```
     programs.home-manager.path = https://github.com/nix-community/home-manager/archive/master.tar.gz;
     ```
   - It's not entirely clear what fixed this in the end but it's working now. Maybe a reset was enough or maybe that variable needed to be temporarily set and then removed.

# Create a dotfiles repository
 - [ ] Create a github account.
   - [ ] Create a new repository for the dotfiles.
   - [ ] Setup account authorization on Windows.
   - [ ] Setup account authorization on WSL.
 - [ ] Create bulk install script for winget.
 - [ ] Create install script for other Windows applications and settings.
 - [ ] Automate WSL configuration.
 - [ ] Add WSL nix config to repository.
 - [ ] Reinstall Windows using the dotfiles repo.
