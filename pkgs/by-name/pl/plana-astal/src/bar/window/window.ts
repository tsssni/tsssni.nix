import { Variable } from 'astal'
import { Widget, Gtk } from 'astal/gtk3'
import { exec } from 'astal/process'
import { bind } from 'astal/binding'

let title = Variable('').poll(
    100,
    (_: string) => {
        try {
            const output = exec('niri msg -j focused-window').trim()
            return JSON.parse(output).title
        } catch (e) {
            return ''
        }
    }
)

export default new Widget.Label({
    className: 'window',
    name: 'title',
    truncate: true,
    maxWidthChars: 64,
    label: bind(title),
    halign: Gtk.Align.START,
})
