connection=`nmcli -t -f NAME c show --active | head -1` 
if [[ -z "$connection" ]] then
  connection="No connection"
fi
echo $connection
