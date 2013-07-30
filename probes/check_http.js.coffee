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
		
		url 		= req.query.site
		content = req.query.content || ''
		console.log req.query
		#if !processing
		
		processing = true
		check_http::get_http url, content, (status, response_time) =>
		
			processing = false
			
			if status == 404
				response_time = -1
			
			details = {'status':status, 'time':response_time + 's'}
			details.checked = content if content != ''
			res.send JSON.stringify	(	
				{ 'value' : response_time, 
				'details' : details,
				'date'		: new Date()} 
			)
			
			
	get_http: (url, check_content, callback) =>
		
		start_check_time = new Date().getTime()
		
		if url.substring(0, 5) == 'https'
			protocol = https
		else
			protocol = http
		
		body = ""
		
		protocol.get url, (res) =>
			
			
			# get chunk of body
			res.on 'data', (chunk) =>
				
				body += chunk
				
			# check body
			res.on 'end', =>

				elapased_time = (new Date().getTime() - start_check_time) / 1000
				if check_content == ''
					console.log "no content to check in #{url}"
					callback(res.statusCode, elapased_time)
				else if body.indexOf(check_content) != -1
					callback(res.statusCode, elapased_time)
				else
					callback(res.statusCode, -1)					
						
				#else
				#	callback(404, -1)
			
		.on 'error', (e) =>
			
			console.log 'error : ', e.message
			callback(404, -1)
			

		