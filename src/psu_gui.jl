function ShowPSUWindow(psu, psu_conf, rev_state_dict, refresh_cnt)
	CImGui.Begin("PST3201 Power supply")
	# DRAW DISPLA INFO
	draw_psu_info("CH1", " ", psu_conf.C1.volt_meas, "V",
					psu_conf.C1.curr_meas, "A")
	draw_psu_info("CH2", " ", psu_conf.C2.volt_meas, "V",
					psu_conf.C2.curr_meas, "A")
	draw_psu_info("CH3", " ", psu_conf.C3.volt_meas, "V",
					psu_conf.C3.curr_meas, "A")

	CImGui.Text("")
	
	draw_psu_info("SET", "   ", "CH1", "    ",
					"CH2", "    ","CH3")						
	draw_psu_info("Volt.", psu_conf.C1.volt_set, "V",
					psu_conf.C2.volt_set, "V",
					psu_conf.C3.volt_set, "V")
	draw_psu_info("Curr.", psu_conf.C1.curr_set, "A",
					psu_conf.C2.curr_set, "A",
					psu_conf.C3.curr_set, "A")						
	draw_psu_info("O.V.P", psu_conf.C1.ovp_set, "V",
					psu_conf.C2.ovp_set, "V",
					psu_conf.C3.ovp_set, "V")						
	draw_psu_info("O.C.P", " ", psu_conf.C1.ocp_set,
					"    ", psu_conf.C2.ocp_set,
					"    ", psu_conf.C3.ocp_set,)
	CImGui.Text("")
	
	# DRAW BUTTONS
	CImGui.Text("OVP RST ")
	CImGui.SameLine(), CImGui.Text("  CH1  ")
	CImGui.SameLine(), CImGui.Text(" CH2  ")
	CImGui.SameLine(), CImGui.Text("  CH3  ")
	
	CImGui.Button("  OCP  ") && begin
		if psu_conf.shift_btn.state == true
			reset_protections(psu);
		else # toggle OCP
			psu_conf.ocp_state = get_curr_protection(psu, psu_conf.crt_chan);
			crt_state = rev_state_dict[psu_conf.ocp_state];
			set_curr_protection(psu, psu_conf.crt_chan,crt_state);
		end
	end
	
	CImGui.SameLine()
	CImGui.Button(" VSET ") && begin
		psu_conf.shift_btn.state ? psu_conf.crt_chan = "C1" : psu_conf.crt_func = "voltage"
	end
	
	CImGui.SameLine()
	CImGui.Button("ISET ") && begin
		psu_conf.shift_btn.state ? psu_conf.crt_chan = "C2" : psu_conf.crt_func = "current"
	end
	
	CImGui.SameLine()
	CImGui.Button("OVPSET ") && begin
		psu_conf.shift_btn.state ? psu_conf.crt_chan = "C3" : psu_conf.crt_func = "OVP"
	end
	
	# Draw SHIFT					
	psu_conf.shift_btn, pressed = draw_toggle_button(psu_conf.shift_btn)
	
	# Draw OUTPUT
	CImGui.SameLine()
	psu_conf.output_btn, pressed = draw_toggle_button(psu_conf.output_btn)
	pressed && set_outp(psu, psu_conf.crt_chan, rev_state_dict[psu_conf.output_state])

	
	# Draw ENTER
	CImGui.SameLine()
	CImGui.Button("ENTER") && begin
		if psu_conf.crt_func == "voltage"
			set_source_lev(psu, psu_conf.crt_chan, psu_conf.crt_value);
		elseif psu_conf.crt_func == "current"
			set_max_curr(psu, psu_conf.crt_chan, psu_conf.crt_value);
		elseif psu_conf.crt_func == "OVP"
			set_volt_protection(psu, psu_conf.crt_chan, psu_conf.crt_value);
		else
			@error "Brace yourself!"
		end
	end
	
	# Draw REFRESH
	CImGui.SameLine()
	psu_conf.refresh_btn, pressed = draw_toggle_button(psu_conf.refresh_btn)			
	psu_conf.refresh_btn.state && @async update_psu_conf!(psu_conf, psu, refresh_cnt)
	
	# Draw INPUT BOX
	@c CImGui.InputDouble("", &psu_conf.crt_value, 0.01, 1.0, "%.4f")
		
	CImGui.End()
	return psu_conf
end

