Probe 					= require "../Probe.js.coffee"
os 							= require 'os'

class LoadAvgProbe extends Probe
	
	probe = new Probe()
		
		
	# get current times for cpus
	
	fetch_load_avg = =>
		
		load_avg 	= os.loadavg()
		cpus	=	os.cpus().length
		
		return {
			'value'						: (load_avg[0] / cpus).toFixed(2)
			'date' 						: new Date() 
			'details'					: {
				'cpus' 						: cpus
				'last_minute' 		: load_avg[0].toFixed(2)
				'last_5_minutes'	: load_avg[1].toFixed(2)
				'last_15_minutes'	: load_avg[2].toFixed(2)
			}
		}		
		
	probe.listen 'loadavg', (req, res) =>
		
		res.send JSON.stringify	(
			fetch_load_avg()
		)
		
		