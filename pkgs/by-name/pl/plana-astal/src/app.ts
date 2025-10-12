import { App } from 'astal/gtk3'
import bar from './bar'
import scss from './main.scss'

App.start({
    css: scss,
    main() {
        bar
    },
})
