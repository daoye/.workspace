#!/usr/bin/env bash

set -u # set -o nounset 禁止使用未初始化变量 
set -e # set -o errexit 发生任何非0返回时，停止执行后续脚本

. ./scripts/lib.sh

set_dist_name

if [ "$DISTRO" != "Ubuntu" ] && [ "$DISTRO" != "Kali" ] && [ "$DISTRO" != "Darwin" ] && [ "$DISTRO" != "Arch" ]&& [ "$DISTRO" != "openSUSE" ]; then
    echo Unsupported this distro.
    exit
fi

root_prex=''
if [ "$(whoami)" != "root" ] && [ "$DISTRO" != "Darwin" ] ; then
    root_prex='sudo'
fi

ROOT=$(cd `dirname $0`; pwd)


. ./scripts/${DISTRO,,}.sh

# Set pip mirror
pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple


# Install nvm
curl https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh -o /tmp/nvm.sh

bash /tmp/nvm.sh
rm -rf /tmp/nvm.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install --lts
npm install -g neovim

# Install Tmux conf
cd ~
rm -rf ~/.tmux
rm -rf ~/.tmux.conf
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf


# Install fzf
rm -rf ~/.fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

# Link configs
cd $ROOT

if [ ! -d  ~/.config ]; then
    mkdir -p ~/.config
fi

# Link zsh
ln -s -f ${ROOT}/conf/.zshrc.local ~/.zshrc.local
# Link tmux
ln -s -f ${ROOT}/conf/.tmux.conf.local ~/.tmux.conf.local
# Link nvim
ln -s -f ${ROOT}/vim ~/.config/nvim

# Initlize nvim
nvim -u "Lazy install" +qa

# Install oh-my-zsh
rm -rf ~/.oh-my-zsh
rm -rf ohmyzsh
git clone https://github.com/ohmyzsh/ohmyzsh.git
echo "y" | ./ohmyzsh/tools/install.sh
rm -rf ohmyzsh

# Load custom zsh conf
echo "source ~/.zshrc.local" >> ~/.zshrc


# Change shell
chsh -s $(which zsh)
exec zsh -l
