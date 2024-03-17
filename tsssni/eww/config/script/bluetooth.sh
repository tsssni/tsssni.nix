device=`bluetoothctl devices Connected | head -1 | cut -d ' ' -f3`
if [[ -z "$device" ]] then
  device="No device"
fi
echo $device
