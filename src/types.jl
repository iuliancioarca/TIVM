mutable struct CImGuiToggleButton	
    on_name
	off_name
	name
    state
    off_color
    on_color
    hover_color
end
# Outer constructor
CImGuiToggleButton(on_name, off_name) = CImGuiToggleButton(on_name, off_name, off_name, false,
                        (0.1, 0.7, 0.7), (0.3, 0.9, 0.9), (0.2, 0.7, 0.7))
function toggle!(x::CImGuiToggleButton)
    x.state = !x.state
	if x.state
		x.name = x.on_name
	else
		x.name = x.off_name
	end
    return nothing
end


mutable struct PSUChannel
	volt_meas
	curr_meas
	volt_set
	curr_set
	ovp_set
	ocp_set
end
# Outer constructor
PSUChannel() = PSUChannel(repeat(["00.000"], 5)..., "off")


mutable struct PST3201Conf
	active
	C1::PSUChannel
	C2::PSUChannel
	C3::PSUChannel
	output_state
	crt_chan
    crt_func
    crt_value
    ocp_state
	shift_btn
	output_btn
	refresh_btn
end
# Outer constructor
PST3201Conf() = PST3201Conf(false,
					PSUChannel(), PSUChannel(), PSUChannel(),
					"off",
					"C1",
					"voltage",
					0.0,
					"na",
					CImGuiToggleButton(" SHIFT ", " SHIFT "),
					CImGuiToggleButton("OUTPUT", "OUTPUT"),
					CImGuiToggleButton("REFRESH", "REFRESH")
					)


# DMM
mutable struct GDM8246Conf
	active
	primary
	secondary
	range
	crt_chan
    crt_func
    crt_value
	shift_btn
	auto_btn
	refresh_btn
end
# Outer constructor
GDM8246Conf() = GDM8246Conf(false, "000.000", "----.---", "na", "C1", "na", 0.0,
					CImGuiToggleButton(" SHIFT ", " SHIFT "),
					CImGuiToggleButton("  AUTO  ", "  AUTO  "),
					CImGuiToggleButton("REFRESH", "REFRESH")
					)

# FGEN
mutable struct GFG3015Conf
	active
	idx_sel
	crt_chan
    crt_func
    crt_value
	amplit_unit
	freq
	amplit
	offs
	duty
	shift_btn
	refresh_btn
end
# Outer constructor
GFG3015Conf() = GFG3015Conf(false, "1", "C1", "na", 0.0, "Vpp", "na","na","na","na",
					CImGuiToggleButton(" SHIFT ", " SHIFT "),
					CImGuiToggleButton("REFRESH", "REFRESH")
					)


#scope 
mutable struct TDS2002BConf
	active
	CH1_Volt_div
	CH1_Offset
	CH2_Volt_div
	CH2_Offset
	Time_div
	Trigger_source
	Trigger_level
	Trigger_mode           #triggered or imediate
	CH1_Volt_div_new
	CH1_Offset_new
	CH2_Volt_div_new
	CH2_Offset_new
	Time_div_new
	Trigger_source_new
	Trigger_level_new
	Trigger_mode_new
	Acquire
	Acquire_btn
	t
	y1
	y2
	Measurement_source1
	Measurement_Type1
	Measurement_Value1
	Measurement_source2
	Measurement_Type2
	Measurement_Value2
	Measurement_source3
	Measurement_Type3
	Measurement_Value3
	Measurement_source4
	Measurement_Type4
	Measurement_Value4
	Measurement_source5
	Measurement_Type5
	Measurement_Value5
	end
					# Outer constructor
	TDS2002BConf() = TDS2002BConf(false,
				"1.00", 
				"0.00", 
				"1.00",
				"0.00", 
				"0.001",    #in seconds
				"CH1",
				"01.00",
				"AUTO",
				00.00,   #CH1_Volt_div_new
				00.00,   #CH1_Offset_new
				00.00,   #CH2_Volt_div_new
				00.00,   #CH2_Offset_new
				00.000,    #Time_div_new
				"CH1",   
				00.00,
				"AUTO" ,
				"off",
				CImGuiToggleButton("ACQUIRE", "ACQUIRE"),
				collect(1:300),
				randn(300),
				randn(300),
				"CH1",
				"Maximum",
				"00.00",
				"CH1",
				"Maximum",
				"00.00",
				"CH1",
				"Maximum",
				"00.00",
				"CH1",
				"Maximum",
				"00.00",
				"CH1",
				"Maximum",
				"00.00"
				)

# RELAYS matrix
mutable struct RelaysConf
	active
	C1
	C2
	C3
	C4
	C5
	C6
	C7
	C8
	C9
	Refresh
end
# Outer constructor
RelaysConf() = RelaysConf(false,
					CImGuiToggleButton("ON ##C1", "OFF##C1"),
					CImGuiToggleButton("ON ##C2", "OFF##C2"),
					CImGuiToggleButton("ON ##C3", "OFF##C3"),
					CImGuiToggleButton("ON ##C4", "OFF##C4"),
					CImGuiToggleButton("ON ##C5", "OFF##C5"),
					CImGuiToggleButton("ON ##C6", "OFF##C6"),
					CImGuiToggleButton("ON ##C7", "OFF##C7"),
					CImGuiToggleButton("ON ##C8", "OFF##C8"),
					CImGuiToggleButton("ON ##C9", "OFF##C9"),
					CImGuiToggleButton("ON ##Refresh", "OFF##Refresh")
					)