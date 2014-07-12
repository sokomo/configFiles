
#!/bin/sh

#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)
#

# Common tools
export GTK_IM_MODULE='uim'
export QT_IM_MODULE="uim"
export XMODIFIERS='@im=uim'

#export XMODIFIERS='uim'
uim-xim &
# uim-toolbar-gtk3 &
uim-toolbar-gtk3-systray &
#/usr/bin/nm-applet &
/usr/bin/pulseaudio --start &
#xcompmgr -c -f -D 5 &
/usr/bin/xscreensaver -no-splash &
compton -b
/usr/bin/xbindkeys
tint2 &
# Wallpaper
nitrogen --restore &
# guake &

# Awesome
#xmodmap -e "keycode 133 = Super_L" -e "add mod4 = Super_L"
#exec awesome

# Compiz
# tint2 &
# cairo-dock &
# exec dbus-launch compiz ccp

# Enlightenment
# exec dbus-launch enlightenment_start

# Blackbox
# exec blackbox

# Openbox
#exec openbox-session
#exec ck-launch-session dbus-launch openbox
exec openbox --startup

# Fluxbox
# exec fluxbox

# Ratpoison
# exec ratpoison


#exec dbus-launch awesome

#export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

#DEFAULT_SESSION=xfce4-session
#case $1 in
#  xfce) exec dbus-launch xfce4-session ;;
#  awesome) exec awesome ;;
#  *) exec dbus-launch  $DEFAULT_SESSION ;;
#esac
