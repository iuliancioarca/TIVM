
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
    window = GLFW.CreateWindow(600, 400, "GW INSTEK GDM-8246 Programmable DMM")
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

function update_gdm8246_state!(gdm8246_meas, gdm8246_sett, dmm::GDM8246, refresh_cnt)
    base = 10
    # measurements
    (refresh_cnt==base*1) && (gdm8246_meas.primary = get_primary_measurement(dmm, gdm8246_conf.selected_channel))
    (refresh_cnt==base*3) && begin
    if gdm8246_conf.selected_func == "RIPPLE"
        gdm8246_meas.secondary = get_secondary_measurement(dmm, gdm8246_conf.selected_channel)
    else
        gdm8246_meas.secondary = "----.---"
    end
    end
    # get current function
    (refresh_cnt==base*5) && (gdm8246_conf.selected_func = get_sense_func(dmm, gdm8246_conf.selected_channel))
    # get range
    #(refresh_cnt==base*8) && (gdm8246_sett.range = get_sense_range_auto(dmm, gdm8246_conf.selected_channel))
end
