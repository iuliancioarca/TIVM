mutable struct PST3201_Meas
    ch1_volt
    ch2_volt
    ch3_volt
    ch1_curr
    ch2_curr
    ch3_curr
end
PST3201_Meas() = PST3201_Meas("00.000", "00.000", "00.000",
                                "00.000", "00.000","00.000")

mutable struct PST3201_Sett
    ch1_volt
    ch2_volt
    ch3_volt
    ch1_curr
    ch2_curr
    ch3_curr
    ch1_ovp
    ch2_ovp
    ch3_ovp
    ch1_ocp
    ch2_ocp
    ch3_ocp
end
PST3201_Sett() = PST3201_Sett("00.000", "00.000", "00.000",
                                "00.000", "00.000","00.000",
                                "00.000", "00.000","00.000",
                                "off", "off","off")
mutable struct CImGuiToggleButton
    name
    state
    off_color
    on_color
    hover_color
end
CImGuiToggleButton(name) = CImGuiToggleButton(name, false,
                        (0.1, 0.7, 0.7), (0.3, 0.9, 0.9), (0.2, 0.7, 0.7))
function toggle_state!(x::CImGuiToggleButton)
    x.state = !x.state
    return nothing
end

mutable struct PST3201_Conf
    selected_channel
    selected_func
    crt_value
    ocp_on
end
PST3201_Conf() = PST3201_Conf("C1", "voltage", 0.0, "off")
