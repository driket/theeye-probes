###
Module dependencies
###

class Probe

	constructor: () ->
		#init()
		
	@path						= '/'
	
	express 				= require 'express'
	app	 						= module.exports = express()

	send_headers: (res) =>
	
		res.setHeader 'Content-Type', 'application/json'
		res.setHeader 'Access-Control-Allow-Origin', 'http://localhost:3000'
	
	start: ->
		
		app.listen(1337)
		console.log('Server running at http://127.0.0.1:1337/')
		
	listen: (path, callback) =>
		
		app.get Probe.path + path, (req, res) ->
			Probe::send_headers res
			callback(req, res)
		

#probe = new Probe()
#probe.init()
#return probe
#MemoryProbe 					= require "./MemoryProbe.js.coffee"


#probe.listen '', (req, res) =>
		
#		res.send 'The Eye : Probes'
	
module.exports = Probe
