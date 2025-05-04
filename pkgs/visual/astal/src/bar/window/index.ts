import logo from './logo'
import wm from './wm'
import { Widget, Gtk } from 'astal/gtk3'

export default new Widget.Box({
	children: [
		logo,
		wm,
	],
	name: 'info',
	halign: Gtk.Align.FILL,
	spacing: 2,
})
