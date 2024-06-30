class HardwareMonitor {
  usage = Variable('0%')
  freq = Variable('0MHz')
  power = Variable('0W')
  temp = Variable('0°C')
  mem = Variable('0/0MiB')

  script = Variable('')

  constructor(hardware: string) {
    this.script = Variable(hardware, {
      poll: [1000, `python ${App.configDir}/dashboard/info/${hardware}.py`, out => {
        [
          this.usage.value,
          this.freq.value,
          this.power.value,
          this.temp.value,
          this.mem.value,
        ] = out.split(' ')
        return hardware;
      }]
    })
  }
}

const ryzenMonitor = new HardwareMonitor('ryzen')
const raphaelMonitor = new HardwareMonitor('raphael')
const nvidiaMonitor = new HardwareMonitor('nvidia')

function hardwareBox(monitor: HardwareMonitor) {
  return Widget.Box({
    children: [
      Widget.Label({
        className: 'type',
        name: monitor.script.value,
        label: monitor.script.value.toUpperCase() + ':',
      }),
      Widget.Label({
        className: 'usage',
        name: `${monitor.script.value}.usage`,
        label: monitor.usage.bind(),
      }),
      Widget.Label({
        className: 'freq',
        name: `${monitor.script.value}.freq`,
        label: monitor.freq.bind(),
      }),
      Widget.Label({
        className: 'power',
        name: `${monitor.script.value}.power`,
        label: monitor.power.bind(),
      }),
      Widget.Label({
        className: 'temp',
        name: `${monitor.script.value}.temp`,
        label: monitor.temp.bind(),
      }),
      Widget.Label({
        className: 'mem',
        name: `${monitor.script.value}.mem`,
        label: monitor.mem.bind(),
      }),
    ],
    name: monitor.script.value,
    hpack: 'end',
    spacing: 10,
  })
}

let stack = Widget.Stack({
  attribute: 0,
  className: 'hardware',
  children: {
    ryzen: hardwareBox(ryzenMonitor),
    raphael: hardwareBox(raphaelMonitor),
    nvidia: hardwareBox(nvidiaMonitor),
  },
  shown: 'ryzen',
  transition: 'slide_up_down',
  name: 'hardware',
})

export default Widget.Button({
  child: stack,
  onClicked: () => {
    stack.attribute = (stack.attribute + 1) % 3

    if (stack.attribute == 0) {
      stack.shown = 'ryzen'
      ryzenMonitor.script.startPoll()
      if (raphaelMonitor.script.is_polling) raphaelMonitor.script.stopPoll()
      if (nvidiaMonitor.script.is_polling) nvidiaMonitor.script.stopPoll()
    } else if (stack.attribute == 1) {
      stack.shown = 'raphael'
      if (ryzenMonitor.script.is_polling) ryzenMonitor.script.stopPoll()
      raphaelMonitor.script.startPoll()
      if (nvidiaMonitor.script.is_polling) nvidiaMonitor.script.stopPoll()
    } else {
      stack.shown = 'nvidia'
      if (ryzenMonitor.script.is_polling) ryzenMonitor.script.stopPoll()
      if (raphaelMonitor.script.is_polling) raphaelMonitor.script.stopPoll()
      nvidiaMonitor.script.startPoll()
    }
  }
})
