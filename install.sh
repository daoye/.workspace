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
    else
        DISTRO='unknow'
    fi
}

backup_conf_dir(){
    for n in "${HOME}/.vim" "${HOME}/.config/nvim" "${HOME}/.vim-template-extend" 
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


if [ "$DISTRO" != "Ubuntu" ] && [ "$DISTRO" != "CentOS" ] && [ "$DISTRO" != "Kali" ] && [ "$DISTRO" != "Darwin" ]; then
    echo This script just support ubuntu, centos and macos!!
    exit
fi

root_prex=''
if [ "$(whoami)" != "root" ] && [ "$DISTRO" != "Darwin" ] ; then
    root_prex='sudo'
fi

ROOT=$(cd `dirname $0`; pwd)


# 安装基础库

if [ $DISTRO != "Darwin" ]; then
	eval "${root_prex} ${PM} update -y"
	eval "${root_prex} ${PM} -y install curl git zsh python \
		byacc automake  autoconf m4 libtool perl" 
fi

if [ $DISTRO = "Ubuntu" ]; then

    eval "${root_prex} ${PM} -y install pkg-config apt-transport-https ca-certificates gnupg-agent software-properties-common \
        libevent-dev libncurses5-dev autotools-dev python3 \
        neovim python3-neovim \
        python-dev python3-dev python-pip python3-pip" 

    # 安装docker
    eval "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | ${root_prex} apt-key add -"
    eval "${root_prex} add-apt-repository \"deb [arch=amd64] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/ubuntu $(lsb_release -cs) stable\""

elif [ $DISTRO = "Kali" ]; then
    eval "${root_prex} ${PM} -y install pkg-config apt-transport-https ca-certificates gnupg-agent software-properties-common \
        libevent-dev libncurses5-dev autotools-dev python3 \
        neovim python3-neovim \
        python-dev python3-dev python-pip python3-pip" 

    # 安装docker
    eval "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | ${root_prex} apt-key add -"
    eval "${root_prex} touch /etc/apt/sources.list.d/docker.list"
    eval "echo \"deb [arch=amd64] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/debian/ buster stable\" | ${root_prex} tee /etc/apt/sources.list.d/docker.list"

elif [ $DISTRO = "CentOS" ]; then

    eval "${root_prex} yum install -y epel-release && \
              ${root_prex} yum update -y && \
              ${root_prex} yum install -y yum-utils \
              device-mapper-persistent-data \
              lvm2 which\
              libevent-devel ncurses-devel make \
              neovim python36-neovim python-devel python-pip python36 python36-devel python36-pip
              "
    # 安装docker
    eval "${root_prex} yum remove docker \
              docker-client \
              docker-client-latest \
              docker-common \
              docker-latest \
              docker-latest-logrotate \
              docker-logrotate \
              docker-engine"

    eval "${root_prex} yum-config-manager \
                        --add-repo \
                        https://download.docker.com/linux/centos/docker-ce.repo"

elif [ $DISTRO = "Darwin" ]; then

    brew cask reinstall docker

fi

if [ $DISTRO != "Darwin" ]; then
	eval "${root_prex} ${PM} update -y"
	eval "${root_prex} ${PM} install -y docker-ce docker-ce-cli containerd.io"
fi


# 安装tmux
if [ "$DISTRO" = "Darwin" ]; then
	brew reinstall tmux
else
	eval "${root_prex} rm -rf /tmp/tmux"
	cd /tmp
	git clone https://github.com/tmux/tmux.git
	cd tmux
	./autogen.sh
	eval "${root_prex} ./configure && ${root_prex} make && ${root_prex} make install"
fi


# 安装powerline和字体
pip install --user powerline-status
rm -rf /tmp/fonts
cd /tmp
git clone https://github.com/powerline/fonts.git
cd fonts
eval "${root_prex} ./install.sh"

# 安装virtualenv
pip install --user virtualenv
pip install --user virtualenvwrapper


# 安装.tmux
cd ~
rm -rf ~/.tmux
rm -rf ~/.tmux.conf
git clone https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf

# 安装fzf
rm -rf ~/.fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

cd $ROOT

# 备份文件
#backup_conf_dir
#backup_conf_file

if [ ! -d  ~/.config ]; then
    mkdir -p ~/.config
fi

ln -s -f ${ROOT}/conf/.zshrc.local ~/.zshrc.local

ln -s -f ${ROOT}/vim ~/.config/nvim
ln -s -f ${ROOT}/vim ~/.vim
ln -s -f ${ROOT}/vim/init.vim ~/.vimrc
ln -s -f ${ROOT}/templates ~/.vim-template-extend

ln -s -f ${ROOT}/conf/.tmux.conf.local ~/.tmux.conf.local

# 安装vim插件
nvim -u "${ROOT}/vim/plug.vim" +PlugInstall +qa

#安装oh-my-zsh
rm -rf ~/.oh-my-zsh
git clone https://github.com/ohmyzsh/ohmyzsh.git
echo "y"| ./ohmyzsh/tools/install.sh
rm -rf ohmyzsh

#安装ZSH主题
rm ~/.oh-my-zsh-themes
mkdir ~/.oh-my-zsh-themes
git clone https://github.com/caiogondim/bullet-train.zsh.git ~/.oh-my-zsh-themes/bullet-train.zsh
ln -s -f ~/.oh-my-zsh-themes/bullet-train.zsh/bullet-train.zsh-theme ~/.oh-my-zsh/custom/themes/bullet-train.zsh-theme

#更换主题
sed -i 's/robbyrussell/bullet-train/g' ~/.zshrc
#设置插件
zsh_plugs="git git-flow autopep8 command-not-found common-aliases docker-compose docker fzf tmux urltools vi-mode virtualenv"
sed -i "s/plugins=(git)/plugins=(${zsh_plugs})/g" ~/.zshrc
#加载自定义配置
echo "source ~/.zshrc.local" >> ~/.zshrc

# 切换shell 为zsh
chsh -s $(which zsh)
exec zsh -l
