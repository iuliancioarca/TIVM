# DS1000Z oscilloscope function generator driver

mutable struct DS1000Z_FGEN
    handle
	initialized
    instr_dict
	wfm_dict
	rev_wfm_dict
	togg_wfm_dict
	unit_dict
	fct
end
DS1000Z_FGEN(handle) = DS1000Z_FGEN(
                handle,
				false,
                Dict(
                    "C1"=>"1",
					"C2"=>"2"
                    ),
                Dict(
					"sinusoid"=>"SINusoid",
					"triangle"=>"RAMP",
					"square"=>"PULSe", # use pulse because it accepts duty cycle
                    ),	
                Dict(
                    "SIN"=>"sinusoid",
					"RAMP"=>"triangle",
					"PULS"=>"square",
                    ),
                Dict(
                    "1"=>"sinusoid",
					"2"=>"triangle",
					"3"=>"square",
                    ),					
                Dict(
					"Vpp"=>"1",
					"Vrms"=>"2",
					"dBm"=>"3",				
					"1"=>"Vpp",
					"2"=>"Vrms",
					"3"=>"dBm",
                    ),					
					"sinusoid",
                    )

# MISC
function connect!(obj::DS1000Z_FGEN, handle) # DONE
	obj.handle = handle
    obj.connected = 1
	# set output default on
	write(obj.handle, ":SOURce1:OUTPut1:STATe 1")
	write(obj.handle, ":SOURce2:OUTPut2:STATe 1")
	# set default 50Ohm
	write(obj.handle, ":SOURce1:OUTPut1:IMPedance FIFTy")
	write(obj.handle, ":SOURce2:OUTPut2:IMPedance FIFTy")
	return nothing
end
function disconnect!(obj::DS1000Z_FGEN)
	obj.handle = 0
    obj.connected = 0
	return nothing
end
reset_instr(obj::DS1000Z_FGEN) = write(obj.handle, "*RST")
clear_instr(obj::DS1000Z_FGEN) = write(obj.handle, "*CLS")
get_idn(obj::DS1000Z_FGEN) = query(obj.handle, "*IDN?")

## WFM
function set_wfm(obj::DS1000Z_FGEN, ch, fct="sinusoid") # DONE
	# set_wfm(fgen, "C1", "sinusoid")
	ch = obj.instr_dict[ch]
	if fct == "triangle"
		cmdfct = ":SOURce$ch:FUNCtion:RAMP:SYMMetry 50"
		write(obj.handle, cmdfct)
		sleep(0.3)
	end
	fct = obj.wfm_dict[fct]
	cmd = ":SOURce$ch:FUNCtion:SHAPe $fct"
	write(obj.handle, cmd)

end
function get_wfm(obj::DS1000Z_FGEN, ch) # DONE
	# get_wfm(fgen, "C1")
	ch = obj.instr_dict[ch]
	cmd = ":SOURce$ch:FUNCtion:SHAPe?"
	value = strip(query(obj.handle, cmd))
	value = obj.rev_wfm_dict[value]
end

# UNIT	
function set_amplit_unit(obj::DS1000Z_FGEN, ch, unit="Vpp")  # KIND OF DONE
	# set_amplit_unit(fgen, "C1", "Vpp")
	ch = obj.instr_dict[ch]
	#unit = obj.unit_dict[unit]
	#cmd = ":AMPLitude:UNIT $unit"
	#write(obj.handle, cmd)
	@info "not implemented yet, default to Vpp"
end
function get_amplit_unit(obj::DS1000Z_FGEN, ch)  # KIND OF DONE
	# get_amplit_unit(fgen, "C1")
	ch = obj.instr_dict[ch]
	#cmd = ":AMPLitude:UNIT?"
	#value = strip(query(obj.handle, cmd))
	#value = obj.unit_dict[value]
	#@info "not implemented yet, default to Vpp"
	return "Vpp"
end

# AMPLITUDE
function set_amplit(obj::DS1000Z_FGEN, ch, value) # DONE
	# set_amplit(fgen, "C1", 2.2)
	ch = obj.instr_dict[ch]
	cmd = ":SOURce$ch:VOLTage:LEVel:IMMediate:AMPLitude $value"
	write(obj.handle, cmd)
end
function get_amplit(obj::DS1000Z_FGEN, ch) # DONE
	# get_amplit(fgen, "C1")
	ch = obj.instr_dict[ch]
	cmd =  ":SOURce$ch:VOLTage:LEVel:IMMediate:AMPLitude?"
	value = parse(Float64, strip(query(obj.handle, cmd)))
end

# OFFSET
function set_offs(obj::DS1000Z_FGEN, ch, value) # DONE
	# set_offs(fgen, "C1", 1.1) 
	ch = obj.instr_dict[ch]
	cmd = ":SOURce$ch:VOLTage:LEVel:IMMediate:OFFSet $value"
	write(obj.handle, cmd)
end
function get_offs(obj::DS1000Z_FGEN, ch) # DONE
	# get_offs(fgen, "C1")
	ch = obj.instr_dict[ch]
	cmd = ":SOURce$ch:VOLTage:LEVel:IMMediate:OFFSet?"
	value = parse(Float64, strip(query(obj.handle, cmd)))
end

# FREQUENCY
function set_freq(obj::DS1000Z_FGEN, ch, value) # DONE
	# set_freq(fgen, "C1", 1333)
	ch = obj.instr_dict[ch]
	cmd = ":SOURce$ch:FREQuency:FIXed $value"
	write(obj.handle, cmd)
end
function get_freq(obj::DS1000Z_FGEN, ch) # DONE
	# get_freq(fgen, "C1")
	ch = obj.instr_dict[ch]
	cmd = ":SOURce$ch:FREQuency:FIXed?"
	value = parse(Float64, strip(query(obj.handle, cmd)))
end

# DUTY CYCLE
function set_duty(obj::DS1000Z_FGEN, ch, value) # DONE
	# set_duty(fgen, "C1", 40)
	ch = obj.instr_dict[ch]
	cmd = ":SOURce$ch:PULSe:DCYCle $value"
	write(obj.handle, cmd)
end
function get_duty(obj::DS1000Z_FGEN, ch) # DONE
	# get_duty(fgen, "C1")
	ch = obj.instr_dict[ch]
	cmd = ":SOURce$ch:PULSe:DCYCle?"
	value = parse(Float64, strip(query(obj.handle, cmd)))
end