import window from './window'
import music from './music'
import time from './time'
import { Widget, Astal, Gtk } from 'astal/gtk3'

const bar = new Widget.CenterBox({
    className: 'bar',
    spacing: 0,
    vertical: false,
    halign: Gtk.Align.FILL,
    homogeneous: true,
    startWidget: window,
    centerWidget: music,
    endWidget: time,
})

export default new Widget.Window({
    child: bar,
    name: 'bar',
    anchor: Astal.WindowAnchor.TOP | Astal.WindowAnchor.LEFT | Astal.WindowAnchor.RIGHT,
    exclusivity: Astal.Exclusivity.EXCLUSIVE,
    layer: Astal.Layer.TOP,
    margin: 10,
})
