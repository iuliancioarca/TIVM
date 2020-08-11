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
    window = GLFW.CreateWindow(600, 600, "Lab Instruments")
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


#function ShowMenuWindow(show_psu, show_dmm, show_fgen, show_scope)
#	CImGui.Begin("Menu")
#		@c CImGui.Checkbox("psu", &show_psu)
#		CImGui.SameLine(), @c CImGui.Checkbox("dmm", &show_dmm)
#		CImGui.SameLine(), @c CImGui.Checkbox("fgen", &show_fgen)
#		CImGui.SameLine(), @c CImGui.Checkbox("scope", &show_scope)
#	CImGui.End()
#	return show_psu, show_dmm, show_fgen, show_scope
#end


function ShowMenuWindow(x)
	CImGui.Begin("Menu")
		@c CImGui.Checkbox("psu", &x.active)
	CImGui.End()
	return x
end


function draw_psu_info(args...)
	CImGui.Text(args[1])
	for arg in args[2:end]
		CImGui.SameLine(), CImGui.Text(arg)
	end
	return nothing
end

function draw_toggle_button(button)
	# hack for toggle button
	if button.state == false
		CImGui.PushID(1)
		CImGui.PushStyleColor(CImGui.ImGuiCol_Button, CImGui.HSV(button.off_color...))
		CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonHovered, CImGui.HSV(button.hover_color...))
		CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonActive, CImGui.HSV(button.off_color...))
	else
		CImGui.PushID(1)
		CImGui.PushStyleColor(CImGui.ImGuiCol_Button, CImGui.HSV(button.on_color...))
		CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonHovered, CImGui.HSV(button.hover_color...))
		CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonActive, CImGui.HSV(button.on_color...))
	end
	pressed = CImGui.Button(button.name) 
	pressed && toggle!(button)	
	
	CImGui.PopStyleColor(3)
	CImGui.PopID()
	return button, pressed
end

