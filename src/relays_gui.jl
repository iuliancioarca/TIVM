function ShowRelaysWindow(relays, relays_conf, refresh_cnt, base)
	CImGui.Begin("TIVM setup relays")	
	# DRAW BUTTONS
	CImGui.Text("C1")
	CImGui.SameLine()
	relays_conf.C1, pressed = draw_toggle_button(relays_conf.C1)
	
	CImGui.Text("C2")
	CImGui.SameLine()
	relays_conf.C2, pressed = draw_toggle_button(relays_conf.C2)
	
	CImGui.Text("C3")
	CImGui.SameLine()
	relays_conf.C3, pressed = draw_toggle_button(relays_conf.C3)
	
	CImGui.Text("C4")
	CImGui.SameLine()
	relays_conf.C4, pressed = draw_toggle_button(relays_conf.C4)
	
	CImGui.Text("C5")
	CImGui.SameLine()
	relays_conf.C5, pressed = draw_toggle_button(relays_conf.C5)
	
	CImGui.Text("C6")
	CImGui.SameLine()
	relays_conf.C6, pressed = draw_toggle_button(relays_conf.C6)
	
	CImGui.Text("C7")
	CImGui.SameLine()
	relays_conf.C7, pressed = draw_toggle_button(relays_conf.C7)
	
	CImGui.Text("C8")
	CImGui.SameLine()
	relays_conf.C8, pressed = draw_toggle_button(relays_conf.C8)
	
	CImGui.Text("C9")
	CImGui.SameLine()
	relays_conf.C9, pressed = draw_toggle_button(relays_conf.C9)
		
	CImGui.End()
	return relays_conf
end

