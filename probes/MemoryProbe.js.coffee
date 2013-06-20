Probe 					= require "../Probe.js.coffee"
os 							= require 'os'

class MemoryProbe extends Probe

	probe = new Probe()
	
	probe.listen 'memory', (req, res) =>
		used_mem = os.totalmem()-os.freemem()
		mem_usage = Math.round( used_mem / os.totalmem() * 100 )
		json = {'value' : mem_usage, 'date' : new Date()}		
		res.send(JSON.stringify(json))