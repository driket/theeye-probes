Probe 					= require "../Probe.js.coffee"
child_process		= require 'child_process'
sys 						= require 'sys'


class ProcProbe extends Probe

	probe = new Probe()
	
	Object.size = (obj) =>
		size = 0
		for key in obj
			size++ if obj.hasOwnProperty(key)
		return size
		
	sortBy: (key, a, b, r) ->
	    r = if r then 1 else -1
	    return -1*r if a[key] > b[key]
	    return +1*r if a[key] < b[key]
	    return 0

	
	fetch_ps: (vm_host = '', callback) =>
		child_process.exec "ps auxc", (error, stdout, stderr) =>
			processes = []
			try
				lines = stdout.split('\n')
				if vm_host == 'lxc'
					col		=	1
				else
					col		=	0
				
				for line in lines
					cpu 			= line.split(/\s+/g)[col+2]
					mem 			= line.split(/\s+/g)[col+3]
					if cpu and mem
						cpu 		= parseFloat(cpu.replace(',','.'))
						mem			= parseFloat(mem.replace(',','.'))
						if cpu >= 0 and cpu <= 100 and mem >= 0 and mem <= 100
							usage			= parseFloat((mem + cpu).toFixed(2))
							if vm_host == 'lxc'
								command 	= line.split(/\s+/g)[col+10]+'('+line.split(/\s+/g)[0]+')'
							else
								command 	= line.split(/\s+/g)[col+10]
							processes.push {
								'cpu'			:	cpu,
								'mem'			: mem,
								'usage'		:	usage,
								'command'	:	command,
							}

				processes.sort (a,b) ->
					ProcProbe::sortBy('usage',a,b,true)

				index = 0
				details 	=	{'CPU/MEM':'COMMAND'}
				for proc in processes
					if index < 8
						details[proc.cpu + '/' + proc.mem] = proc.command 
						#console.log 'proc', proc
					index++
					
				callback(processes.length, details)
			catch err
				console.log 'error ' + err
	
	probe.listen 'ps', (req, res) =>

		ProcProbe::fetch_ps '', (proc_count, details) =>
			res.send JSON.stringify	(	
				{ 'value' : proc_count, 
				'details' : details,
				'date' 		: new Date() }
			)
			
	probe.listen 'lxc-ps', (req, res) =>

		ProcProbe::fetch_ps 'lxc', (proc_count, details) =>
			res.send JSON.stringify	(	
				{ 'value' : proc_count, 
				'details' : details,
				'date' 		: new Date() }
			)