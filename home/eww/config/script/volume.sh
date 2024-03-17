eww="eww -c $HOME/.config/eww/dashboard"

get_volume () {
  volume=`wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2}'`
  volume=`python -c "print($volume/0.01)"`
  echo $volume
}

set_volume () {
  wpctl set-volume @DEFAULT_AUDIO_SINK@ $1%
}

case $1 in
  --get )
    get_volume
    ;;
  --set )
    set_volume $2
    ;;
esac
