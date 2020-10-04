
import GenericInstruments: query

function connect!(address; mode=GI.VI_NO_LOCK, timeout=UInt32(10000))
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

function read(handle, bufSize::UInt32=0x00000100)
	strip(GI.viRead(handle; bufSize=bufSize), ['\r', '\n'])
end

function query(handle, cmd::String, delay::Real=0.0)
    #flush read buffer
    #GenericInstruments.viFlush(psu.handle, GenericInstruments.VI_READ_BUF_DISCARD)
	write(handle, cmd)	
	sleep(delay)
	x = read(handle)
	#GenericInstruments.viFlush(psu.handle, GenericInstruments.VI_READ_BUF_DISCARD)
	return x
end

# aliases
function visaWrite(handle, cmd)
	write(handle, cmd)
end

function visaWrite(address::String, cmd)
	handle = connect!(address)
	write(handle, cmd)
	disconnect!(handle)
end

function visaRead(handle, bufSize::UInt32=0x00000100)
	read(handle, bufSize)
end

function visaRead(address::String, bufSize::UInt32=0x00000100)
	handle = connect!(address)
	ro = read(handle, bufSize)
	disconnect!(handle)
	return ro
end

function query(address::String, cmd::String)
	handle = connect!(address)
	ro = ""
	try
		ro = query(handle, cmd)
	catch
		ro = query(handle, cmd)
	end
	disconnect!(handle)
	return ro
end


# Helper functions to find instruments
function find_resources(expr::AbstractString="?*::INSTR")
	resmgr = GenericInstruments.viOpenDefaultRM()
	addresses = GenericInstruments.viFindRsrc(resmgr, expr)
	for address in addresses
		try
			instr_name = query(address::String, "*IDN?")		
			println("Found $instr_name on address: $address")
		catch
			nothing
		end
	end
end