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

	CImGui.Text("  C10  ")
	CImGui.SameLine()
	relays_conf.C10, pressed = draw_toggle_button(relays_conf.C10)
	pressed && @async set_state(relays, "C10", rev_state_dict[relays_conf.C10.state])

	CImGui.Text("  C11  ")
	CImGui.SameLine()
	relays_conf.C11, pressed = draw_toggle_button(relays_conf.C11)
	pressed && @async set_state(relays, "C11", rev_state_dict[relays_conf.C11.state])

	CImGui.Text("  C12  ")
	CImGui.SameLine()
	relays_conf.C12, pressed = draw_toggle_button(relays_conf.C12)
	pressed && @async set_state(relays, "C12", rev_state_dict[relays_conf.C12.state])

	CImGui.Text("  C13  ")
	CImGui.SameLine()
	relays_conf.C13, pressed = draw_toggle_button(relays_conf.C13)
	pressed && @async set_state(relays, "C13", rev_state_dict[relays_conf.C13.state])

	CImGui.Text("  C14  ")
	CImGui.SameLine()
	relays_conf.C14, pressed = draw_toggle_button(relays_conf.C14)
	pressed && @async set_state(relays, "C14", rev_state_dict[relays_conf.C14.state])

	CImGui.Text("  C15  ")
	CImGui.SameLine()
	relays_conf.C15, pressed = draw_toggle_button(relays_conf.C15)
	pressed && @async set_state(relays, "C15", rev_state_dict[relays_conf.C15.state])

	CImGui.Text("  C16  ")
	CImGui.SameLine()
	relays_conf.C16, pressed = draw_toggle_button(relays_conf.C16)
	pressed && @async set_state(relays, "C16", rev_state_dict[relays_conf.C16.state])

	CImGui.Text("Refresh")
	CImGui.SameLine()
	#relays_conf.Refresh, pressed = draw_toggle_button(relays_conf.Refresh)
	CImGui.Button("Refresh") && @async begin
	#relays_conf.Refresh.state  && @async begin
			sleep(0.25)
			relays_conf.C1.state = rev_state_dict[get_state(relays, "C1")]
			sleep(0.25)
			relays_conf.C2.state = rev_state_dict[get_state(relays, "C2")]
			sleep(0.25)
			relays_conf.C3.state = rev_state_dict[get_state(relays, "C3")]
			sleep(0.25)
			relays_conf.C4.state = rev_state_dict[get_state(relays, "C4")]
			sleep(0.25)
			relays_conf.C5.state = rev_state_dict[get_state(relays, "C5")]
			sleep(0.25)
			relays_conf.C6.state = rev_state_dict[get_state(relays, "C6")]
			sleep(0.25)
			relays_conf.C7.state = rev_state_dict[get_state(relays, "C7")]
			sleep(0.25)
			relays_conf.C8.state = rev_state_dict[get_state(relays, "C8")]
			sleep(0.25)
			relays_conf.C9.state = rev_state_dict[get_state(relays, "C9")]
			sleep(0.25)
			relays_conf.C10.state = rev_state_dict[get_state(relays, "C10")]
			sleep(0.25)
			relays_conf.C11.state = rev_state_dict[get_state(relays, "C11")]
			sleep(0.25)
			relays_conf.C12.state = rev_state_dict[get_state(relays, "C12")]
			sleep(0.25)
			relays_conf.C13.state = rev_state_dict[get_state(relays, "C13")]
			sleep(0.25)
			relays_conf.C14.state = rev_state_dict[get_state(relays, "C14")]
			sleep(0.25)
			relays_conf.C15.state = rev_state_dict[get_state(relays, "C15")]
			sleep(0.25)
			relays_conf.C16.state = rev_state_dict[get_state(relays, "C16")]
			sleep(0.25)
		end
	CImGui.Text("All OFF")
	CImGui.SameLine()
	CImGui.Button("All OFF") && @async begin
		all_off(relays)
	end
	CImGui.End()
	return relays_conf
end
