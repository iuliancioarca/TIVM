
function render_gui(window, clear_color; fps)
    CImGui.Render()
    GLFW.MakeContextCurrent(window)
    display_w, display_h = GLFW.GetFramebufferSize(window)
    glViewport(0, 0, display_w, display_h)
    glClearColor(clear_color...)
    glClear(GL_COLOR_BUFFER_BIT)
    ImGui_ImplOpenGL3_RenderDrawData(CImGui.GetDrawData())
    GLFW.MakeContextCurrent(window)
    GLFW.SwapBuffers(window)
    sleep(1/fps) # hacky update rate
end

function destroy_gui(ctx, window)
    ImGui_ImplOpenGL3_Shutdown()
    ImGui_ImplGlfw_Shutdown()
    CImGui.DestroyContext(ctx)
    GLFW.DestroyWindow(window)
end

function init_gui()
    @static if Sys.isapple()
        # OpenGL 3.2 + GLSL 150
        glsl_version = 150
        GLFW.WindowHint(GLFW.CONTEXT_VERSION_MAJOR, 3)
        GLFW.WindowHint(GLFW.CONTEXT_VERSION_MINOR, 2)
        GLFW.WindowHint(GLFW.OPENGL_PROFILE, GLFW.OPENGL_CORE_PROFILE) # 3.2+ only
        GLFW.WindowHint(GLFW.OPENGL_FORWARD_COMPAT, GL_TRUE) # required on Mac
    else
        # OpenGL 3.0 + GLSL 130
        glsl_version = 130
        GLFW.WindowHint(GLFW.CONTEXT_VERSION_MAJOR, 3)
        GLFW.WindowHint(GLFW.CONTEXT_VERSION_MINOR, 0)
        # GLFW.WindowHint(GLFW.OPENGL_PROFILE, GLFW.OPENGL_CORE_PROFILE) # 3.2+ only
        # GLFW.WindowHint(GLFW.OPENGL_FORWARD_COMPAT, GL_TRUE) # 3.0+ only
    end

    # setup GLFW error callback
    error_callback(err::GLFW.GLFWError) = @error "GLFW ERROR: code $(err.code) msg: $(err.description)"
    GLFW.SetErrorCallback(error_callback)

    # create window
    window = GLFW.CreateWindow(800, 400, "GW INSTEK PST-3201 Programmable Power Supply")
    @assert window != C_NULL
    
    GLFW.MakeContextCurrent(window)
    GLFW.SwapInterval(1)  # enable vsync

    # setup Dear ImGui context
    ctx = CImGui.CreateContext()
    CImGui.StyleColorsClassic()
    fonts_dir = joinpath(@__DIR__, "..", "fonts")
    fonts = CImGui.GetIO().Fonts
    CImGui.AddFontFromFileTTF(fonts, joinpath(fonts_dir, "Roboto-Medium.ttf"), 16)

    # setup Platform/Renderer bindings
    ImGui_ImplGlfw_InitForOpenGL(window, true)
    ImGui_ImplOpenGL3_Init(glsl_version)
    # CImGui.SetWindowFontScale(Cfloat(2.0)) # crashes julia
    return window, ctx
end

# this is slow due to mutiple queries over the bus
function update_pst3201_state!(pst3201_meas, pst3201_sett, psu::PST3201, refresh_cnt)
	 base = 10
     # Meas Voltage more often
     (refresh_cnt==base*1 || refresh_cnt==base*7) && (pst3201_meas.ch1_volt = get_meas(psu, "C1", "voltage"))
     (refresh_cnt==base*2 || refresh_cnt==base*8) && (pst3201_meas.ch2_volt = get_meas(psu, "C2", "voltage"))
     (refresh_cnt==base*3 || refresh_cnt==base*9) && (pst3201_meas.ch3_volt = get_meas(psu, "C3", "voltage"))
     # # Meas Current more often
     (refresh_cnt==base*4 || refresh_cnt==base*13) && (pst3201_meas.ch1_curr = get_meas(psu, "C1", "current"))
     (refresh_cnt==base*5 || refresh_cnt==base*14) && (pst3201_meas.ch2_curr = get_meas(psu, "C2", "current"))
     (refresh_cnt==base*6 || refresh_cnt==base*15) && (pst3201_meas.ch3_curr = get_meas(psu, "C3", "current"))
     # # Update settings
     # # Voltage
     refresh_cnt==base*7 && (pst3201_sett.ch1_volt = get_source_lev(psu, "C1"))
     refresh_cnt==base*8 && (pst3201_sett.ch2_volt = get_source_lev(psu, "C2"))
     refresh_cnt==base*9 && (pst3201_sett.ch3_volt = get_source_lev(psu, "C3"))
     # # Max Current
     refresh_cnt==base*10 && (pst3201_sett.ch1_curr = get_max_curr(psu, "C1"))
     refresh_cnt==base*11 && (pst3201_sett.ch2_curr = get_max_curr(psu, "C2"))
     refresh_cnt==base*12 && (pst3201_sett.ch3_curr = get_max_curr(psu, "C3"))
     # # OVP
     refresh_cnt==base*13 && (pst3201_sett.ch1_ovp = get_volt_protection(psu, "C1"))
     refresh_cnt==base*14 && (pst3201_sett.ch2_ovp = get_volt_protection(psu, "C2"))
     refresh_cnt==base*15 && (pst3201_sett.ch3_ovp = get_volt_protection(psu, "C3"))          
     # # OCP
     refresh_cnt==base*16 && (pst3201_sett.ch1_ocp = get_curr_protection(psu, "C1"))
     refresh_cnt==base*17 && (pst3201_sett.ch2_ocp = get_curr_protection(psu, "C2"))
     refresh_cnt==base*18 && (pst3201_sett.ch3_ocp = get_curr_protection(psu, "C3"))
