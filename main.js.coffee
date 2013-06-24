fs 							= require 'fs'
Probe 					= require "./Probe.js.coffee"

config_file			=	"config/config.json"

# load probes 

fs.readdir './probes', (err, files) =>
	for file in files
		require "./probes/" + file

# create and lauch server
	
try 
	settings = JSON.parse(fs.readFileSync(config_file, encoding="ascii"))
catch
	console.log 'config file is missing, using defaults'
	settings = {
		"port"							: "1337",
		"authorized_hosts" 	: "http://localhost:3000 http://127.0.0.1:3000" 	
		}


console.log 'config: ', settings
probe = new Probe(settings.port)
Probe.set_domains settings.authorized_hosts
probe.start()