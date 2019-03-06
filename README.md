# vim-feather

## The vim configurations for csharp programmers.

## !!! Important

This is an experimental configuration that will be constantly adjusted to my own usage habits.

# Installation

`curl https://raw.githubusercontent.com/daoye/vim-feather/master/install.sh -L > vim-feather.sh && sh vim-feather.sh`



# Question

## Fix GNOME Terminal background color.

.vimrc

`
if $COLORTERM == 'truecolor'
    set termguicolors
else
    set term=xterm
    set t_Co=256
endif
colorscheme solarized
`

Then modify the color file solarized.vim at line `243` to 

`
if ((has("gui_running") && g:solarized_degrade ==0) || has('termguicolors'))

`
