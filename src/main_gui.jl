using GenericInstruments
using GenericInstruments: viWrite, query, viRead,viRead!
using CImGui
using CImGui.CSyntax
using CImGui.CSyntax.CStatic
using CImGui.GLFWBackend
using CImGui.OpenGLBackend
using CImGui.GLFWBackend.GLFW
using CImGui.OpenGLBackend.ModernGL


function start_gui(psu)
	window, ctx = init_gui()
    # Main while loop
    try
        clear_color = Cfloat[0.45, 0.55, 0.60, 1.00]
		fps = 200
		refresh_cnt = 0
		refresh_cnt_max = 110
		rev_state_dict = Dict("on"=>"off", "off"=>"on")
		# instantiate instr objects
		psu_conf = PST3201Conf()
        while !GLFW.WindowShouldClose(window)
			refresh_cnt == refresh_cnt_max && (refresh_cnt=0)
			refresh_cnt = refresh_cnt + 1
			
			GLFW.PollEvents()
			# start the Dear ImGui frame
			ImGui_ImplOpenGL3_NewFrame()
			ImGui_ImplGlfw_NewFrame()
			CImGui.NewFrame()
			
			# Display checkboxes for activating instrument front panels
			#show_psu, show_dmm, show_fgen, show_scope = 
			#		ShowMenuWindow(show_psu, show_dmm, show_fgen, show_scope)
					
			psu_conf = ShowMenuWindow(psu_conf)
					
			# DISPLAY INSTRUMENTS FRONT PANELS
			psu_conf.active && (psu_conf = ShowPSUWindow(psu, psu_conf, rev_state_dict, refresh_cnt))
			#show_dmm && ShowDMMWindow(&show_dmm)
			#show_fgen && ShowFGENWindow(&show_fgen)
			#show_scope && ShowSCOPEWindow(&show_scope)
			
			# RENDER GUI
			render_gui(window, clear_color; fps=fps)
		end
    catch e
        @error "Error in renderloop!" exception=e
        Base.show_backtrace(stderr, catch_backtrace())
    finally
        destroy_gui(ctx,window)       
    end
end
