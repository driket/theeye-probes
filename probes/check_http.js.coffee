Probe 					= require "../Probe.js.coffee"
child_process		= require 'child_process'
http 						= require('http');
https 					= require('https');


class check_http extends Probe
	
	probe = new Probe {
		title:				'Check http(s) response time',
		description:	'Monitor HTTP(S) response time',
		path: 				this.name,
	}
	
	processing 				= false
	start_check_time 	= Date.now()
	
	probe.listen 'index', (req, res) =>
		res.send JSON.stringify	(
			[
				{ 
					'title'				: 'check http',
					'unit'				: 's',
					'uri'					: 'http',
					'min'					:	'0',
					'max'					:	'10',
					'interval'		: '10',
					'thresholds'	:	[
						{'operator':'<', 'value':'0', 'type':'alert'},
						{'operator':'>=', 'value':'10', 'type':'alert'},
						{'operator':'>=', 'value':'5', 'type':'warning'},
					],
					'args'				: true,
				},	
			]
		)	
		
	
	probe.listen 'http', (req, res) =>
		
		if !processing
		
			processing = true
			check_http::get_http "https://puppetdashboard.myvitrine.com", (status, response_time) =>
			
				processing = false
				
				if status == 404
					response_time = -1
				
				res.send JSON.stringify	(	
					{ 'value' : response_time, 
					'details' : {'status':status, 'time':response_time + 'ms'},
					'date'		: new Date()} 
				)
			
			
	get_http: (url, callback) =>
		
		start_check_time = new Date().getTime()
		
		if url.substring(0, 5)
			protocol = https
		else
			protocol = http
		
		protocol.get url, (res) =>
			
			elapased_time = (new Date().getTime() - start_check_time) / 1000
			callback(res.statusCode, elapased_time)
			
		.on 'error', (e) =>
			
			console.log 'error : ', e.message
			callback(404, -1)
			

		