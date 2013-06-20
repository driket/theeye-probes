###
Module dependencies
###

express 				= require 'express'
app	 						= module.exports = express()
os 							= require 'os'
child_process		= require 'child_process'
sys 						= require 'sys'


class TheEyeProbe

	send_headers: (res) =>
	
		res.setHeader 'Content-Type', 'application/json'
		res.setHeader 'Access-Control-Allow-Origin', 'http://localhost:3000'
	
	
	app.get '/mem_usage', (req, res) ->

		TheEyeProbe::send_headers res

		used_mem = os.totalmem()-os.freemem()
		mem_usage = Math.round( used_mem / os.totalmem() * 100 )
		json = {'value' : mem_usage, 'date' : new Date()}

		res.send JSON.stringify json


	app.get '/bandwith_usage', (req, res) =>

		TheEyeProbe::send_headers res

		child_process.exec "vnstat -tr", (error, stdout, stderr) =>
			console.log stdout

		#res.send(JSON.stringify(json))

	app.listen(1337)
	console.log('Server running at http://127.0.0.1:1337/')
