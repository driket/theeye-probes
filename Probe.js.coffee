###
Module dependencies
###

class Probe

	constructor: (data, port, domains) ->
		@port = port
		@domains = domains
		if typeof data is "object"
			@data = data
			console.log 'constructor: ' + @data.path

	#constructor: (type) ->
	#	@type = type
	
	@path						= '/'
	
	express 				= require 'express'
	app	 						= module.exports = express()

	@set_domains: (domains) ->
		@domains = domains


	send_headers = (req, res) =>
	
		origin = req.headers.origin || req.headers.host
		console.log 'host: ', origin
		res.setHeader 'Content-Type', 'application/json'
		for domain in @domains.split ' '
			if domain == origin 
				res.setHeader 'Access-Control-Allow-Origin', domain
				return
		res.status(401).send('not authorized')
		
	
	start: ->
		
		app.listen(@port)
		console.log 'Server running at port: ' + @port
		
	listen: (path, callback) =>
		
		if @data
			listen_path = Probe.path + @data.path + '/' + path
		else
			listen_path = Probe.path + path
		console.log 'listening ' + listen_path  
		app.get listen_path, (req, res) ->
			
			send_headers req, res
			try
				callback(req, res)
			catch err
				console.log 'error:' + err
				
	#listen '', (req, res) =>
	#	console.log 'domains:' + @domains
	
module.exports = Probe
