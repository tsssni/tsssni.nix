import { Variable } from 'astal'
import { Widget, Gtk } from 'astal/gtk3'
import { exec } from 'astal/process'
import { bind } from 'astal/binding'

const defaultCover: string = SRC + `/asset/plana.jpg`
const swapConvertedCover: string[] = [...Array(2)].map((_, idx) => `/tmp/ags/swap-cover-${idx}.png`)

let coverIdx: number = 0
let oldCover: string = defaultCover

const coverVar = Variable('')
const titleVar = Variable('')
const artistVar = Variable('')
const updatePlayer = (out: string) => {
    let cover = ''
    let title = ''
    let artist = ''
    if (out.length > 0) [cover, title, artist] = out.split('$')
    
    if (cover.length == 0 || out.length == 0)
        cover = defaultCover
    else if (cover != oldCover) {
        if (cover.startsWith('file://'))
            cover.substring(6)
        else {
            const err = exec([
                'curl', cover,
                '-o', '/tmp/ags/cover.png',
                '-s', '--max-time', '5'
            ])

            if (Number(err) == 0)
                cover = '/tmp/ags/cover.png'
            else
                cover = defaultCover
        }

        oldCover = cover
    }

    coverIdx = (coverIdx + 1) % 2
    exec([
        'convert', cover, '-resize', '40x40',
        swapConvertedCover[coverIdx]
    ])
    coverVar.set(swapConvertedCover[coverIdx])

    if (title.length == 0 || out.length == 0)
        title = 'ブルーアーカイブ'
    titleVar.set(title)

    if (artist.length == 0 || out.length == 0)
        artist = 'プラナ'
    artistVar.set(artist)

    return ''
}


updatePlayer('')
const playerStatusVar = Variable('').watch(
    'playerctl metadata --format \'{{mpris:artUrl}}${{xesam:title}}${{xesam:artist}}\' -s -F',
    updatePlayer
)

const coverLabel = new Widget.Box({
    className: 'img',
    css: bind(coverVar).as(path => `background-image: url('${path}');`),
})

const titleLabel = new Widget.Label({
    className: 'title',
    truncate: true,
    maxWidthChars: 16,
    label: bind(titleVar),
    margin: 2
})

const artistLabel = new Widget.Label({
    className: 'artist',
    truncate: true,
    maxWidthChars: 16,
    label: bind(artistVar),
    margin: 2
})

export default new Widget.Box({
    className: 'music',
    children: [
        coverLabel,
        new Widget.Box({
            children: [
                titleLabel,
                artistLabel,
            ],
            name: 'music-info',
            vertical: true,
            valign: Gtk.Align.CENTER,
        })
    ],
    name: 'info',
    halign: Gtk.Align.FILL,
    valign: Gtk.Align.CENTER,
    spacing: 4,
})
