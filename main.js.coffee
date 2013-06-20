fs 							= require 'fs'
Probe 					= require "./Probe.js.coffee"

fs.readdir './probes', (err, files) =>
	for file in files
		require "./probes/" + file
		
probe = new Probe()
probe.start()