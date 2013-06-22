###
Module dependencies
###

class Probe

	constructor: (port, domains) ->
		@port = port
		@domains = domains
			
	@path						= '/'
	
	express 				= require 'express'
	app	 						= module.exports = express()

	@set_domains: (domains) ->
		console.log 'set domains ' + domains
		@domains = domains


	send_headers = (req, res) =>
	
		res.setHeader 'Content-Type', 'application/json'
		for domain in @domains.split ' '
			if domain == req.headers.origin
				res.setHeader 'Access-Control-Allow-Origin', domain
		
	
	start: ->
		
		app.listen(@port)
		console.log 'Server running at port: ' + @port
		
	listen: (path, callback) =>
		
		app.get Probe.path + path, (req, res) ->
			
			send_headers req, res
			try
				callback(req, res)
			catch
				console.log 'error' + callback
				
	#listen '', (req, res) =>
	#	console.log 'domains:' + @domains
	
module.exports = Probe
