#DS1000Z scope driver

mutable struct DS1000Z
    handle
	initialized
    instr_dict
end
#"MEAN" "PERIod" "PK2pk" "MINImum" "MAXImum"
DS1000Z(handle) = DS1000Z(
                handle,
				false,
                Dict(
                    "CH1"=>"1",
                    "CH2"=>"2",
					"CH3"=>"3",
                    "CH4"=>"4",
					"Source"=>":TRIGger:EDGe:SOURce",
                    "Level"=>":TRIGger:EDGe:LEVel",
                    "Mode"=>":TRIGger:SWEep",
					"AUTO"=>"AUTO",
					"NORMAL"=>"NORMAL",
                    "MEAS1"=>1,
                    "MEAS2"=>2,
                    "MEAS3"=>3,
                    "MEAS4"=>4,
                    "MEAS5"=>5,
					"MEAN"=>"VAVG",
					"PERIod"=>"PERIod",
					"PK2pk"=>"VPP",
					"MINImum"=>"VMIN",
					"MAXImum"=>"VMAX",
                    )
                    )

#Misc
function connect!(obj::DS1000Z, handle)
    obj.handle = handle
    obj.connected = 1
    return nothing
    end
function disconnect!(obj::DS1000Z)
    obj.handle = 0
    obj.connected = 0
    return nothing
    end

reset_instr(obj::DS1000Z) = write(obj.handle, "*RST")
clear_instr(obj::DS1000Z) = write(obj.handle, "*CLS")
get_idn(obj::DS1000Z) = query(obj.handle, "*IDN?")

# VERTICAL
function set_ch_coupling(obj::DS1000Z, ch, cpl)
	ch = obj.instr_dict[ch]
	write(obj.handle, ":CHANnel$ch:COUPling $cpl")
end
function get_ch_coupling(obj::DS1000Z, ch)
	ch = obj.instr_dict[ch]
	strip(query(obj.handle, ":CHANnel$ch:COUPling?"))
end

function set_vertical_scale(obj::DS1000Z, ch, value)
    ch = obj.instr_dict[ch]
    cmd = ":CHANnel$ch:SCAle $value"
    write(obj.handle, cmd)
end
function get_vertical_scale(obj::DS1000Z, ch)
    ch = obj.instr_dict[ch]
    cmd = ":CHANnel$ch:SCAle?"
    value = parse(Float64, strip(query(obj.handle, cmd)))
end

function set_ch_position(obj::DS1000Z, ch, lev)
	ch = obj.instr_dict[ch]
    cmd = ":CHANnel$ch:OFFSet $lev"
    value = write(obj.handle, cmd)
end
function get_ch_position(obj::DS1000Z, ch)
	ch = obj.instr_dict[ch]
    cmd = ":CHANnel$ch:OFFSet?"
    value = parse(Float64, strip(query(obj.handle, cmd)))
end

# HORIZONTAL
function set_horizontal_scale(obj::DS1000Z, value)
    cmd = ":TIMebase:MAIn:SCAle $value"
    write(obj.handle, cmd)
end
function get_horizontal_scale(obj::DS1000Z, time)
    #time = obj.instr_dict[time]
    cmd = ":TIMebase:MAIn:SCAle?"
    value = parse(Float64, strip(query(obj.handle, cmd)))
end


# TRIGGER
function set_trig_ch(obj::DS1000Z, ch)
    ch = obj.instr_dict[ch]
    cmd = ":TRIGger:EDGe:SOURce CHANnel$ch"
    write(obj.handle, cmd)
end

function set_trig_level(obj::DS1000Z, level)
    cmd = ":TRIGger:EDGe:LEVel $level"
    write(obj.handle, cmd)
end

function set_trig_mode(obj::DS1000Z, mode)
	mode = obj.instr_dict[mode]
    cmd = ":TRIGger:SWEep $mode"            # AUTO or NORMal or SINGLE
    write(obj.handle, cmd)
end

function get_trig_data(obj::DS1000Z, trig)
    trig = obj.instr_dict[trig]
    cmd = "$trig?"
    value = strip(query(obj.handle, cmd))
end

# MEASUREMENT
function set_meas_ch(obj::DS1000Z, Meas_Nr1, ch)
    obj.instr_dict[Meas_Nr1] = obj.instr_dict[ch]
end

function set_meas_type(obj::DS1000Z, Meas_Nr1, Type)
    ch = obj.instr_dict[Meas_Nr1]
	Type = obj.instr_dict[Type]
	obj.instr_dict[Meas_Nr1] = obj.instr_dict[Meas_Nr1] * Type
	cmd = ":MEASure:ITEM $Type,CHANnel$ch"
    write(obj.handle, cmd)
end

function set_meas(obj::DS1000Z, Meas_Nr1, ch, Type)
    set_meas_ch(obj,Meas_Nr1, ch)
    set_meas_type(obj, Meas_Nr1, Type)
end
function get_meas_data(obj::DS1000Z, Meas_Nr1)
    nr = obj.instr_dict[Meas_Nr1]
    #cmd = "*OPC?"
    #value = strip(query(obj.handle, cmd))
	Type = obj.instr_dict[Meas_Nr1][2:end]
	ch = obj.instr_dict[Meas_Nr1][1]
    cmd = ":MEASure:ITEM? $Type,CHANnel$ch"
    value = parse(Float64, strip(query(obj.handle, cmd)))
end

# ACQUISITION
# select channel for acq and config
function conf_acq_ch(obj::DS1000Z, ch)
	ch = obj.instr_dict[ch]
    write(obj.handle, "SELect:$ch ON")
	write(obj.handle, "DATa:SOUrce $ch;DATa:ENCdg SRIBINARY;DATa:WIDth 1;DATa:STARt 1;DATa:STOP 2500")
	write(obj.handle, "CURVE?")
end

function auto_set(obj::DS1000Z)
	write(obj.handle, ":AUToscale")
	@info "Scope auto-set in progress"
	sleep(1)
end

function Trigger_Aquistion(obj::DS1000Z, ch)
	ch = obj.instr_dict[ch]

	y_buffer = zeros(UInt8, 2506)
	viRead!(obj.handle, y_buffer)

	gain = parse(Float64, query(obj.handle, "WFMPre:YMUlt?"))
	#offs = parse(Float64, query(obj.handle, "WFMPre:YOFf?")) # THIS IS A PIECE OF SHIT COMMAND!!!!
	offs = parse(Float64, query(obj.handle, "$ch:POSition?"))
	dt = parse(Float64, query(obj.handle, "WFMPre:XINcr?"))

	y = Float64.(reinterpret(Int8, y_buffer[7:end])) .* gain .- offs
	t = collect(0:dt:dt*(length(y)-1))

	return t, y
end
