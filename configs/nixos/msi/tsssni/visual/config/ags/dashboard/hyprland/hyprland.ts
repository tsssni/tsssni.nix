import logo from './logo'
import workspace from './workspace'
import active from './active'

export default Widget.Box({
  children: [
    logo,
    workspace,
    active,
  ],
  name: 'info',
  hpack: 'start',
  spacing: 5,
})
