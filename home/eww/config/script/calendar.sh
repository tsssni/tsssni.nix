eww="eww -c $HOME/.config/eww/dashboard"
date="$HOME/.config/eww/dashboard/script/date.sh"
$eww close calendar || $eww open calendar
$eww update year=`$date -Y`
$eww update month=`$date -m`
$eww update day=`$date -d`
