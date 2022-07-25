#!/usr/bin/env bash

set -u # set -o nounset 禁止使用未初始化变量 
set -e # set -o errexit 发生任何非0返回时，停止执行后续脚本

set_dist_name() {
    if [ "$(uname)" = "Darwin" ];then
        DISTRO='Darwin'
        PM='brew'
    elif grep -Eqi "CentOS" /etc/issue || grep -Eq "CentOS" /etc/*-release; then
        DISTRO='CentOS'
        PM='yum'
    elif grep -Eqi "Red Hat Enterprise Linux Server" /etc/issue || grep -Eq "Red Hat Enterprise Linux Server" /etc/*-release; then
        DISTRO='RHEL'
        PM='yum'
    elif grep -Eqi "Aliyun" /etc/issue || grep -Eq "Aliyun" /etc/*-release; then
        DISTRO='Aliyun'
        PM='yum'
    elif grep -Eqi "Fedora" /etc/issue || grep -Eq "Fedora" /etc/*-release; then
        DISTRO='Fedora'
        PM='yum'
    elif grep -Eqi "Debian" /etc/issue || grep -Eq "Debian" /etc/*-release; then
        DISTRO='Debian'
        PM='apt'
    elif grep -Eqi "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release; then
        DISTRO='Ubuntu'
        PM='apt'
    elif grep -Eqi "Raspbian" /etc/issue || grep -Eq "Raspbian" /etc/*-release; then
        DISTRO='Raspbian'
        PM='apt'
    elif grep -Eqi "Kali" /etc/issue || grep -Eq "Kali" /etc/*-release; then
        DISTRO='Kali'
        PM='apt'
    elif grep -Eqi "Arch" /etc/issue || grep -Eq "Arch" /etc/*-release; then
        DISTRO='Arch'
        PM='pacman'
    elif grep -Eqi "openSUSE" /etc/issue || grep -Eq "openSUSE" /etc/*-release; then
        DISTRO='openSUSE'
        PM='yzpper'
    else
        DISTRO='unknow'
    fi
}

backup_conf_dir(){
    for n in "${HOME}/.vim" "${HOME}/.config/nvim" 
    do
        if [ -d $n ]; then
            cp -r $n ${n}backup
            rm -rf $n
        fi

        if [ -L $n ]; then
            rm $n
        fi
    done
}

backup_conf_file(){

    for n in "${HOME}/.vimrc" "${HOME}/.tmux.conf.local" "${HOME}/.zshrc.local"
    do
        if [ -f $n ]; then
            cp -r $n ${n}backup
            rm -rf $n
        fi

        if [ -L $n ]; then
            rm $n
        fi
    done

}

cmd_exists(){

    for n in "${HOME}/.vimrc" "${HOME}/.tmux.conf.local" "${HOME}/.zshrc.local"
    do
        if [ -f $n ]; then
            cp -r $n ${n}backup
            rm -rf $n
        fi

        if [ -L $n ]; then
            rm $n
        fi
    done

}


set_dist_name


if [ "$DISTRO" != "Ubuntu" ] && [ "$DISTRO" != "Kali" ] && [ "$DISTRO" != "Darwin" ] && [ "$DISTRO" != "Arch" ]&& [ "$DISTRO" != "openSUSE" ]; then
    echo This script just support ubuntu, kali, arch, openSUSE and macos!!
    exit
fi

root_prex=''
if [ "$(whoami)" != "root" ] && [ "$DISTRO" != "Darwin" ] ; then
    root_prex='sudo'
fi

ROOT=$(cd `dirname $0`; pwd)

# Install base libraries

if [ $DISTRO = "Ubuntu" ]; then
    eval "${root_prex} add-apt-repository ppa:neovim-ppa/stable"

    eval "${root_prex} ${PM} -y install pkg-config apt-transport-https ca-certificates gnupg-agent software-properties-common \
        libevent-dev libncurses5-dev autotools-dev python3 \
        neovim python3-neovim \
        python3-dev python3-pip ccls ripgrep silversearcher-ag highlight exuberant-ctags" 

    eval "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | ${root_prex} apt-key add -"
    eval "${root_prex} add-apt-repository \"deb [arch=amd64] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/ubuntu $(lsb_release -cs) stable\""

    eval "${root_prex} ${PM} update -y"
    eval "${root_prex} ${PM} install -y docker-ce docker-ce-cli containerd.io"
elif [ $DISTRO = "Kali" ]; then
    eval "${root_prex} ${PM} -y install pkg-config apt-transport-https ca-certificates gnupg-agent software-properties-common \
        libevent-dev libncurses5-dev autotools-dev python3 \
        neovim python3-neovim \
        python3-dev python3-pip ccls ripgrep silversearcher-ag highlight exuberant-ctags" 

    eval "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | ${root_prex} apt-key add -"
    eval "${root_prex} touch /etc/apt/sources.list.d/docker.list"
    eval "echo \"deb [arch=amd64] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/debian/ buster stable\" | ${root_prex} tee /etc/apt/sources.list.d/docker.list"

    eval "${root_prex} ${PM} update -y"
    eval "${root_prex} ${PM} install -y docker-ce docker-ce-cli containerd.io"
elif [ $DISTRO = "Arch" ]; then
    eval "${root_prex} pacman -Syyu"
    eval "${root_prex} pacman -S --needed docker base-devel \
            zsh python fd xclip zip unzip curl \
            neovim \
            python-pip ccls ripgrep the_silver_searcher"
elif [ $DISTRO = "openSUSE" ]; then
    eval "${root_prex} yzpper dup -y"
    eval "${root_prex} yzpper in -y docker \
            zsh python fd xclip zip unzip curl \
            neovim \
            python310-pip ccls ripgrep the_silver_searcher"
elif [ $DISTRO != "Darwin" ]; then
    eval "${root_prex} ${PM} update -y"
    eval "${root_prex} ${PM} -y install curl git zsh python \
	byacc automake  autoconf m4 libtool perl ccls ripgrep exuberant-ctags sqlite3 libsqlite3-dev" 

    brew cask reinstall docker the_silver_searcher tmux neovim
fi


# Install tmux
eval "${root_prex} rm -rf /tmp/tmux"
cd /tmp
git clone https://github.com/tmux/tmux.git
cd tmux
./autogen.sh
eval "${root_prex} ./configure && ${root_prex} make && ${root_prex} make install"

#pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple pip -U
pip3 config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# Install powerline
# pip3 install --user powerline-status
#rm -rf /tmp/fonts
#cd /tmp
#git clone https://github.com/powerline/fonts.git
#cd fonts
#eval "${root_prex} ./install.sh"

# Install virtualenv
pip3 install --user virtualenv
pip3 install --user virtualenvwrapper
pip3 install --user pynvim

# Install sdkman
# curl -sSL "https://get.sdkman.io" -o /tmp/sdkman.sh
# bash /tmp/sdkman.sh
# rm -rf /tmp/sdkman.sh
#
# source ${HOME}/.sdkman/bin/sdkman-init.sh
#
# # Install java
# sdk i java 18-zulu
# sdk use java 18-zulu

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


cd $ROOT

# backup
#backup_conf_dir
#backup_conf_file

if [ ! -d  ~/.config ]; then
    mkdir -p ~/.config
fi

ln -s -f ${ROOT}/conf/.zshrc.local ~/.zshrc.local

# Only support neovim.
ln -s -f ${ROOT}/vim ~/.config/nvim
# ln -s -f ${ROOT}/vim ~/.vim
# ln -s -f ${ROOT}/vim/init.vim ~/.vimrc
# ln -s -f ${ROOT}/templates ~/.vim-template-extend

ln -s -f ${ROOT}/conf/.tmux.conf.local ~/.tmux.conf.local

# Vim plugin install
nvim -u "${ROOT}/vim/plug.vim" +PlugInstall +UpdateRemotePlugins +"TSInstall all" +qa
nvim +"LspInstall cssls eslint html pyright tsserver vimls jdtls omnisharp sumneko_lua jsonls" +qa
# Install vimspector adapter
# nvim -u "${ROOT}/vim/plug.vim" +"VimspectorInstall --all --force-all" +qa


#Install oh-my-zsh
rm -rf ~/.oh-my-zsh
rm -rf ohmyzsh
git clone https://github.com/ohmyzsh/ohmyzsh.git
echo "y"| ./ohmyzsh/tools/install.sh
rm -rf ohmyzsh

##安装ZSH主题
#rm -rf ~/.oh-my-zsh-themes
#mkdir ~/.oh-my-zsh-themes
#git clone https://github.com/caiogondim/bullet-train.zsh.git ~/.oh-my-zsh-themes/bullet-train.zsh
#ln -s -f ~/.oh-my-zsh-themes/bullet-train.zsh/bullet-train.zsh-theme ~/.oh-my-zsh/custom/themes/bullet-train.zsh-theme
#
##更换主题
#sed -i 's/robbyrussell/bullet-train/g' ~/.zshrc
##设置插件
#zsh_plugs="git git-flow autopep8 command-not-found common-aliases docker-compose docker fzf tmux urltools vi-mode virtualenv"
#sed -i "s/plugins=(git)/plugins=(${zsh_plugs})/g" ~/.zshrc

# Load custom zsh conf
echo "source ~/.zshrc.local" >> ~/.zshrc

# Install fzf
rm -rf ~/.fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

# Change shell
chsh -s $(which zsh)
exec zsh -l
