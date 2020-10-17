function ShowRelaysWindow(relays, relays_conf, refresh_cnt, base)
	rev_state_dict = Dict(true=>"on", false=>"off", "on"=>true, "off"=>false)
	
	CImGui.Begin("TIVM setup relays")	
	# DRAW BUTTONS
	CImGui.Text("  C1   ")
	CImGui.SameLine()
	relays_conf.C1, pressed = draw_toggle_button(relays_conf.C1)
	pressed && @async set_state(relays, "C1", rev_state_dict[relays_conf.C1.state])
	
	CImGui.Text("  C2   ")
	CImGui.SameLine()
	relays_conf.C2, pressed = draw_toggle_button(relays_conf.C2)
	pressed && @async set_state(relays, "C2", rev_state_dict[relays_conf.C2.state])
	
	CImGui.Text("  C3   ")
	CImGui.SameLine()
	relays_conf.C3, pressed = draw_toggle_button(relays_conf.C3)
	pressed && @async set_state(relays, "C3", rev_state_dict[relays_conf.C3.state])
	
	CImGui.Text("  C4   ")
	CImGui.SameLine()
	relays_conf.C4, pressed = draw_toggle_button(relays_conf.C4)
	pressed && @async set_state(relays, "C4", rev_state_dict[relays_conf.C4.state])
	
	CImGui.Text("  C5   ")
	CImGui.SameLine()
	relays_conf.C5, pressed = draw_toggle_button(relays_conf.C5)
	pressed && @async set_state(relays, "C5", rev_state_dict[relays_conf.C5.state])
	
	CImGui.Text("  C6   ")
	CImGui.SameLine()
	relays_conf.C6, pressed = draw_toggle_button(relays_conf.C6)
	pressed && @async set_state(relays, "C6", rev_state_dict[relays_conf.C6.state])
	
	CImGui.Text("  C7   ")
	CImGui.SameLine()
	relays_conf.C7, pressed = draw_toggle_button(relays_conf.C7)
	pressed && @async set_state(relays, "C7", rev_state_dict[relays_conf.C7.state])
	
	CImGui.Text("  C8   ")
	CImGui.SameLine()
	relays_conf.C8, pressed = draw_toggle_button(relays_conf.C8)
	pressed && @async set_state(relays, "C8", rev_state_dict[relays_conf.C8.state])
	
	CImGui.Text("  C9   ")
	CImGui.SameLine()
	relays_conf.C9, pressed = draw_toggle_button(relays_conf.C9)
	pressed && @async set_state(relays, "C9", rev_state_dict[relays_conf.C9.state])	
	
	CImGui.Text("Refresh")
	CImGui.SameLine()
	relays_conf.Refresh, pressed = draw_toggle_button(relays_conf.Refresh)
	pressed && @async begin
			relays_conf.C1.state = rev_state_dict[get_state(relays, "C1")]
			relays_conf.C2.state = rev_state_dict[get_state(relays, "C2")]
			relays_conf.C3.state = rev_state_dict[get_state(relays, "C3")]
			relays_conf.C4.state = rev_state_dict[get_state(relays, "C4")]
			relays_conf.C5.state = rev_state_dict[get_state(relays, "C5")]
			relays_conf.C6.state = rev_state_dict[get_state(relays, "C6")]
			relays_conf.C7.state = rev_state_dict[get_state(relays, "C7")]
			relays_conf.C8.state = rev_state_dict[get_state(relays, "C8")]
			relays_conf.C9.state = rev_state_dict[get_state(relays, "C9")]
		end
	CImGui.End()
	return relays_conf
end

