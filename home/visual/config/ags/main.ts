import dashboard from './dashboard/dashboard'

const scss = `${App.configDir}/main.scss`
const css = '/tmp/ags/main.css'
await Utils.execAsync(['sass', scss, css])

App.applyCss(css)

App.config({
  windows: [
    dashboard
  ],
})
