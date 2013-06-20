###
Module dependencies
###

class Probe

	@path						= '/'
	
	express 				= require 'express'
	app	 						= module.exports = express()
	os 							= require 'os'
	child_process		= require 'child_process'
	sys 						= require 'sys'


	send_headers: (res) =>
	
		res.setHeader 'Content-Type', 'application/json'
		res.setHeader 'Access-Control-Allow-Origin', 'http://localhost:3000'
	
	init: ->
		app.listen(1337)
		console.log('Server running at http://127.0.0.1:1337/')
		
	listen = (path, callback) =>
	
		app.get @path + path, (req, res) ->
			Probe::send_headers res
			callback(req, res)

	listen '', (req, res) =>
		
		res.send 'The Eye : Probes'
		

	#app.get '/bandwith_usage', (req, res, text) =>

	#	Probe::send_headers res

	#	child_process.exec "vnstat -tr", (error, stdout, stderr) =>
	#		console.log stdout

		#res.send(JSON.stringify(json))

	Probe::init()
