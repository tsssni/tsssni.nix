eww="eww -c $HOME/.config/eww"
image_dir="$HOME/.config/eww/picture"

case $1 in
  --cover )
    old_cover=`$eww get art-url`
    cover=`playerctl metadata mpris:artUrl 2> /dev/null`
    if [[ -z "$cover" ]] then
      cover="file://$image_dir/plana.jpeg"
    fi

    if [[ "$cover" != "$old_cover" ]] then
      $eww update art-url=$cover

      if [[ `echo $cover | grep -c "file://"` -gt 0 ]] then
        cover=`echo $cover | sed 's/file:\/\///g'`
      else
        curl $cover -o "/tmp/cover.png" -s --max-time 5
        if [[ $? -eq 0 ]] then
          cover="/tmp/cover.png"
        else
          cover="$image_dir/plana.jpeg"
        fi
      fi

      convert "$cover" -resize 40x40 "$image_dir/lores-cover.png"
      convert "$cover" -resize 200x200 -filter Lanczos "$image_dir/hires-cover.png"
    fi

    case $2 in
      --lores )
        echo $image_dir/lores-cover.png
        ;;
      --hires )
        echo $image_dir/hires-cover.png
        ;;
      --style )
        echo "
        background-image: url('picture/hires-cover.png');
        background-repeat: no-repeat;
        border-radius: 10px;
        "
    esac
    ;;
  --title )
    title=`playerctl metadata xesam:title 2> /dev/null`
    if [[ -z "$title" ]] then
      title="ブルーアーカイブ"
    fi
    echo $title
    ;;
  --artist )
    artist=`playerctl metadata xesam:artist 2> /dev/null`
    if [[ -z "$artist" ]] then
      artist="プラナ"
    fi
    echo $artist
    ;;
  --get-position )
    position=`playerctl position 2> /dev/null`
    if [[ -z "$position" ]] then
      position="0.0"
    fi
    echo $position
    ;;
  --set-position )
    seekt=$2
    playerctl position $seekt 2> /dev/null
    ;;
  --length )
    length=`playerctl metadata mpris:length 2> /dev/null`
    if [[ -z "$length" ]] then
      length="0.0"
    fi
    length=`python -c "print($length/1000000)"`
    echo $length
    ;;
  --icon )
    status=`playerctl status 2> /dev/null`
    if [[ "$status" == "Playing" ]] then
      echo 󰏤
    else [[ "$status" == "Pause" ]]
      echo 󰐊
    fi
    ;;
  --toggle )
    playerctl play-pause 2> /dev/null
    ;;
  --prev )
    playerctl previous 2> /dev/null
    ;;
  --next )
    playerctl next 2> /dev/null
    ;;
esac
