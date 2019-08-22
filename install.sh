#!/usr/bin/env bash

set -u # set -o nounset 禁止使用未初始化变量 
set -e # set -o errexit 发生任何非0返回时，停止执行后续脚本

get_dist_name() {
    if [ "$(uname)" == "Darwin" ];then
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
    else
        DISTRO='unknow'
    fi
}

get_dist_name


if [ $DISTRO != "Ubuntu" ] && [ $DISTRO != "CentOS" ] && [ $DISTRO != "Darwin" ]; then
    echo This script just support ubuntu, centos and macos!!
    exit
fi

root_prex=''
if [ "$(whoami)" != "root" ]; then
    root_prex='sudo'
fi

ROOT=$(cd `dirname $0`; pwd)

# 安装基础库
eval "${root_prex} ${PM} update -y"
eval "${root_prex} ${PM} -y install curl git zsh python python3 python-dev python3-dev python-pip python3-pip \
                neovim python3-neovim libevent-dev ncurses-dev \
                byacc automake autotools-dev autoconf m4 libtool perl pkg-config" 

# 安装docker
# if [ ! -n "$1" ] || [ $1 != "--nodocker" ]; then
    if [ $DISTRO = "Ubuntu" ]; then

        eval "${root_prex} ${PM} -y install apt-transport-https ca-certificates gnupg-agent software-properties-common" 
        eval "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | ${root_prex} apt-key add -"
        eval "${root_prex} add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\""

    elif [ $DISTRO == "CentOS" ]; then

        eval "${root_prex} yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine"

        eval "${root_prex} yum install -y yum-utils \
                  device-mapper-persistent-data \
                  lvm2"

        eval "${root_prex} yum-config-manager \
                            --add-repo \
                            https://download.docker.com/linux/centos/docker-ce.repo"

    elif [ $DISTRO == "Darwin" ]; then

        brew install docker-ce

    fi

    eval "${PM} update -y"
    eval "${root_prex} ${PM} install -y docker-ce docker-ce-cli containerd.io"

    # 启动ssclient
    # eval "${root_prex} docker run "
# fi


# 安装tmux

if [ $DISTRO = "Darwin" ]; then
	brew install tmux
else
	rm -rf /tmp/tmux
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

cd $ROOT
# 初始化第三方依赖
git submodule init
git submodule update



for n in "${HOME}/.vim" "${HOME}/.vimrc" "${HOME}/.config/nvim" "${HOME}/.vim-template-extend" "${HOME}/.tmux.conf.local" "${HOME}/.zshrc.local"
do
	if [ -d $n ]; then
		cp -r $n ${n}backup
		rm -rf $n
	fi

	if [ -L $n ]; then
		rm $n
	fi
done

for n in "${HOME}/.tmux.conf.local" "${HOME}/.zshrc.local"
do
	if [ -f $n ]; then
		cp -r $n ${n}backup
		rm -rf $n
	fi

	if [ -L $n ]; then
		rm $n
	fi
done

echo "source \${HOME}/.zshrc.local" >> ~/.zshrc

ln -s -f ${ROOT}/conf/.zshrc.local ~/.zshrc.local

ln -s -f ${ROOT}/vim ~/.config/nvim
ln -s -f ${ROOT}/vim ~/.vim
ln -s -f ${ROOT}/vim/init.vim ~/.vimrc

ln -s -f ${ROOT}/tmuxcnf/.tmux.conf ~/.tmux.conf
ln -s -f ${ROOT}/tmux/.tmux.conf.local ~/.tmux.conf.local

ln -s -f ${ROOT}/templates ~/.vim-template-extend

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "Install successfull."
