import hardware from './hardware'
import { Widget, Gtk } from 'astal/gtk3'

export default new Widget.Box({
    children: [
        hardware,
    ],
    name: 'info',
    halign: Gtk.Align.END,
    spacing: 4,
})
