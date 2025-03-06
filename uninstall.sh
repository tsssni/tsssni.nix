for i in $(seq 1 32); do
  sudo userdel nixbld$i
done
sudo groupdel nixbld
