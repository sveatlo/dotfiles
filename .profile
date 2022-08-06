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

# gnome keyring
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

# fix kitty slow startup - https://github.com/kovidgoyal/kitty/issues/4292
export __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json

# [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec sway
# [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
# [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec /usr/local/bin/sway-run.sh
