eww="eww -c $HOME/.config/eww/dashboard"

get_brightness () {
  brightnessctl g
}

set_brightness () {
  brightnessctl s $1%
}

case $1 in
  --get )
    get_brightness
    ;;
  --set )
    set_brightness $2
    ;;
esac

