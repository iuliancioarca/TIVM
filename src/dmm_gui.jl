function ShowDMMWindow(dmm, dmm_conf, rev_state_dict, refresh_cnt)
	CImGui.Begin("GDM8246 Digital Multimeter")
	# DRAW DISPLAY INFO
	draw_dmm_info("Secondary", "   Primary")
	draw_dmm_info(dmm_conf.secondary, "mV  ",
					dmm_conf.primary, "V")

	CImGui.Text("            ")
	CImGui.SameLine() 
	draw_dmm_info("RANG:", dmm_conf.range, 
					"FCT:", dmm_conf.crt_func)
					
	# DRAW BUTTONS
	
	draw_dmm_info("  DC mV  ", "  AC mV  ", "  DIODE  ",
		"   REL   ", "   COMP  ", "         ", "   SET   ")
	
	
	CImGui.Button("  DCV   ") && begin
		if dmm_conf.shift_btn.state == false
			set_sense_func(dmm, dmm_conf.crt_chan, "DCV")
		else
			# set the range to mV??????
			#set_sense_func(dmm, dmm_conf.crt_chan, "DCV")
		end
	end

	CImGui.SameLine(),CImGui.Button("  ACV   ")&& begin
		if dmm_conf.shift_btn.state == false
			set_sense_func(dmm, dmm_conf.crt_chan, "ACV")
		else
			# set the range to mV??????
			#set_sense_func(dmm, dmm_conf.crt_chan, "DCV")
		end
	end
	
	CImGui.SameLine(),CImGui.Button("  OHM   ") && begin
		if dmm_conf.shift_btn.state == false
			set_sense_func(dmm, dmm_conf.crt_chan, "OHM")
		else
			set_sense_func(dmm, dmm_conf.crt_chan, "DIODE")
		end
	end
	
	CImGui.SameLine(),CImGui.Button("  CONT  ")
	CImGui.SameLine(),CImGui.Button(" MAX/MIN")
	
	CImGui.SameLine(),CImGui.Button("   UP   ") && begin
		#this should increase reange on current function
	end
	
	CImGui.SameLine()
	# # hack for AUTO/MAN toggle button
	if dmm_conf.auto_btn.state == false
		CImGui.PushID(1)
		CImGui.PushStyleColor(CImGui.ImGuiCol_Button, CImGui.HSV(dmm_conf.auto_btn.off_color...))
		CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonHovered, CImGui.HSV(dmm_conf.auto_btn.hover_color...))
		CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonActive, CImGui.HSV(dmm_conf.auto_btn.off_color...))
		CImGui.Button("  MAN  ") && begin
			dmm_conf.auto_btn.state = !dmm_conf.auto_btn.state
			# toggle autorange on
		end
	else
		CImGui.PushID(1)
		CImGui.PushStyleColor(CImGui.ImGuiCol_Button, CImGui.HSV(dmm_conf.auto_btn.on_color...))
		CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonHovered, CImGui.HSV(dmm_conf.auto_btn.hover_color...))
		CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonActive, CImGui.HSV(dmm_conf.auto_btn.on_color...))
		CImGui.Button(" AUTO  ") && begin
			dmm_conf.auto_btn.state = !dmm_conf.auto_btn.state
			# toggle autorange off
		end
	end
	CImGui.PopStyleColor(3)
	CImGui.PopID()             

	CImGui.Text("    HI   ")
	CImGui.SameLine(), CImGui.Text("   LO    ")
	CImGui.SameLine(), CImGui.Text(" REF OHM ")
	CImGui.SameLine(), CImGui.Text("  RS232  ")           
	CImGui.SameLine(), CImGui.Text("   GPIB   ")    
	CImGui.SameLine(), CImGui.Text("         ")    
	CImGui.SameLine(), CImGui.Text("  ENTER  ") 

	CImGui.Text("  DC 20A ")
	CImGui.SameLine(), CImGui.Text("  AC 20A ")
	CImGui.SameLine(), CImGui.Text("Hz/Ripple")
	CImGui.SameLine(), CImGui.Text("   dBm   ")           
	CImGui.SameLine(), CImGui.Text(" AUTOHOLD")    
	CImGui.SameLine(), CImGui.Text("         ")    
	CImGui.SameLine(), CImGui.Text("   LOCAL  ") 

	CImGui.Button("  DCA   ") && begin
		if dmm_conf.shift_btn.state == false
			set_sense_func(dmm, dmm_conf.crt_chan, "DCA")
		else
			set_sense_func(dmm, dmm_conf.crt_chan, "DCA20")
		end
	end
	
	CImGui.SameLine(),CImGui.Button("  ACA   ") && begin
		if dmm_conf.shift_btn.state == false
			set_sense_func(dmm, dmm_conf.crt_chan, "ACA")
		else
			set_sense_func(dmm, dmm_conf.crt_chan, "ACA20")
		end
	end
	
	CImGui.SameLine(),CImGui.Button(" AC+DC  ") && begin 
		if dmm_conf.shift_btn.state == false
			set_sense_func(dmm, dmm_conf.crt_chan, "RIPPLE")
		else
			@warn "not implemented yet"
			#set_sense_func(dmm, dmm_conf.crt_chan, "ACA20")
		end
	end
	
	CImGui.SameLine(),CImGui.Button("  CAP   ")
	CImGui.SameLine(),CImGui.Button("  HOLD  ")
	
	CImGui.SameLine(),CImGui.Button("  DOWN  ") && begin
		#this should decrease range on current function
	end

	CImGui.SameLine()

	# Draw SHIFT					
	dmm_conf.shift_btn, pressed = draw_toggle_button(dmm_conf.shift_btn)

	# Draw REFRESH
	CImGui.SameLine()
	dmm_conf.refresh_btn, pressed = draw_toggle_button(dmm_conf.refresh_btn)			
	dmm_conf.refresh_btn.state && @async update_dmm_conf!(dmm_conf, dmm, refresh_cnt)

	CImGui.End()
	return dmm_conf
end

