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
using Random
using Statistics

const GI = GenericInstruments

# check psu variable
try
	psu = Main.psu
catch
	@warn "please connect psu first"
end

# VISA 
include("visa_utils.jl")

# TYPES
include("types.jl")

# PST3201
include("PST3201_driver.jl")
include("PST3201_utils.jl")

# GUI
include("gui_utils.jl")
include("psu_gui.jl")

include("main_gui.jl")



export connect!, disconnect!, write, read, query

end
