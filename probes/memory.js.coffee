Probe 					= require "../Probe.js.coffee"
os 							= require 'os'

class MemoryProbe extends Probe

	probe = new Probe {
		path: 				this.name,
		title:				'Memory usage',
		description:	'Monitor memory usage',
	}
	
	probe.listen 'info', (req, res) =>
	
		res.send JSON.stringify	(
			[
				{ 
					'title'				: 'Memory usage',
					'unit'				: '%',
					'uri'					: 'usage',
				},
			]
		)
		
	probe.listen 'usage', (req, res) =>
		used_mem 	= os.totalmem()-os.freemem()
		mem_usage = Math.round( used_mem / os.totalmem() * 100 )
		free_mem 	= Math.round(os.freemem() / 1000000)
		total_mem = Math.round(os.totalmem() / 1000000)
		res.send JSON.stringify	(
			{'value' : mem_usage, 'date' : new Date(),
			'details' : {'free' : free_mem  + ' MB', 'total' : total_mem  + ' MB'}}
		)