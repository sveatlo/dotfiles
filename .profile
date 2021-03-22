#
# This file is supposed to be linked as ~/.zlogin, ~/.zprofile or ~/.profile
#

echo "Welcome back, $(whoami)!"

# set default shell and terminal
export SHELL=/usr/bin/zsh
export TERM=xterm
export TERMINAL_COMMAND='/usr/bin/kitty'

# make default editor Neovim
export EDITOR=nvim

# sway-launcher-desktop with material icons
export GLYPH_DESKTOP="󰄶 "
export GLYPH_COMMAND="󰆍 "

# [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec sway
# [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
