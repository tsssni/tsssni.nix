source "$(blesh-share)"/ble.sh --attach=none

[[ ${BLE_VERSION-} ]] && ble-attach
