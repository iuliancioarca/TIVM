mutable struct CImGuiToggleButton
    name
    state
    off_color
    on_color
    hover_color
end
# Outer constructor
CImGuiToggleButton(name) = CImGuiToggleButton(name, false,
                        (0.1, 0.7, 0.7), (0.3, 0.9, 0.9), (0.2, 0.7, 0.7))
function toggle!(x::CImGuiToggleButton)
    x.state = !x.state
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
					CImGuiToggleButton(" SHIFT "),
					CImGuiToggleButton("OUTPUT"),
					CImGuiToggleButton("REFRESH")
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
					CImGuiToggleButton(" SHIFT "),
					CImGuiToggleButton("  AUTO  "),
					CImGuiToggleButton("REFRESH")
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
					CImGuiToggleButton(" SHIFT "),
					CImGuiToggleButton("REFRESH")
					)


#scope 
mutable struct TDS2002BConf
	active
	CH1_Volt_div
	CH2_Volt_div
	Time_div
	Trigger_source
	Trigger_level
	Trigger_mode           #triggered or imediate
	Measurement_source
	Measurement_Type
	Measurement_Value
	CH1_Volt_div_new
	CH2_Volt_div_new
	Time_div_new
	Trigger_source_new
	Trigger_level_new
	Trigger_mode_new
	Acquire
	Acquire_btn
	t
	y1
	y2
	end
					# Outer constructor
	TDS2002BConf() = TDS2002BConf(false,
				"1.00", 
				"1.00",
				"0.001",    #in seconds
				"CH1",
				"1.00",
				"AUTO",
				"CH1",
				"Maximum",
				"00.00",
				00.00,   #CH1_Volt_div_new
				00.00,   #CH2_Volt_div_new
				00.000,    #Time_div_new
				"CH1",   
				00.00,
				"AUTO" ,
				"off",
				CImGuiToggleButton("ACQUIRE"),
				collect(1:300),
				randn(300),
				randn(300)
				)
