Probe 					= require "../Probe.js.coffee"
os 							= require 'os'

class CPUProbe extends Probe
	
	probe = new Probe()
		
	probe.listen 'cpu', (req, res) =>
		
		cpus = os.cpus()
		
		for cpu in cpus
			console.log cpu.times
			
		json = {'value' : 'a', 'date' : new Date()}		
		res.send(JSON.stringify(json))