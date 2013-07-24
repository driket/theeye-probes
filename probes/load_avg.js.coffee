Probe 					= require "../Probe.js.coffee"
child_process		= require 'child_process'
sys 						= require 'sys'
os							= require 'os'


class load_avg extends Probe

	probe = new Probe {
		path: 				this.name,
		title:				'Load average',
		description:	'Monitor number of threads in the queue / proc',
	}
	
	probe.listen 'index', (req, res) =>
	
		res.send JSON.stringify	(
			[
				{ 
					'title'				: 'Load average',
					'unit'				: 'thread',
					'uri'					: 'load',
					'min'					:	'0',
					'max'					:	'5',
					'interval'		: '2',
					'thresholds'	:	[
						{'operator':'>=', 'value':'1.0', 'type':'alert'},
						{'operator':'>=', 'value':'0.7', 'type':'warning'},
					],
				},
				{ 
					'title'				: 'Load average - lxc',
					'unit'				: 'thread',
					'uri'					: 'load-lxc',
					'min'					:	'0',
					'max'					:	'5',
					'interval'		: '2',
					'thresholds'	:	[
						{'operator':'>=', 'value':'1.0', 'type':'alert'},
						{'operator':'>=', 'value':'0.7', 'type':'warning'},
					],
				},
				{ 
					'title'				: 'Load average - lxc/ubuntu',
					'unit'				: 'thread',
					'uri'					: 'load-lxc-ubuntu',
					'min'					:	'0',
					'max'					:	'5',
					'interval'		: '2',
					'thresholds'	:	[
						{'operator':'>=', 'value':'1.0', 'type':'alert'},
						{'operator':'>=', 'value':'0.7', 'type':'warning'},
					],
				},
			]
		)
		
	probe.listen 'load', (req, res) =>

		load_avg::fetch_ps '', (load_avg_value, details) =>
			res.send JSON.stringify	(	
				{ 'value' : load_avg_value, 
				'details' : details,
				'date' 		: new Date() }
			)
			
	probe.listen 'load-lxc', (req, res) =>

		load_avg::fetch_ps 'lxc', (load_avg_value, details) =>
			res.send JSON.stringify	(	
				{ 'value' : load_avg_value, 
				'details' : details,
				'date' 		: new Date() }
			)
			
	probe.listen 'load-lxc-ubuntu', (req, res) =>

		load_avg::fetch_ps 'lxc-ubuntu', (load_avg_value, details) =>
			res.send JSON.stringify	(	
				{ 'value' : load_avg_value, 
				'details' : details,
				'date' 		: new Date() }
			)
	
	
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
		
		os_load_avg 		= os.loadavg()
		cpus						=	os.cpus().length
		load_avg_value	= (os_load_avg[0] / cpus).toFixed(2)
		
		if vm_host == 'lxc'
			col					=	1
			ps_command 	= 'lxc-ps auxc'	
			
		else if vm_host == 'lxc-ubuntu'
			col 				=	1
			ps_command	= 'lxc-ps --lxc -- auxc'
			
		else
			col		=	0
			ps_command = 'ps auxc'	
			
		child_process.exec ps_command, (error, stdout, stderr) =>
			processes = []
			try
				lines = stdout.split('\n')				
				for line in lines
					cpu 			= line.split(/\s+/g)[col+2]
					mem 			= line.split(/\s+/g)[col+3]
					if cpu and mem
						cpu 		= parseFloat(cpu.replace(',','.'))
						mem			= parseFloat(mem.replace(',','.'))
						if cpu >= 0 and cpu <= 100 and mem >= 0 and mem <= 100
							usage			= parseFloat((mem + cpu).toFixed(2))
							if vm_host == 'lxc' or vm_host == 'lxc-ubuntu'
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
					load_avg::sortBy('usage',a,b,true)

				index = 0
				details =	
				{ 
					'proc count':processes.length,
					'CPU/MEM'		:'COMMAND',
				}
				for proc in processes
					if index < 8
						details[proc.cpu + '/' + proc.mem] = proc.command 
						#console.log 'proc', proc
					index++
					
				callback(load_avg_value, details)
			catch err
				console.log 'error ' + err
	
