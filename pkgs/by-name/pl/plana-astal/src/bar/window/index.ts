import logo from './logo'
import window from './window'
import { Widget, Gtk } from 'astal/gtk3'

export default new Widget.Box({
    children: [
        logo,
        window,
    ],
    name: 'info',
    halign: Gtk.Align.START,
    spacing: 2,
})
