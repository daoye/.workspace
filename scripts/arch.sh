eval "${root_prex} pacman -Syyu"
eval "${root_prex} pacman -S --needed docker base-devel \
        zsh python3 fd xclip zip unzip curl fzf \
        python-pip ccls ripgrep the_silver_searcher tmux"
