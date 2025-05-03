const defaultCover: string = `${App.configDir}/dashboard/music/plana.jpeg`
const swapConvertedCover: string[] = [...Array(2)].map((_, idx) => `/tmp/ags/swap-cover-${idx}.png`)

let coverIdx: number = 0
let oldCover: string = defaultCover

const coverVar = Variable(swapConvertedCover[0])
const titleVar = Variable('ブルーアーカイブ')
const artistVar = Variable('プラナ')

Utils.exec([
	'convert', defaultCover,
	'-resize', '40x40',
	swapConvertedCover[coverIdx]
])

const music = Variable('', {
	listen: ['playerctl metadata --format \'{{mpris:artUrl}}${{xesam:title}}${{xesam:artist}}\' -s -F', out => {
		let cover = ' '
		let title = ' '
		let artist = ' '
		if (out.length > 0) [cover, title, artist] = out.split('$')
		
		if (cover.length == 0 || out.length == 0)
			cover = defaultCover
		else if (cover != oldCover) {
			if (cover.startsWith('file://'))
				cover.substring(6)
			else {
				const err = Utils.exec([
					'curl', cover, '-o', '/tmp/ags/cover.png',
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
		Utils.exec([
			'convert', cover,
			'-resize', '40x40',
			swapConvertedCover[coverIdx]
		])
		coverVar.value = swapConvertedCover[coverIdx]

		if (title.length == 0 || out.length == 0)
			title = 'ブルーアーカイブ'
		titleVar.value = title

		if (artist.length == 0 || out.length == 0)
			artist = 'プラナ'
		artistVar.value = artist

		return ''
	}]
})

const coverLabel = Widget.Box({
		className: 'img',
		css: coverVar.bind().transform(path => `background-image: url('${path}');`),
})

const titleLabel = Widget.Label({
		className: 'title',
		truncate: 'end',
		maxWidthChars: 16,
		label: titleVar.bind(),
})

const artistLabel = Widget.Label({
		className: 'artist',
		truncate: 'end',
		maxWidthChars: 16,
		label: artistVar.bind(),
})

export default Widget.Box({
	className: 'music',
	children: [
		coverLabel,
		Widget.Box({
			children: [
				titleLabel,
				artistLabel,
			],
			name: 'music-info',
			vertical: true,
			vpack: 'center',
		})
	],
	name: 'info',
	hpack: 'center',
	vpack: 'center',
	spacing: 5,
})
