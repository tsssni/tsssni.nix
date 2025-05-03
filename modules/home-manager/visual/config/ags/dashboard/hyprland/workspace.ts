const hyprland = await Service.import('hyprland')
const numberMap = ['P', 'L', 'A', 'N', 'A']

const workspace = (idx: number) => {
	return Widget.Label({
		className: 'inactive',
		name: 'workspace',
		label: numberMap[idx - 1],
		setup: self => self.hook(hyprland, () => {
			if (hyprland.active.workspace.id == idx)
				self.class_name = 'active'
			else
				self.class_name = 'inactive'
		}),
	})
}


export default Widget.Box({
	className: 'workspace',
	children: [...Array(5)].map((_, i) => workspace(i + 1)),
	name: 'workspaces',
	spacing: 10,
})
