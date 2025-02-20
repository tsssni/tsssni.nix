const main = "/tmp/ags/main.js"
const entry = `${App.configDir}/main.ts`

try {
	await Utils.execAsync([
		'bun', 'build', entry,
		'--outfile', main,
		'--external', 'resource://*',
		'--external', 'gi://*',
		'--external', 'file://*',
	]);

	await import(`file://${main}`)
} catch (error) {
	console.error(error)
	App.quit()
}

export { }
