#TDS2002B scope driver

mutable struct TDS2002B
    handle
	initialized
    instr_dict
end

TDS2002B(handle) = TDS2002B(
                handle,
				false,
                Dict(
                    "CH1"=>"CH1",
                    "CH2"=>"CH2",
                    "Time"=>"HORizontal:MAIn:SCAle",
                    "Source"=>"TRIGger:MAIn:EDGE:SOUrce",
                    "Level"=>"TRIGger:MAIn:LEVel",
                    "Mode"=>"TRIGger:MAIn:MODe",
                    "Meas_ch"=>"SOUrce?",
                    "Meas_type"=>"TYPe?",
                    "Meas_value"=>"VALue?",
                    "Meas_Nr1"=>1,
                    "Meas_Nr2"=>2,
                    "Meas_Nr3"=>3,
                    "Meas_Nr4"=>4,
                    "Meas_Nr5"=>5,
                    )
                    )

#Misc
function connect!(obj::TDS2002B, handle)
    obj.handle = handle
    obj.connected = 1
    return nothing
    end
function disconnect!(obj::TDS2002B)
    obj.handle = 0
    obj.connected = 0
    return nothing
    end

reset_instr(obj::TDS2002B) = write(obj.handle, "*RST")
clear_instr(obj::TDS2002B) = write(obj.handle, "*CLS")
get_idn(obj::TDS2002B) = query(obj.handle, "*IDN?")

#Get OSC Settings
function get_vertical_scale(obj::TDS2002B, ch)
    ch = obj.instr_dict[ch]
    cmd = "$ch:SCAle?"
    value = strip(query(obj.handle, cmd))
end

function get_horizontal_scale(obj::TDS2002B, time)
    time = obj.instr_dict[time]
    cmd = "$time?"
    value = strip(query(obj.handle, cmd))
end

function get_ch_position(obj::TDS2002B, ch)
    cmd = "$ch:POSition?"
    value = strip(query(obj.handle, cmd))
end

function set_ch_position(obj::TDS2002B, ch, lev)
    cmd = "$ch:POSition $lev"
    value = write(obj.handle, cmd)
end

function get_trig_data(obj::TDS2002B, trig)
    trig = obj.instr_dict[trig]
    cmd = "$trig?"
    value = strip(query(obj.handle, cmd))
end

function get_meas_data(obj::TDS2002B, Meas_Nr1)
    nr = obj.instr_dict[Meas_Nr1]
    #cmd = "*OPC?"
    #value = strip(query(obj.handle, cmd))
    cmd = "MEASUrement:MEAS$nr:VALUE?"
    value = strip(query(obj.handle, cmd))
end

# set OSC settings low access functions
function set_vertical_scale(obj::TDS2002B, ch, value)
    ch = obj.instr_dict[ch]
    cmd = "$ch:SCAle $value"
    write(obj.handle, cmd)
end

function set_horizontal_scale(obj::TDS2002B, value)
    cmd = "HORizontal:MAIn:SCAle $value"
    write(obj.handle, cmd)
end

function set_trig_ch(obj::TDS2002B, ch)
    ch = obj.instr_dict[ch]
    cmd = "TRIGger:MAIn:EDGE:SOUrce $ch"
    write(obj.handle, cmd)
end

function set_trig_level(obj::TDS2002B, level)
    cmd = "TRIGger:MAIn:LEVel $level"
    write(obj.handle, cmd)
end

function set_trig_mode(obj::TDS2002B, mode)
    cmd = "TRIGger:MAIn:MODe $mode"            # AUTO or NORMal
    write(obj.handle, cmd)
end

function set_meas_ch(obj::TDS2002B, Meas_Nr1, ch)
    nr = obj.instr_dict[Meas_Nr1]
    ch = obj.instr_dict[ch]
    cmd = "MEASUrement:MEAS$nr:SOUrce $ch"
    write(obj.handle, cmd)
end

function set_meas_type(obj::TDS2002B, Meas_Nr1, Type)
    nr = obj.instr_dict[Meas_Nr1]
    cmd = "MEASUrement:MEAS$nr:TYPe $Type"
    write(obj.handle, cmd)
end

function set_meas(obj::TDS2002B, Meas_Nr1, ch, Type)
    set_meas_ch(obj,Meas_Nr1, ch)
    set_meas_type(obj, Meas_Nr1, Type)
end

# select channel for acq and config
function conf_acq_ch(obj::TDS2002B, ch)
	ch = obj.instr_dict[ch]
    write(obj.handle, "SELect:$ch ON")
	write(obj.handle, "DATa:SOUrce $ch;DATa:ENCdg SRIBINARY;DATa:WIDth 1;DATa:STARt 1;DATa:STOP 2500")
	write(obj.handle, "CURVE?")
end



function Trigger_Aquistion(obj::TDS2002B, ch)
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
