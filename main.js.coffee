fs 							= require 'fs'
Probe 					= require "./Probe.js.coffee"


# load probes 

fs.readdir './probes', (err, files) =>
	for file in files
		require "./probes/" + file

# create and lauch server
		
probe = new Probe('1337')
probe.start()