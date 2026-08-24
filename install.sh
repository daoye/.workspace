#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d-%H%M%S)"
INSTALL_PACKAGES=1
SYNC_NVIM=1

log() {
    printf '[workspace] %s\n' "$*"
}

fail() {
    printf '[workspace] error: %s\n' "$*" >&2
    exit 1
}

usage() {
    cat <<'EOF'
Usage: ./install.sh [--no-packages] [--no-nvim-sync]

  --no-packages   Link configuration without installing system packages.
  --no-nvim-sync  Skip the initial lazy.nvim plugin synchronization.
EOF
}

while (($#)); do
    case "$1" in
        --no-packages) INSTALL_PACKAGES=0 ;;
        --no-nvim-sync) SYNC_NVIM=0 ;;
        -h|--help) usage; exit 0 ;;
        *) fail "unknown option: $1" ;;
    esac
    shift
done

SUDO=()
if ((INSTALL_PACKAGES)) && [[ "$(uname -s)" == "Linux" ]] && [[ ${EUID:-$(id -u)} -ne 0 ]]; then
    if command -v sudo >/dev/null 2>&1; then
        SUDO=(sudo)
    else
        fail "sudo is required to install packages"
    fi
fi

backup_path() {
    local target="$1"
    if [[ -e "$target" || -L "$target" ]]; then
        local backup="${target}.backup.${STAMP}"
        log "backing up $target -> $backup"
        mv "$target" "$backup"
    fi
}

link_managed() {
    local source="$1"
    local target="$2"

    if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
        log "already linked: $target"
        return
    fi

    mkdir -p "$(dirname "$target")"
    backup_path "$target"
    ln -s "$source" "$target"
    log "linked $target -> $source"
}

install_starship() {
    if command -v starship >/dev/null 2>&1; then
        return
    fi
    mkdir -p "$HOME/.local/bin"
    log "installing starship"
    curl -fsSL https://starship.rs/install.sh | sh -s -- -y -b "$HOME/.local/bin"
}

install_zoxide() {
    if command -v zoxide >/dev/null 2>&1; then
        return
    fi
    log "installing zoxide"
    curl -fsSL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
}

install_neovim_release() {
    if command -v nvim >/dev/null 2>&1 &&
        nvim --version | head -n 1 | grep -Eq 'NVIM v(0\\.([1-9][0-9])|[1-9][0-9]*)'; then
        return
    fi

    local machine asset archive temp extracted
    machine="$(uname -m)"
    case "$machine" in
        x86_64|amd64) asset="nvim-linux-x86_64.tar.gz" ;;
        aarch64|arm64) asset="nvim-linux-arm64.tar.gz" ;;
        *) fail "unsupported Neovim architecture: $machine" ;;
    esac

    temp="$(mktemp -d)"
    archive="$temp/$asset"
    log "installing current Neovim release"
    curl -fL "https://github.com/neovim/neovim/releases/latest/download/$asset" -o "$archive"
    tar -xzf "$archive" -C "$temp"
    extracted="${archive%.tar.gz}"

    mkdir -p "$HOME/.local/opt" "$HOME/.local/bin"
    rm -rf "$HOME/.local/opt/nvim"
    mv "$extracted" "$HOME/.local/opt/nvim"
    ln -sfn "$HOME/.local/opt/nvim/bin/nvim" "$HOME/.local/bin/nvim"
    rm -rf "$temp"
}

install_linux_font() {
    if [[ -n ${WSL_DISTRO_NAME:-} ]] || grep -qi microsoft /proc/version 2>/dev/null; then
        log "WSL detected; Windows Terminal owns the font"
        return
    fi
    if command -v fc-list >/dev/null 2>&1 && fc-list : family | grep -Fqi "JetBrainsMono Nerd Font Mono"; then
        log "JetBrainsMono Nerd Font Mono is already installed"
        return
    fi

    local temp destination
    temp="$(mktemp -d)"
    destination="$HOME/.local/share/fonts/JetBrainsMonoNerdFont"
    log "installing JetBrainsMono Nerd Font Mono"
    curl -fL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip -o "$temp/JetBrainsMono.zip"
    unzip -q "$temp/JetBrainsMono.zip" -d "$temp/font"
    mkdir -p "$destination"
    cp "$temp"/font/JetBrainsMonoNerdFontMono-*.ttf "$destination/"
    fc-cache -f "$destination" >/dev/null
    rm -rf "$temp"
}

install_packages_linux() {
    [[ -r /etc/os-release ]] || fail "cannot detect Linux distribution"
    # shellcheck disable=SC1091
    . /etc/os-release

    case "${ID:-}" in
        arch|archarm)
            "${SUDO[@]}" pacman -Syu --needed --noconfirm \
                base-devel ca-certificates curl fd fontconfig fzf git neovim \
                ripgrep starship tmux unzip zoxide zsh
            ;;
        debian|ubuntu|kali|linuxmint|pop)
            "${SUDO[@]}" apt-get update
            "${SUDO[@]}" apt-get install -y \
                build-essential ca-certificates curl fd-find fontconfig fzf git \
                ripgrep tmux unzip zsh
            mkdir -p "$HOME/.local/bin"
            if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
                ln -sfn "$(command -v fdfind)" "$HOME/.local/bin/fd"
            fi
            install_neovim_release
            install_starship
            ;;
        fedora|rhel|centos|rocky|almalinux)
            "${SUDO[@]}" dnf install -y \
                ca-certificates curl fd-find fontconfig fzf git neovim ripgrep \
                tmux unzip zsh
            install_starship
            ;;
        *) fail "unsupported Linux distribution: ${ID:-unknown}" ;;
    esac

    install_zoxide
    install_linux_font
}

install_packages_macos() {
    if ! command -v brew >/dev/null 2>&1; then
        log "installing Homebrew"
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        if [[ -x /opt/homebrew/bin/brew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -x /usr/local/bin/brew ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    fi

    brew install fd fzf git neovim ripgrep starship tmux zoxide zsh
    if ! brew list --cask font-jetbrains-mono-nerd-font >/dev/null 2>&1; then
        brew install --cask font-jetbrains-mono-nerd-font
    fi
}

if ((INSTALL_PACKAGES)); then
    case "$(uname -s)" in
        Linux) install_packages_linux ;;
        Darwin) install_packages_macos ;;
        *) fail "use install.ps1 on Windows" ;;
    esac
fi

command -v zsh >/dev/null 2>&1 || fail "zsh is not installed"
command -v tmux >/dev/null 2>&1 || fail "tmux is not installed"
command -v nvim >/dev/null 2>&1 || fail "neovim is not installed"

link_managed "$ROOT/config/nvim" "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
link_managed "$ROOT/config/tmux/tmux.conf" "$HOME/.tmux.conf"
link_managed "$ROOT/config/zsh/zshrc" "$HOME/.zshrc"
link_managed "$ROOT/config/starship/starship.toml" "${XDG_CONFIG_HOME:-$HOME/.config}/starship.toml"

zsh_path="$(command -v zsh)"
if [[ "$(basename "${SHELL:-}")" != "zsh" ]]; then
    log "changing login shell to $zsh_path"
    chsh -s "$zsh_path" || log "run manually: chsh -s $zsh_path"
fi

if ((SYNC_NVIM)); then
    log "synchronizing Neovim plugins"
    nvim --headless "+Lazy! sync" +qa
fi

log "installation complete; start a new shell or run: exec zsh -l"
