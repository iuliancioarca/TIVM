module TIVM

using GenericInstruments
using GenericInstruments: viWrite, query, viRead,viRead!, readavailable
using CImGui
using CImGui.CSyntax
using CImGui.CSyntax.CStatic
using CImGui.GLFWBackend
using CImGui.OpenGLBackend
using CImGui.GLFWBackend.GLFW
using CImGui.OpenGLBackend.ModernGL
using ImPlot
import CImGui.LibCImGui: ImGuiCond_Always, ImGuiCond_Once

const GI = GenericInstruments

# VISA 
include("visa_utils.jl")

# TYPES
include("types.jl")

# PST3201
include("PST3201_driver.jl")
include("PST3201_utils.jl")

# GDM8246 
include("GDM8246_driver.jl")
include("GDM8246_utils.jl")

# GFG3015
include("GFG3015_driver.jl")
include("GFG3015_utils.jl")

# TDS2002B
include("TDS2002B_driver.jl")
include("TDS2002B_utils.jl")
# GUI
include("gui_utils.jl")
include("psu_gui.jl")
include("dmm_gui.jl")
include("fgen_gui.jl")
include("scope_gui.jl")
include("relays_gui.jl")
include("main_gui.jl")

# export utils
export connect!, disconnect!, write, read, viWrite, viRead, query, start_gui, visaRead, visaWrite, find_resources

# export dmm functions
export get_sense_func, set_sense_func, set_sense_range, get_sense_range, set_sense_range_auto, get_sense_range_auto,
	get_primary_measurement, get_secondary_measurement
	
# export psu functions
export set_source_lev, get_source_lev, set_volt_protection, get_volt_protection, set_curr_protection, get_curr_protection,
	set_max_curr, get_max_curr, reset_protections, get_meas, set_outp, get_outp
	
# export fgen functions
export 	set_wfm, get_wfm, set_amplit_unit, get_amplit_unit, set_amplit, get_amplit, set_offs, get_offs, set_freq,
	get_freq, set_duty, get_duty

# export scope functions	
export get_vertical_scale, get_horizontal_scale, get_ch_position, set_ch_position, get_trig_data, get_meas_data, 
	set_vertical_scale, set_horizontal_scale, set_trig_ch, set_trig_level, set_trig_mode, set_meas_ch, set_meas_type,
	set_meas, conf_acq_ch, Trigger_Aquistion

end
