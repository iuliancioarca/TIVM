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