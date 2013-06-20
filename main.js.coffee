Probe 					= require "./Probe.js.coffee"

MemoryProbe 		= require "./probes/MemoryProbe.js.coffee"
BandwidthProbe 	= require "./probes/BandwidthProbe.js.coffee"
CPUProbe 				= require "./probes/CPUProbe.js.coffee"

probe = new Probe()
probe.start()