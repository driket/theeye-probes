Probe 					= require "../Probe.js.coffee"
child_process		= require 'child_process'
sys 						= require 'sys'


class bandwidth extends Probe
	
	probe = new Probe {
		title:				'Bandwidth usage',
		description:	'Monitor bandwidth usage (transmission, reception, both)',
		path: 				this.name,
	}
		
	probe.listen 'index', (req, res) =>
		res.send JSON.stringify	(
			[
				{ 
					'title'				: 'Bandwidth - transmission',
					'unit'				: 'kB/s',
					'uri'					: 'tx',
					'min'					:	'0',
					'max'					:	'10000',
					'interval'		: '5',
					'thresholds'	:	[],
				},
				{ 
					'title'				: 'Bandwidth - reception',
					'unit'				: 'kB/s',
					'uri'					: 'rx',
					'min'					:	'0',
					'max'					:	'10000',
					'interval'		: '5',
					'thresholds'	:	[],
				},
				{ 
					'title'				: 'Bandwidth - total',
					'unit'				: 'kB/s',
					'uri'					: 'all',
					'min'					:	'0',
					'max'					:	'10000',
					'interval'		: '5',
					'thresholds'	:	[],
				},				
			]
		)	
		
	probe.listen 'tx', (req, res) =>
		
		bandwidth::fetch_bandwidth (rx, tx) =>

			res.send JSON.stringify	(	{ 'value' : tx, 'date' : new Date() } )
			
	probe.listen 'rx', (req, res) =>

		bandwidth::fetch_bandwidth (rx, tx) =>

			res.send JSON.stringify	(	{ 'value' : rx, 'date' : new Date() } )
	
	probe.listen 'all', (req, res) =>

		bandwidth::fetch_bandwidth (rx, tx) =>
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
				if lines[3].split(/\s+/g)[3] == "MB/s"
					rx = rx * 1024
				if lines[4].split(/\s+/g)[3] == "MB/s"
					tx = tx * 1024	
				callback(rx, tx)
			catch err
				console.log 'error ' + err