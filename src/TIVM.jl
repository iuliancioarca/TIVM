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
using Printf 
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
include("main_gui.jl")


export connect!, disconnect!, write, read, query

end
