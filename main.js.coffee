fs 							= require 'fs'
Probe 					= require "./Probe.js.coffee"

# defaults

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


# launch probe 

probe = new Probe(settings.port)
Probe.set_domains settings.authorized_hosts
probe.start()

probe.listen 'info', (req, res) =>
	app_details = { 
		'name' 		: 'theeye-probes', 
		'version' : 'beta'
	}
	res.send JSON.stringify	(app_details)
	console.log 'app details: ', app_details
	