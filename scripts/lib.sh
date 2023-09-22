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
