# Installation


    cd ~
    git clone https://github.com/daoye/.workspace.git
    cd .workspace
    ./install.sh




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


sdfds
sdfsdf
    
