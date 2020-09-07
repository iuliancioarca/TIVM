
function start_gui(;psu_handle=0, dmm_handle=0, fgen_handle=0, scope_handle=0, relays_handle=0) #use keyword arguments
	window, ctx = init_gui()
    # Main while loop
    try
        clear_color = Cfloat[0.45, 0.55, 0.60, 1.00]
		fps = 200
		refresh_cnt = 0
		refresh_cnt_max = 105
		rev_state_dict = Dict("on"=>"off", "off"=>"on")
		# instantiate instr objects
		psu = PST3201(psu_handle)
		dmm = GDM8246(dmm_handle)
		fgen = GFG3015(fgen_handle)
		scope = TDS2002B(scope_handle)      #Daniel
		relays = relays_handle
		# instantiate gui conf objects
		psu_conf = PST3201Conf()
		dmm_conf = GDM8246Conf()
		fgen_conf = GFG3015Conf()
		scope_conf = TDS2002BConf()            #Daniel
		relays_conf = RelaysConf()            #Daniel
        while !GLFW.WindowShouldClose(window)
			refresh_cnt == refresh_cnt_max && (refresh_cnt=0)
			refresh_cnt = refresh_cnt + 1
			
			GLFW.PollEvents()
			# start the Dear ImGui frame
			ImGui_ImplOpenGL3_NewFrame()
			ImGui_ImplGlfw_NewFrame()
			CImGui.NewFrame()
			
			# Display checkboxes for activating instrument front panels
			psu_conf, dmm_conf, fgen_conf, scope_conf, relays_conf = ShowMenuWindow(psu_conf, dmm_conf, fgen_conf, scope_conf, relays_conf)		#Daniel		
					
			# DISPLAY INSTRUMENTS FRONT PANELS
			psu_conf.active && (psu_conf = ShowPSUWindow(psu, psu_conf, rev_state_dict, refresh_cnt))
			dmm_conf.active && (dmm_conf = ShowDMMWindow(dmm, dmm_conf, rev_state_dict, refresh_cnt))
			fgen_conf.active && (fgen_conf = ShowFGENWindow(fgen, fgen_conf, rev_state_dict, refresh_cnt))
			scope_conf.active && (scope_conf = ShowSCOPEWindow(scope, scope_conf, rev_state_dict, refresh_cnt))            #Daniel
			relays_conf.active && (relays_conf = ShowRelaysWindow(relays, relays_conf, refresh_cnt))
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
