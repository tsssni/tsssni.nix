import { Variable } from 'astal'
import { Widget, Gtk } from 'astal/gtk3'
import { exec } from 'astal/process'
import { bind } from 'astal/binding'

let name = ['time', 'title',]

let vars = [
    Variable('').poll(
        1000,
        (_: string) => {
            const now = new Date()

            const time = now.toTimeString().slice(0, 8)
            const date = now.toLocaleDateString('en-US')
            const weekday = ['日','月','火','水','木','金','土'][now.getDay()]+'曜'

            return `${time} ${date} ${weekday}`

        }
    ),
    Variable('').poll(
        100,
        (_: string) => {
            try {
                const output = exec('niri msg -j focused-window').trim()
                return JSON.parse(output).title
            } catch (e) {
                return ''
            }
        }
    ),
];

let children = name.map((n: string, i: number) => {
    return new Widget.Label({
        className: 'window',
        name: n,
        truncate: true,
        maxWidthChars: 64,
        label: bind(vars[i]),
        halign: Gtk.Align.START,
    })
})

let stack = new Widget.Stack({
    className: 'hardware',
    children: children,
    shown: name[0],
    transitionType: Gtk.StackTransitionType.SLIDE_UP_DOWN,
    name: 'window',
})

let index = 0
export default new Widget.Button({
    child: stack,
    onClicked: () => {
        index = (index + 1) % children.length
        stack.shown = name[index]
        children.forEach((_, i) => {
            if (i === index) {
                vars[i].startPoll()
            } else {
                vars[i].stopPoll()
            }
        })
    }
})
