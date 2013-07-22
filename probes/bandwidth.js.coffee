Probe 					= require "../Probe.js.coffee"
child_process		= require 'child_process'
sys 						= require 'sys'


class bandwidth extends Probe
	
	probe = new Probe('bandwidth')
		
	probe.listen 'info', (req, res) =>
		console.log "bandwith descriptor"
		res.send JSON.stringify	(
			[
				{ 
					'title'				: 'Transmission',
					'unit'				: '(kB/s)',
					'uri'					: 'tx',
				},
				{ 
					'title'				: 'Reception',
					'unit'				: '(kB/s)',
					'uri'					: 'rx',
				},
				{ 
					'title'				: 'All',
					'unit'				: '(kB/s)',
					'uri'					: 'all',
				},				
			]
		)	
		
	probe.listen 'tx', (req, res) =>
		
		BandwidthProbe::fetch_bandwidth (rx, tx) =>

			res.send JSON.stringify	(	{ 'value' : tx, 'date' : new Date() } )
			
	probe.listen 'rx', (req, res) =>

		BandwidthProbe::fetch_bandwidth (rx, tx) =>

			res.send JSON.stringify	(	{ 'value' : rx, 'date' : new Date() } )
	
	probe.listen 'all', (req, res) =>

		BandwidthProbe::fetch_bandwidth (rx, tx) =>
			total = parseFloat(tx) + parseFloat(rx)
			res.send JSON.stringify	(	
				{ 'value' : total.toFixed(2), 
				'details' : {'rx' : rx + ' kB/s', 'tx' : tx + ' kB/s'}, 'date' : new Date() } 
			)
			
			
	fetch_bandwidth: (callback) =>
		
		child_process.exec "vnstat -tr", (error, stdout, stderr) =>
			try
				lines = stdout.split('\n')
				rx = lines[3].split(/\s+/g)[2]
				tx = lines[4].split(/\s+/g)[2]
				callback(rx, tx)
			catch err
				console.log 'error ' + err