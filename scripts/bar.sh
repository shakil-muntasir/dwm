#!/bin/sh

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
. ~/.config/chadwm/scripts/bar_themes/catppuccin

xsetroot -name "Howdy, $(whoami)!"

cpu() {
  cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

  printf "^c$black^ ^b$green^ CPU"
  printf "^c$white^ ^b$grey^ $cpu_val"
}

pkg_updates() {
  # updates=$(doas xbps-install -un | wc -l) # void
  updates=$(checkupdates | wc -l)   # arch , needs pacman contrib
  # updates=$(aptitude search '~U' | wc -l)  # apt (ubuntu,debian etc)

  if [ "$updates" -gt 0 ]; then
    printf "^c$green^  $updates"" Updates"
  else
    printf "^c$green^  Fully Updated"
  fi
}

battery() {
  get_capacity="$(cat /sys/class/power_supply/BAT0/capacity)"
  printf "^c$blue^   $get_capacity"
}

brightness() {
  # Modified
  max=$(cat /sys/class/backlight/*/max_brightness)
  min=0
  current=$(cat /sys/class/backlight/*/brightness)
  percentage=$(((current-min)*100/(max-min)))

  printf "^c$red^   "
  printf "^c$red^%.0f\n" $percentage

  # Default
  # printf "^c$red^   "
  # printf "^c$red^%.0f\n" $(cat /sys/class/backlight/*/brightness)
}

mem() {
  printf "^c$blue^^b$black^  "
  printf "^c$blue^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

wlan() {
  # Modified
  # To show Wi-Fi SSID, sudo pacman -S wireless_tools
  case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
  up) printf "^c$black^ ^b$blue^ 󰤨 ^d^%s" " ^c$blue^$(iwgetid -r)" ;;
  down) printf "^c$black^ ^b$blue^ 󰤭 ^d^%s" " ^c$blue^Disconnected" ;;
  esac

  # Default
  # case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
  # up) printf "^c$black^ ^b$blue^ 󰤨 ^d^%s" " ^c$blue^Connected" ;;
  # down) printf "^c$black^ ^b$blue^ 󰤭 ^d^%s" " ^c$blue^Disconnected" ;;
  # esac
}

clock() {
	printf "^c$black^ ^b$darkblue^ 󱑆 "
	printf "^c$black^^b$blue^ $(date '+%I:%M %p') "
}

while true; do

  [ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] && updates=$(pkg_updates)
  interval=$((interval + 1))

  sleep 1 && xsetroot -name "$updates $(battery) $(brightness) $(cpu) $(mem) $(wlan) $(clock)"
done
