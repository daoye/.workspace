#!/bin/bash

ROOT=$(cd `dirname $0`; pwd)

for n in "${HOME}/.vim" "${HOME}/.vimrc" "${HOME}/.config/nvim" "${HOME}/.vim-template-extend"
do
	if [ -d $n ]; then
		cp -r $n ${n}backup
		rm -rf $n
	fi

	if [ -L $n ]; then
		rm $n
	fi
done

ln -s ${ROOT}/vim ~/.config/nvim
ln -s ${ROOT}/vim ~/.vim
ln -s ${ROOT}/vim/init.vim ~/.vimrc
ln -s ${ROOT}/templates ~/.vim-template-extend


#pip install pynvim
#pip install neovim

#if [ "$(uname)"=="Darwin" ];then
#	brew install -y tmux
#elif [ "$(expr substr $(uname -s) 1 5)"=="Linux" ];then
#	sudo apt -y install tmux
#fi

echo "Install successfull."
