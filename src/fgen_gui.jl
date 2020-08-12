function ShowFGENWindow(fgen, fgen_conf, rev_state_dict, refresh_cnt)
	CImGui.Begin("GFG3015 Function Generator")
	# DRAW DISPLAY INFO

	CImGui.Text("Func:"), CImGui.SameLine(), CImGui.Text(fgen_conf.crt_func)
	CImGui.Text("Freq:")
	CImGui.SameLine(), CImGui.Text(fgen_conf.freq)
	CImGui.SameLine(), CImGui.Text("Hz")
	CImGui.Text("Ampl:")
	CImGui.SameLine(), CImGui.Text(fgen_conf.amplit)
	CImGui.SameLine(), CImGui.Text(fgen_conf.amplit_unit)
	CImGui.Text("Offs:")
	CImGui.SameLine(), CImGui.Text(fgen_conf.offs)
	CImGui.SameLine(), CImGui.Text(fgen_conf.amplit_unit)
	CImGui.Text("Duty:")
	CImGui.SameLine(), CImGui.Text(fgen_conf.duty)
	CImGui.SameLine(), CImGui.Text("%")
				

	CImGui.Text("EDIT ")
	@c CImGui.InputDouble("", &fgen_conf.crt_value, 0.01, 1.0, "%.4f")

	CImGui.Button(" FUNC ") && begin
		# toggle between the three functions
		toggle_func!(fgen, fgen_conf)
	end
	CImGui.SameLine(),CImGui.Button(" AMPL ") && begin
		set_amplit(fgen, fgen_conf.crt_chan, fgen_conf.crt_value)
	end
	CImGui.SameLine(),CImGui.Button(" DUTY ") && begin
		set_duty(fgen, fgen_conf.crt_chan, fgen_conf.crt_value)
	end

	CImGui.Button(" FREQ ") && begin
		# toggle between the three functions
		set_freq(fgen, fgen_conf.crt_chan, fgen_conf.crt_value)
	end
	CImGui.SameLine(),CImGui.Button("OFFSET") && begin
		set_offs(fgen, fgen_conf.crt_chan, fgen_conf.crt_value)
	end
	CImGui.SameLine(),CImGui.Button("MOD ON") && begin
		# don't need
	end

	CImGui.SameLine()

	# Draw REFRESH
	CImGui.SameLine()
	fgen_conf.refresh_btn, pressed = draw_toggle_button(fgen_conf.refresh_btn)			
	fgen_conf.refresh_btn.state && @async update_fgen_conf!(fgen_conf, fgen, refresh_cnt)

	CImGui.End()
	return fgen_conf
end

