#!/bin/sh

xrdb merge ~/.Xresources 
xbacklight -set 50 &
# feh --bg-fill ~/Pictures/wallpaper.png &
setwal &
xset r rate 300 25 &
picom &


# Running the bar script and DWM

~/.config/dwm/scripts/./bar.sh &
while type dwm >/dev/null; do dwm && continue || break; done
