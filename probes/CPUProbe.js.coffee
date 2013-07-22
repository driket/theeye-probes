Probe 					= require "../Probe.js.coffee"
os 							= require 'os'

class CPUProbe extends Probe
	
	probe = new Probe('cpu')
		
	probe.listen 'info', (req, res) =>
	
		res.send JSON.stringify	(
			[
				{ 
					'title'				: 'CPU Usage',
					'unit'				: '%',
					'uri'					: 'all',
				},
			]
		)

	probe.listen 'all', (req, res) =>
		
		# get current cpu times
		
		old_times = fetch_cpus_times()
		
		
		# get new cpu times after 1 second
		
		setTimeout =>
			
			new_times = fetch_cpus_times()
			elapsed_times = diff_times old_times, new_times
			
			# send json with monitored value + details

			res.send JSON.stringify	(
				probe_format (percent_times (elapsed_times))
			)
		, 1000
	
		
	# get current times for cpus
	
	fetch_cpus_times = =>
		
		user 		= 0
		nice		= 0
		sys			= 0
		idle		= 0
		irq			= 0
		
		cpus = os.cpus()
		
		for cpu in cpus
			user 	+= cpu.times.user
			nice 	+= cpu.times.nice
			sys 	+= cpu.times.sys
			idle	+= cpu.times.idle		
			irq		+= cpu.times.irq
		
		return {
			'user' 	: user,
			'nice' 	: nice,
			'sys' 	: sys,
			'idle' 	: idle,
			'irq' 	: irq,
			'total' : user + nice + sys + idle + irq,
			'date' 	: new Date() 
		}		
	
		
	# get elapsed times 
	
	diff_times = (old_times, new_times) =>
		
		return {
			'user' 	: new_times.user 	- old_times.user,
			'nice' 	: new_times.nice 	- old_times.nice,
			'sys' 	: new_times.sys 	- old_times.sys,
			'idle' 	: new_times.idle 	- old_times.idle,
			'irq' 	: new_times.irq 	- old_times.irq,
			'total' : new_times.total - old_times.total,
			'date' 	: new Date() 
		}	
		
		
	# get cpu usage in percent from total time
		
	percent_times = (times) =>
		
		return {
			'user' 	: Math.round (times.user / times.total * 100)
			'nice' 	: Math.round (times.nice / times.total * 100)
			'sys' 	: Math.round (times.sys  / times.total * 100)
			'idle' 	: Math.round (times.idle / times.total * 100)
			'irq' 	: Math.round (times.irq  / times.total * 100)	
			'date' 	: times.date
		}	
	
	
	# format for the-eye classic graph
		
	probe_format = (times) =>
		
		return {
			'value' 	: times.user + times.nice + times.sys + times.irq
			'details'	: {
				'user' 	: times.user 	+ "%"
				'nice' 	: times.nice 	+ "%"
				'sys' 	: times.sys 	+ "%"
				'idle' 	: times.idle 	+ "%"
				'irq' 	: times.irq 	+ "%"
			}	
			'date'		: times.date
		}
		
		
		
		