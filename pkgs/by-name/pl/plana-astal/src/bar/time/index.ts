import { Variable } from 'astal'
import { Widget, Gtk } from 'astal/gtk3'
import { exec } from 'astal/process'
import { bind } from 'astal/binding'

let time = Variable('').poll(
    1000,
    (_: string) => {
        const now = new Date()
        const time = now.toTimeString().slice(0, 8)
        const date = now.toLocaleDateString('en-US')
        return `${time} ${date}`
    }
)

export default new Widget.Label({
    className: 'window',
    name: 'time',
    truncate: true,
    maxWidthChars: 64,
    label: bind(time),
    halign: Gtk.Align.END,
})