end

# function update_pst3201_state!(pst3201_meas, pst3201_sett, psu::PST3201, refresh_cnt)
#     base = 10
#     # read in chunks
# 	cmd_meas = ":CHAN1:MEAS:VOLT?;:CHAN2:MEAS:VOLT?;:CHAN3:MEAS:VOLT?;
#            :CHAN1:MEAS:CURR?;:CHAN2:MEAS:CURR?;:CHAN3:MEAS:CURR?;\n"    
#     cmd_set = ":CHAN1:VOLT?;:CHAN2:VOLT?;:CHAN3:VOLT?;
#            :CHAN1:CURR?;:CHAN2:CURR?;:CHAN3:CURR?;\n"
#     cmd_prot = ":CHAN1:PROT:VOLT?;:CHAN2:PROT:VOLT?;:CHAN3:PROT:VOLT?;
#             :CHAN1:PROT:CURR?;:CHAN2:PROT:CURR?;:CHAN3:PROT:CURR?\n";
# 	# configure End Mode Reads to NONE(0) in order to read the full buffer for multiple queries
# 	GenericInstruments.viSetAttribute(psu.handle, GenericInstruments.VI_ATTR_ASRL_END_IN, 0)

#     #flush read buffer
#     GenericInstruments.viFlush(psu.handle, GenericInstruments.VI_READ_BUF_DISCARD)
#     (refresh_cnt==base*1) && begin
#         viWrite(psu.handle, cmd_meas)
#         raw_meas = viRead(psu.handle;bufSize=UInt32(6*6))
#         raw_meas = split(raw_meas, '\n')
#         # Meas Voltage
#         pst3201_meas.ch1_volt = raw_meas[1]
#         pst3201_meas.ch2_volt = raw_meas[2]
#         pst3201_meas.ch3_volt = raw_meas[3]
#         # # Meas Current
#         pst3201_meas.ch1_curr = raw_meas[4]
#         pst3201_meas.ch2_curr = raw_meas[5]
#         pst3201_meas.ch3_curr = raw_meas[6]
#     end
# 	# (refresh_cnt==base*5) && begin
#     #     viWrite(psu.handle, cmd_set)
#     #     raw_set = viRead(psu.handle;bufSize=UInt32(6*6))
#     #     raw_set = split(raw_set, '\n')
#     #     # # Update settings
#     #     # # Voltage
#     #     pst3201_sett.ch1_volt = raw_set[1]
#     #     pst3201_sett.ch2_volt = raw_set[2]
#     #     pst3201_sett.ch3_volt = raw_set[3]
#     #     # # Max Current
#     #     pst3201_sett.ch1_curr = raw_set[4]
#     #     pst3201_sett.ch2_curr = raw_set[5]
#     #     pst3201_sett.ch3_curr = raw_set[6]
#     # end
#     # (refresh_cnt==base*10) && begin
#     #     viWrite(psu.handle, cmd_prot)
#     #     raw_prot = viRead(psu.handle;bufSize=UInt32(6*6))
#     #     raw_prot = split(raw_prot, '\n')
#     #     # # OVP
#     #     pst3201_sett.ch1_ovp = raw_prot[1]
#     #     pst3201_sett.ch2_ovp = raw_prot[2]
#     #     pst3201_sett.ch3_ovp = raw_prot[3]           
#     #     # # OCP
#     #     pst3201_sett.ch1_ocp = raw_prot[4]
#     #     pst3201_sett.ch2_ocp = raw_prot[5]
#     #     pst3201_sett.ch3_ocp = raw_prot[6]
#     # end
# 	# configure End Mode Reads to Termchar
# 	GenericInstruments.viSetAttribute(psu.handle, GenericInstruments.VI_ATTR_ASRL_END_IN, 2)	
# end