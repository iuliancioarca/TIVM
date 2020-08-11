# GDM8246 digital multimeter driver
# types
mutable struct GDM8246
    handle
	address
	initialized
    instr_dict
	fct
	range
end
GDM8246(handle, address) = GDM8246(
                UInt32(handle),
				address,
				false,
                Dict(
                    "C1"=>"1",
                    "on"=>"1",
                    "off"=>"0",
                    "1"=>"on",
					"0"=>"off", 
                    "DCV"=>"VOLTage:DC",
                    "ACV"=>"VOLTage:AC",
					"AC+DCV"=>"VOLTage:ACDC",
					"RIPPLE"=>"VOLTage:DCAC",
					"DCA"=>"CURRent:DC",
					"ACA"=>"CURRent:AC",
					"AC+DCA"=>"CURRent:ACDC",
					"OHM"=>"RESistance",
					"CAPACITANCE"=>"CAPacitance",
					"CONT"=>"CONTinuity",
					"DIODE"=>"DIODe",
                    ),
					"DCV",
					"0"
                    )

# MISC
function connect(obj::GDM8246)
    obj.connected = 1
end
function disconnect(obj::GDM8246)
    obj.connected = 0
end
reset_instr(obj::GDM8246) = viWrite(obj.handle, "*RST\n")
clear_instr(obj::GDM8246) = viWrite(obj.handle, "*CLS\n")
get_idn(obj::GDM8246) = query(obj.handle, "*IDN?\n")

## SENSE
function get_sense_func(obj::GDM8246, ch)
	ch = obj.instr_dict[ch]
	cmd = ":CONFigure:FUNCtion?"
	fct = strip(query(obj.handle, cmd))
	#fct = obj.instr_dict[fct]
end
function set_sense_func(obj::GDM8246, ch, fct)
	ch = obj.instr_dict[ch]
	obj.fct = fct
	fct = obj.instr_dict[fct]
	cmd = ":CONFigure:$fct $(obj.range)"
	viWrite(obj.handle, cmd)
end
function set_sense_range(obj::GDM8246, ch, vrang) # this will not work
	ch = obj.instr_dict[ch]
	fct = obj.instr_dict[obj.fct]
	cmd = ":CONFigure:$fct $vrang"
	viWrite(obj.handle, cmd)
end	
function get_sense_range(obj::GDM8246, ch)
	ch = obj.instr_dict[ch]
	cmd = ":CONFigure:RANGE ?"
	strip(query(obj.handle, cmd))
end		
function set_sense_range_auto(obj::GDM8246, ch, st)
	ch = obj.instr_dict[ch]
	st = obj.instr_dict[st]
	cmd = ":CONFigure:AUTo $st"
	viWrite(obj.handle, cmd)
end
function get_sense_range_auto(obj::GDM8246, ch)
	ch = obj.instr_dict[ch]
	cmd = ":CONFigure:AUTo?"
	st = strip(query(obj.handle, cmd))
	st = obj.instr_dict[st]
end
## BASIC MEASUREMENT
function get_primary_measurement(obj::GDM8246, ch)
	ch = obj.instr_dict[ch]
	cmd = ":VALue?"
	value = strip(query(obj.handle, cmd))
end
function get_secondary_measurement(obj::GDM8246, ch)
	ch = obj.instr_dict[ch]
	cmd = ":SVALue?"
	value = strip(query(obj.handle, cmd))
end		       