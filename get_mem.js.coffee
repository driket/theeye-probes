###
Module dependencies
###

express 	= require 'express'
app	 			= module.exports = express.createServer()
os 				= require 'os'

#app 			= express()
#sys 			= require 'sys'
exec 			= require ('child_process')

#puts: (error, stdout, stderr) =>
#	sys.puts(stdout)

app.get '/mem_usage', (req, res) =>
	
	res.setHeader 'Content-Type', 'application/json'
	res.setHeader 'Access-Control-Allow-Origin', 'http://localhost:3000'
	used_mem = os.totalmem()-os.freemem()
	mem_usage = Math.round( used_mem / os.totalmem() * 100 )
	json = {'value' : mem_usage}
	
	res.send(JSON.stringify(json))
	
app.get '/bandwith_usage', (req, res) =>
	
	res.setHeader 'Content-Type', 'application/json'
	res.setHeader 'Access-Control-Allow-Origin', 'http://localhost:3000'
	
	exec "ls -la", (error, stdout, stderr) =>
		console.log stdout

	#res.send(JSON.stringify(json))

app.listen(1337)
console.log('Server running at http://127.0.0.1:1337/')
