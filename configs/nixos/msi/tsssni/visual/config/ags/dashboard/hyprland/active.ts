const hyprland = await Service.import('hyprland')

const icon = Widget.Icon({
  className: 'icon',
  name: 'icon',
  icon: 'window',
  size: 40,
  setup: self => self.hook(hyprland, () => {
    const icon = hyprland.active.client.class
    if (Utils.lookUpIcon(icon)) {
      self.icon = icon
      self.visible = true
    }
    else
      self.visible = false
  }),
})

const app = Widget.Label({
  className: 'app',
  name: 'app',
  label: 'None',
  truncate: 'end',
  maxWidthChars: 64,
  setup: self => self.hook(hyprland, () => {
    self.label = hyprland.active.client.title
  }),
})

export default Widget.Box({
  children: [
    icon,
    app,
  ],
  spacing: 5,
})
