Probe 					= require "../Probe.js.coffee"
child_process		= require 'child_process'
sys 						= require 'sys'


class security_updates extends Probe
	
	probe = new Probe {
		title:				'Security updates - debian/ubuntu',
		description:	'Check how many security updates are availables',
		path: 				this.name,
	}
		
	probe.listen 'index', (req, res) =>
		res.send JSON.stringify	(
			[
				{ 
					'title'				: 'Security updates availabes - debian/ubuntu',
					'unit'				: 'updates',
					'uri'					: 'security',
					'min'					:	'0',
					'max'					:	'50',
					'interval'		: '3600',
					'thresholds'	:	[],
				},
			]
		)	
	
	probe.listen 'security', (req, res) =>

		security_updates::fetch_updates (security, packages) =>
			res.send JSON.stringify	(	
				{ 
					'value' : security, 
					'details' : {
						security : security + ' update is a security update', 
						packages : packages + ' package(s) can be updated'
					}, 
					'date' : new Date()
				} 
			)
			
			
	fetch_updates: (callback) =>
		
		child_process.exec "/usr/lib/update-notifier/apt-check", (error, stdout, stderr) =>
			try
				values = stdout.split(';')
				packages = values[0]
				security = values[1]
				console.log values
				console.log packages
				console.log security
				callback(security , packages)
			catch err
				console.log 'error ' + err