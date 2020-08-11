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

# visa goodies
include("visa_utils.jl")

# PSU
include("PST3201/PST3201_driver.jl")
include("PST3201/PST3201_utils.jl")
include("PST3201/PST3201_types.jl")
include("PST3201/PST3201_gui.jl")

# PSU
include("GDM8246/GDM8246_driver.jl")
include("GDM8246/GDM8246_utils.jl")
include("GDM8246/GDM8246_types.jl")
include("GDM8246/GDM8246_gui.jl")


export connect!, disconnect!, write, read, query

end
