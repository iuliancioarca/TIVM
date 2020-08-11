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


