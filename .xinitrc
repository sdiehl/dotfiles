#!/bin/bash

xsetroot -cursor_name left_ptr
exec ck-launch-session dbus-launch --exit-with-session xmonad
xbindkeys
feh --bg-scale ~/Downloads/haskell.png
toggle_caps off
unclutter -idle 1

autocutsel -fork &
autocutsel -selection PRIMARY -fork &
