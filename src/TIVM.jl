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

const GI = GenericInstruments

# check psu variable
try
	psu = Main.psu
	dmm = Main.dmm
	fgen = Main.fgen
	scope = Main.scope
catch
	@warn "please connect psu/dmm/fgen/scope first"
end

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

# GUI
include("gui_utils.jl")
include("psu_gui.jl")
include("dmm_gui.jl")
include("fgen_gui.jl")

include("main_gui.jl")


export connect!, disconnect!, write, read, query

end
