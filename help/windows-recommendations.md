# Command Line
 - [ ] [Tutorials](./command-line.md)

# Git
 - [ ] [Tutorials](./git.md)

# Databases
 - [ ] [Relational Databases](./databases.md)

# Learn Rust
 - [ ] https://www.rust-lang.org/learn
   - [ ] [Rust Book](https://doc.rust-lang.org/book/)
   - [ ] [Rust by Example](https://doc.rust-lang.org/rust-by-example/)
   - [ ] [Rustlings](https://github.com/rust-lang/rustlings/)
   - [ ] [Rust Command Line Book](https://rust-cli.github.io/book/index.html)
   - [ ] Further Reading
     - [ ] [The Little Book of Rust Books](https://lborb.github.io/book/title-page.html)
 - [ ] [Easy Rust](https://dhghomon.github.io/easy_rust/Chapter_1.html)
 - [ ] [Exercism](https://exercism.org/tracks/rust)
 - [ ] CodeCrafters
   - [ ] [Rust Primer](https://app.codecrafters.io/collections/rust-primer)
   - [ ] [Rust Track](https://app.codecrafters.io/tracks/rust)
 - [ ] [LifetimeKata](https://tfpk.github.io/lifetimekata/)
 - [ ] Macros:
   - [ ] [MacroKata](https://github.com/tfpk/macrokata)
   - [ ] [The Little Book of Rust Macros](https://veykril.github.io/tlborm/)
 - [ ] [Ratatui](https://ratatui.rs/)
   - [ ] [Ratatui Guides](https://ratatui.rs/tutorials/hello-world/)
 - [ ] [Tauri](https://beta.tauri.app/guides/)
 - [ ] [Sycamore](https://sycamore-rs.netlify.app/docs/getting_started/installation)
 - [ ] [Command Line Rust](https://github.com/kyclark/command-line-rust)

# Install

## Using winget (see: https://winget.run/):
 - [ ] rustup
 - [ ] git
 - [ ] WindowsTerminal
 - [ ] OhMyPosh
 - [ ] VisualStudioCode
 - [ ] micro (installed via nix on Ubuntu)
 - [ ] Notepad++
 - [ ] Neovim (installed via nix on Ubuntu)
 - [ ] Emacs

## Window Tiling Manager
 - [ ] [whkd](https://github.com/LGUG2Z/whkd)
   - windows hotkey daemon, used by komorebi
 - [ ] [komorebi](https://github.com/LGUG2Z/komorebi)
   - window tiling manager, uses wkhd

## Usability
 - [ ] [LittleTips](https://github.com/chenjing1294/LittleTips)
   - displays shortcut keys for the active window
 - [ ] [Vimium](https://vimium.github.io/)

## Windows Subsystem for Linux
 - [ ] [Install](https://learn.microsoft.com/en-us/windows/wsl/install)
   - [Running Linux commands from Windows and vice versa](https://learn.microsoft.com/en-us/windows/wsl/filesystems#run-linux-tools-from-a-windows-command-line)
     - Programs installed using nix home-manager aren't being found using "wsl app-name" from Windows.
       - I think wsl runs as root and home-manager needs the related user.
         - Does this have anything to do with nix multi-user vs. single-user or wsl with systemd?
       - [x] Try using "wsl --exec ..." or "wsl --user ...".
       - [x] Try switching to flakes.
       - [x] Check if programs installed using the nix system config work.
         - [x] If so, maybe stop using home-manager?
       - Looks like this was fixed by switching to multi-user. Works out of the box with NixOS.
   - [Running Linux GUI apps](https://learn.microsoft.com/en-us/windows/wsl/tutorials/gui-apps)
 - Microsoft Store Apps to help with integration but that cost money:
   - [ ] [GWSL - Native UI and shortcuts - 5 Euros](https://apps.microsoft.com/detail/9nl6kd1h33v3?hl=en-us&gl=US)
   - [ ] [OpenInWSL - file associations - 3 Euros](https://apps.microsoft.com/detail/9ngmqpwcg7sf?cid=storebadge&ocid=badge&rtc=1&hl=en-us&gl=DE)

# Configure

## Windows Terminal
 - [ ] [Themes](https://windowsterminalthemes.dev/)
 - [YouTube:  Make Windows Terminal look amazing!](https://www.youtube.com/watch?v=AK2JE2YsKto)

## OhMyPosh
 - [ ] [Install Fonts](https://ohmyposh.dev/docs/installation/fonts)

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
 - [ ] Install Catpuccin Theme

## Neovim
 - [ ] Work through the tutorial
   - [ ] [Vim Adventures](https://vim-adventures.com/)
   - [ ] [Vim Tutor & Vim School](https://vimschool.netlify.app/introduction/vimtutor/)
   - [ ] [Vim Tutor Sequel](https://github.com/micahkepe/vimtutor-sequel)
   - [ ] ["Wonderful vi" article](https://world.hey.com/dhh/wonderful-vi-a1d034d3)
 - [ ] Install Neovide
 - [ ] Install Nord Theme
 - [ ] Install Catpuccin Theme

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
   - [ ] Install (possibly using oh-my-posh font manager or winget?)
   - [ ] Use in Windows Terminal
   - [ ] Use in other places?
   - This has some spacing issues. Maybe it will work better with WSL.
     - [ ] Install on WSL using nix.

# Change appearance of Windows
 - [Windows 10, more like MacOS...](https://www.youtube.com/watch?v=uCVc-7z-toE)
   - :x: ~~[PowerToys](https://github.com/microsoft/PowerToys?tab=readme-ov-file#via-winget)~~ (not available on older versions of Windows 10)
     - :x: ~~Mac Style Spotlight Search~~
   - [ ] [TaskbarX](https://chrisandriessen.nl/taskbarx)
   - [ ] [Taskbar Groups](https://github.com/tjackenpacken/taskbar-groups?tab=readme-ov-file#-how-to-download-taskbar-groups)
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
 - [ ] [Catpuccin Theme](https://www.youtube.com/watch?v=kvpZx_SP2SM)
   - [Written Instructions](https://github.com/niivu/Windows-10-themes)
   - [Theme Gallery](https://www.deviantart.com/niivu/gallery/89254379/windows-10)

# Install Doom Emacs
 - [ ] [Documentation](https://github.com/doomemacs/doomemacs/blob/master/docs/getting_started.org)
   - [ ] Use [this example](https://github.com/hlissner/dotfiles/blob/master/modules/editors/emacs.nix) as a model for instaling with nix.
 - [ ] Do the vi and emacs tutorials
   - [ ] [A Guided Tour of Emacs](https://www.gnu.org/software/emacs/tour/)
     - [ ] Emacs Tutor (ctrl-h + t)
       - or (ctrl-u + ctrl-h + t) to select the language for the tutorial
       - or run this from the command line: emacs --quick --funcall menu-bar-mode --funcall help-with-tutorial-spec-language
   - [ ] [Master Emacs in one year](https://github.com/redguardtoo/mastering-emacs-in-one-year-guide/blob/master/guide-en.org)
   - [ ] [Practical Emacs Tutorial](http://xahlee.info/emacs/emacs/emacs.html)
 - [ ] [DoomCasts](https://youtube.com/playlist?list=PLhXZp00uXBk4np17N39WvB80zgxlZfVwj&si=R7f5pFLBDKds9l33)
    - **Warning**: the install instructions are out of date. Install first then watch.
    - In general there is out of date information but it's a nice helpful visual guide. Follow along with the explanations and see how they actually work in the editor.
    - In context menus press ? to get a full list of options. Up and Down can navigate these lists or C-j and C-k.
 - [ ] Install Nord Theme
 - [ ] Install Catpuccin Theme

# Install Nix
 - [ ] [Nix Windows service](https://nixos.org/download#nix-install-windows)
 - [ ] [Home Manager](https://nix-community.github.io/home-manager/#sec-install-standalone)
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
