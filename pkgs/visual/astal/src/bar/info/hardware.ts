import { Variable } from 'astal'
import { Widget, Gtk } from 'astal/gtk3'
import { exec } from 'astal/process'
import { bind } from 'astal/binding'

const prefix = `python ${SRC}/bar/info/`
const props = ['usage', 'freq', 'power', 'temp', 'mem']
const initial = ['0%', '0MHz', '0W', '0°C', '0/0MiB']

class HardwareMonitor {
	[key: string]: Variable<string>
	monitor: Variable<string>
	hardware: Variable<string>
	device: Variable<string>
	name: Variable<string>

	constructor(hardware: string, index: string) {
		props.forEach((v, i) => { this[v] = Variable(initial[i]) })
		this.hardware = Variable(hardware)
		this.device = Variable(index)
		this.name = Variable('')
		this.monitor = Variable(hardware).poll(
			1000,
			prefix + `${hardware}.py -m ${index}`,
			(out: string) => {
				const info = out.split(' ')
				info.forEach((v, i) => { this[props[i]].set(v) })
				return hardware;
			}
		)
	}
}

const hardware = ['cpu', 'amd', 'nvidia']
let detect = (hardware: string) => {
	const output = exec(prefix + `${hardware}.py -d`).trim()
	return output ? output.split(',').map(
		(device: string) => new HardwareMonitor(hardware, device.trim())
	) : []
}
let monitors = hardware.flatMap(detect)

function hardwareBox(monitor: HardwareMonitor) {
	const widgets = props.map(p => new Widget.Label({
		className: p,
		name: `${monitor.monitor.get()}.${p}`,
		label: bind(monitor[p]),
	}))

	const name = monitor.hardware.get() + ' ' + monitor.device.get()
	monitor.name.set(name)
	return new Widget.Box({
		children: [
			new Widget.Label({
				className: 'type',
				name: 'hardware',
				label: name.toUpperCase() + ':',
			}),
		].concat(widgets),
		name: name,
		halign: Gtk.Align.END,
		spacing: 10,
	})
}

let stack = new Widget.Stack({
	className: 'hardware',
	children: monitors.map(m => hardwareBox(m)),
	shown: 'cpu z',
	transitionType: Gtk.StackTransitionType.SLIDE_UP_DOWN,
	name: 'hardware',
})

let index = 0
export default new Widget.Button({
	child: stack,
	onClicked: () => {
		index = (index + 1) % monitors.length
		stack.shown = monitors[index].name.get()
		monitors.forEach((m, i) => {
			if (i === index) {
				m.monitor.startPoll()
			} else {
				m.monitor.stopPoll()
			}
		})
	}
})
