Probe 					= require "./Probe.js.coffee"
child_process		= require 'child_process'
sys 						= require 'sys'


class BandwidthProbe extends Probe
	constructor: (@probe)
	if @probe
		probe = @probe 
	else
		probe = new Probe()
	
	probe.listen 'bandwidth', (req, res) =>

		child_process.exec "vnstat -tr", (error, stdout, stderr) =>
			console.log stdout
		res.send 'bandwidth'
#		res.send(JSON.stringify(json))