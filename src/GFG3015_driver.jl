# GFG3015 digital multimeter driver

mutable struct GFG3015
    handle
	initialized
    instr_dict
	wfm_dict
	rev_wfm_dict
	unit_dict
	fct
end
GFG3015(handle) = GFG3015(
                handle,
				false,
                Dict(
                    "C1"=>"1"
                    ),
                Dict(
					"sinusoid"=>"1",
					"triangle"=>"2",
					"square"=>"3",
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
function connect!(obj::GFG3015, handle)
	obj.handle = handle
    obj.connected = 1
	return nothing
end
function disconnect!(obj::GFG3015)
	obj.handle = 0
    obj.connected = 0
	return nothing
end
reset_instr(obj::GFG3015) = write(obj.handle, "*RST")
clear_instr(obj::GFG3015) = write(obj.handle, "*CLS")
get_idn(obj::GFG3015) = query(obj.handle, "*IDN?")

## WFM
function set_wfm(obj::GFG3015, ch, fct="sinusoid")
	# set_wfm(fgen, "C1", "sinusoid")
	ch = obj.instr_dict[ch]
	fct = obj.wfm_dict[fct]
	cmd = ":FUNCtion:WAVeform $fct"
	write(obj.handle, cmd)
end
function get_wfm(obj::GFG3015, ch)
	# get_wfm(fgen, "C1")
	ch = obj.instr_dict[ch]
	cmd = ":FUNCtion:WAVeform?"
	value = strip(query(obj.handle, cmd))
	value = obj.rev_wfm_dict[value]
end

# UNIT	
function set_amplit_unit(obj::GFG3015, ch, unit="Vpp")
	# set_amplit_unit(fgen, "C1", "Vpp")
	ch = obj.instr_dict[ch]
	unit = obj.unit_dict[unit]
	cmd = ":AMPLitude:UNIT $unit"
	write(obj.handle, cmd)
end
function get_amplit_unit(obj::GFG3015, ch)
	# get_amplit_unit(fgen, "C1")
	ch = obj.instr_dict[ch]
	cmd = ":AMPLitude:UNIT?"
	value = strip(query(obj.handle, cmd))
	value = obj.unit_dict[value]
end

# AMPLITUDE
function set_amplit(obj::GFG3015, ch, value)
	# set_amplit(fgen, "C1", 2.2)
	ch = obj.instr_dict[ch]
	cmd = ":AMPLitude:VOLTage $value"
	write(obj.handle, cmd)
end
function get_amplit(obj::GFG3015, ch)
	# get_amplit(fgen, "C1")
	ch = obj.instr_dict[ch]
	cmd = ":AMPLitude:VOLTage?"
	value = parse(Float64, strip(query(obj.handle, cmd)))
end

# OFFSET
function set_offs(obj::GFG3015, ch, value)
	# set_offs(fgen, "C1", 1.1)
	ch = obj.instr_dict[ch]
	cmd = ":OFFSet $value"
	write(obj.handle, cmd)
end
function get_offs(obj::GFG3015, ch)
	# get_offs(fgen, "C1")
	ch = obj.instr_dict[ch]
	cmd = ":OFFSet?"
	value = parse(Float64, strip(query(obj.handle, cmd)))
end

# FREQUENCY
function set_freq(obj::GFG3015, ch, value)
	# set_freq(fgen, "C1", 1333)
	ch = obj.instr_dict[ch]
	cmd = ":FREQuency $value"
	write(obj.handle, cmd)
end
function get_freq(obj::GFG3015, ch)
	# get_freq(fgen, "C1")
	ch = obj.instr_dict[ch]
	cmd = ":FREQuency?"
	value = parse(Float64, strip(query(obj.handle, cmd)))
end

# DUTY CYCLE
function set_duty(obj::GFG3015, ch, value)
	# set_duty(fgen, "C1", 40)
	ch = obj.instr_dict[ch]
	cmd = ":DUTY $value"
	write(obj.handle, cmd)
end
function get_duty(obj::GFG3015, ch)
	# get_duty(fgen, "C1")
	ch = obj.instr_dict[ch]
	cmd = ":DUTY?"
	value = parse(Float64, strip(query(obj.handle, cmd)))
end