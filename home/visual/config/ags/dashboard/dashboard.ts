import hyprland from './hyprland/hyprland'
import music from './music/music'
import info from './info/info'

const dashboard = Widget.CenterBox({
  className: 'dashboard',
  spacing: 0,
  vertical: false,
  hpack: 'fill',
  homogeneous: true,
  startWidget: hyprland,
  centerWidget: music,
  endWidget: info,
})

export default Widget.Window({
  child: dashboard,
  name: 'dashboard',
  anchor: [ 'top', 'left', 'right' ],
  exclusivity: 'exclusive',
  layer: 'top',
  margins: [10, 10],
})

