eval "${root_prex} ${PM} update -y"
eval "${root_prex} ${PM} -y install curl git zsh python \
byacc automake  autoconf m4 libtool perl ccls ripgrep exuberant-ctags sqlite3 libsqlite3-dev"

brew cask reinstall the_silver_searcher tmux neovim
