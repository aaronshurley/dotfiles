# dotfiles
Setup for a new Mac. Largely inspired by [mathiasbyens](https://github.com/mathiasbynens/dotfiles).

## Install
```bash
./install.sh
```

## Update MacOS Preferences
This is a one-time setup and doesn't run as part of `bootstrap.sh`. Restart machine for some changes to take effect.
```bash
./.macos
```

## Add Tools or Apps
Using [Homebrew](https://brew.sh/), edit `Brewfile` and then `./bootstrap.sh`.

## Patterns
- idempotent install
- non-destructive, when possible
- Use brew to install, when possible
- [nvim](https://neovim.io/) with [luan's vimfiles](https://github.com/luan/vimfiles)
