import logo from './logo'
import time from './time'
import { Widget, Gtk } from 'astal/gtk3'

export default new Widget.Box({
	children: [
		logo,
		time,
	],
	name: 'info',
	halign: Gtk.Align.FILL,
	spacing: 2,
})
