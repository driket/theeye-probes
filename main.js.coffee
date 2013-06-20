Probe 					= require "./Probe.js.coffee"
MemoryProbe 		= require "./MemoryProbe.js.coffee"
BandwidthProbe 	= require "./BandwidthProbe.js.coffee"

probe = new Probe()
probe.start()