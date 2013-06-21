Probe 					= require "../Probe.js.coffee"
os 							= require 'os'

class MemoryProbe extends Probe

	probe = new Probe()
	
	probe.listen 'memory', (req, res) =>
		used_mem 	= os.totalmem()-os.freemem()
		mem_usage = Math.round( used_mem / os.totalmem() * 100 )
		free_mem 	= Math.round(os.freemem() / 1000000)
		total_mem = Math.round(os.totalmem() / 1000000)
		res.send JSON.stringify	(
			{'value' : mem_usage, 'date' : new Date(),
			'details' : {'free' : free_mem  + ' MB', 'total' : total_mem  + ' MB'}}
		)