eval "${root_prex} add-apt-repository ppa:neovim-ppa/stable"

eval "${root_prex} ${PM} -y install pkg-config apt-transport-https ca-certificates gnupg-agent software-properties-common \
    libevent-dev libncurses5-dev autotools-dev python3 \
    neovim python3-neovim \
    python3-dev python3-pip ccls ripgrep silversearcher-ag highlight exuberant-ctags" 

eval "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | ${root_prex} apt-key add -"
eval "${root_prex} add-apt-repository \"deb [arch=amd64] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/ubuntu $(lsb_release -cs) stable\""

eval "${root_prex} ${PM} update -y"
eval "${root_prex} ${PM} install -y docker-ce docker-ce-cli containerd.io"
