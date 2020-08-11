mutable struct GDM8246_Meas
	primary
	secondary
end
GDM8246_Meas() = GDM8246_Meas("000.000", "----.---")

mutable struct GDM8246_Sett
    range
end
GDM8246_Sett() = GDM8246_Sett("na")
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

mutable struct GDM8246_Conf
    selected_channel
    selected_func
    crt_value
end
GDM8246_Conf() = GDM8246_Conf("C1", "na", 0.0)
