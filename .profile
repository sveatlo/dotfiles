#
# This file is supposed to be linked as ~/.zlogin, ~/.zprofile or ~/.profile
#


echo "Welcome back, $(whoami)!"

# export GDK_BACKEND=wayland
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland
export CLUTTER_BACKEND=wayland
export SDL_VIDEODRIVER=wayland
export ECORE_EVAS_ENGINE=wayland_egl
export ELM_ENGINE=wayland_egl
export SAL_USE_VCLPLUGIN=gtk3

export XDG_CURRENT_DESKTOP=Unity

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec sway
# [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
