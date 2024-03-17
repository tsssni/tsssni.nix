case $1 in
  -H )
    date "+ %H" | sed 's/ //g'
    ;;
  -M )
    date "+ %M" | sed 's/ //g'
    ;;
  -S )
    date "+ %S" | sed 's/ //g'
    ;;
  -Y )
    date "+ %Y" | sed 's/ //g'
    ;;
  -m )
    date "+ %m" | sed 's/ //g'
    ;;
  -d )
    date "+ %d" | sed 's/ //g'
    ;;
  -a )
    date "+ %a" | sed 's/ //g'
    ;;
esac
