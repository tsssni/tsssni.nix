import { Variable } from 'astal'
import { Widget } from 'astal/gtk3'
import { bind } from 'astal/binding'

const timeVar = Variable('').poll(
	1000,
	(_: string) => {
		const now = new Date()

		const time = now.toTimeString().slice(0, 8)
		const weekday = ['月','火','水','木','金','土','日'][now.getDay()]+'曜'
		const date = now.toLocaleDateString('en-US')

		return `${time} ${weekday} ${date}`

	}
)

export default new Widget.Label({
	className: 'time',
	label: bind(timeVar),
})
