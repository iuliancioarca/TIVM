
import GenericInstruments: query

function connect!(address; mode=GI.VI_EXCLUSIVE_LOCK, timeout=GI.VI_TMO_INFINITE)
		# resource manager
		rmg = GI.viOpenDefaultRM()
		#Pointer for the instrument handle
		vi = GI.ViPSession(0)
		GI.check_status(GI.viOpen(rmg, address, mode, timeout, vi))
		handle = vi.x
end

function disconnect!(handle)	
	GI.viClose(handle)		
end

function write(handle, cmd::String)
	GI.viWrite(handle, cmd*"\n") 
	return nothing
end

function read(handle, bufSize::UInt32=0x00000400)
	strip(GI.viRead(handle; bufSize=bufSize), ['\r', '\n'])
end

function query(handle, cmd::String, delay::Real=0.01)
    #flush read buffer
    #GenericInstruments.viFlush(psu.handle, GenericInstruments.VI_READ_BUF_DISCARD)
	write(handle, cmd)
	sleep(delay)
	x = read(handle)
	#GenericInstruments.viFlush(psu.handle, GenericInstruments.VI_READ_BUF_DISCARD)
	return x
end

