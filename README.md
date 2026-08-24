# .workspace

Personal, cross-platform terminal environment for Windows, Linux, and macOS.
The repository is intentionally small: clone it, run one installer, and keep the
repository as the source of truth for shell, tmux, Neovim, prompt, font, and
Windows Terminal settings.

## What is managed

- Neovim configuration in `config/nvim`
- A standalone Zsh configuration with `fzf`, `zoxide`, and Starship integration
- A plain, mobile-friendly tmux configuration
  - desktop prefix: backtick
  - mobile prefix: `Ctrl-a`
  - `tc`: create or attach the `code` session
  - `tcx`: kill the `code` session
- Platform-specific Starship prompts: full POSIX and compact PowerShell
- A PowerShell profile for native Windows terminals
- JetBrainsMono Nerd Font Mono
- Windows Terminal font and `Workspace Dark` color scheme
- PowerShell 7 as the Windows OpenSSH default shell when SSH Server is installed

Machine-specific secrets do not belong in this repository. Put local Zsh
customizations in `~/.zshrc.local`.

## Install on Linux

```sh
git clone https://github.com/daoye/.workspace.git ~/.workspace
cd ~/.workspace
./install.sh
```

Supported package managers:

- Arch Linux: `pacman`
- Debian, Ubuntu, Kali, Linux Mint, Pop!_OS: `apt`
- Fedora, RHEL, Rocky Linux, AlmaLinux: `dnf`

On WSL, fonts are managed by Windows rather than installed inside the distro.

## Install on macOS

```sh
git clone https://github.com/daoye/.workspace.git ~/.workspace
cd ~/.workspace
./install.sh
```

The installer bootstraps Homebrew when needed and installs the Nerd Font cask.
Select **JetBrainsMono Nerd Font Mono** in the macOS terminal application if it
does not pick up the font automatically.

## Install on Windows

Open PowerShell 7:

```powershell
git clone https://github.com/daoye/.workspace.git "$HOME\.workspace"
Set-Location "$HOME\.workspace"
./install.ps1
```

The Windows installer uses `winget`, creates a Neovim directory junction,
installs managed all-host and current-host PowerShell profiles so legacy prompt
initializers cannot override the workspace prompt, installs the font for the
current user, and merges the managed font and color scheme into Windows Terminal
without replacing unrelated profiles or key bindings. It also configures
OpenSSH to launch the current PowerShell 7 App Execution Alias. OpenSSH
configuration requests UAC elevation only when the registry setting needs to
change.

Restart Windows Terminal after installation.

## Installer options

POSIX:

```sh
./install.sh --no-packages
./install.sh --no-nvim-sync
```

Windows:

```powershell
./install.ps1 -NoPackages
./install.ps1 -NoNeovimSync
```

Both installers are idempotent. Existing unmanaged configuration is moved to a
timestamped `*.backup.YYYYMMDD-HHMMSS` path before the managed configuration is
installed.

## Update

```sh
cd ~/.workspace
git pull --ff-only
./install.sh --no-packages
```

Windows:

```powershell
Set-Location "$HOME\.workspace"
git pull --ff-only
./install.ps1 -NoPackages
```

POSIX configuration is symlinked, so most repository changes are visible
immediately. Reload tmux with either prefix followed by `r`.

## Repository layout

```text
config/
  nvim/             preserved Neovim configuration
  powershell/       native Windows PowerShell profile
  starship/         cross-platform prompt
  tmux/             theme-free tmux configuration
  windows-terminal/ declarative font and color scheme
  zsh/              standalone Zsh configuration
install.ps1         Windows bootstrap and configuration
install.sh          Linux and macOS bootstrap and configuration
```
