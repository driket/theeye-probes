###
Module dependencies
###

class Probe

	constructor: (type, port, domains) ->
		@port = port
		@domains = domains
		@type = type
		console.log 'constructor: ' + @type

	#constructor: (type) ->
	#	@type = type
	
	@path						= '/'
	
	express 				= require 'express'
	app	 						= module.exports = express()

	@set_domains: (domains) ->
		@domains = domains


	send_headers = (req, res) =>
	
		res.setHeader 'Content-Type', 'application/json'
		for domain in @domains.split ' '
			if domain == req.headers.origin
				res.setHeader 'Access-Control-Allow-Origin', domain
				return
		res.status(401).send('not authorized')
		
	
	start: ->
		
		app.listen(@port)
		console.log 'Server running at port: ' + @port
		
	listen: (path, callback) =>
		
		if !@type 
			listen_path = path
		else
			listen_path = Probe.path + @type + '/' + path
		console.log 'listening ' + listen_path  
		app.get listen_path, (req, res) ->
			
			send_headers req, res
			try
				callback(req, res)
			catch
				console.log 'error' + callback
				
	#listen '', (req, res) =>
	#	console.log 'domains:' + @domains
	
module.exports = Probe
