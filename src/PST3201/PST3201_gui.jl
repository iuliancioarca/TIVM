
function main_pst3201_gui()
    if !@isdefined psu
        @error "Obj not found or has wrong name! Please rename obj to: psu , and ensure communication is opened!"
        return nothing
    else
        # this crashes for the moment
        # try# check connection       
        # get_idn(psu)
        # catch
        # @error "psu object found but communication failed; open communication and try again"
        # return nothing
        # end
    end
    window, ctx = init_gui()
    # Main while loop
    try
        # DEFINE YOUR WIDGETS
        len = 260 # the max path length depends on max system
        clear_color = Cfloat[0.45, 0.55, 0.60, 1.00]
        crt_address = "Main proc inst handle"
        crt_outp_state = "off"
        aux_set = ["0"]
		refresh_cnt = 0
        shift_push_button = CImGuiToggleButton(" SHIFT ")
        output_push_button = CImGuiToggleButton("   OUTPUT   ")
        refresh_cont_push_button = CImGuiToggleButton("REFRESH CONTINUOUSLY")
        connect_push_button = CImGuiToggleButton("CONNECT")
        rev_state_dict = Dict("on"=>"off", "off"=>"on")
        while !GLFW.WindowShouldClose(window)
		# update refresh counter
			refresh_cnt == 110 && (refresh_cnt=0)
			refresh_cnt = refresh_cnt + 1
            GLFW.PollEvents()
            # start the Dear ImGui frame
            ImGui_ImplOpenGL3_NewFrame()
            ImGui_ImplGlfw_NewFrame()
            CImGui.NewFrame()
            # we use a Begin/End pair to created a named window.
            CImGui.Begin("Display")
            # color buttons, demonstrate using PushID() to add unique identifier in the ID stack, and changing style.
            # CImGui.SameLine()
            CImGui.Text("CH1")
            CImGui.SameLine(), CImGui.Text(" ")
            CImGui.SameLine(), CImGui.Text(pst3201_meas.ch1_volt)
            CImGui.SameLine(), CImGui.Text("V")
            CImGui.SameLine(), CImGui.Text(pst3201_meas.ch1_curr)
            CImGui.SameLine(), CImGui.Text("A")

            CImGui.Text("CH2")
            CImGui.SameLine(), CImGui.Text(" ")
            CImGui.SameLine(), CImGui.Text(pst3201_meas.ch2_volt)
            CImGui.SameLine(), CImGui.Text("V")
            CImGui.SameLine(), CImGui.Text(pst3201_meas.ch2_curr)
            CImGui.SameLine(), CImGui.Text("A")

            CImGui.Text("CH3")
            CImGui.SameLine(), CImGui.Text(" ")
            CImGui.SameLine(), CImGui.Text(pst3201_meas.ch3_volt)
            CImGui.SameLine(), CImGui.Text("V")
            CImGui.SameLine(), CImGui.Text(pst3201_meas.ch3_curr)
            CImGui.SameLine(), CImGui.Text("A")

            CImGui.Text("")

            CImGui.Text("SET")
            CImGui.SameLine(), CImGui.Text("   ")
            CImGui.SameLine(), CImGui.Text("CH1")
            CImGui.SameLine(), CImGui.Text("    ")
            CImGui.SameLine(), CImGui.Text("CH2")
            CImGui.SameLine(), CImGui.Text("    ")
            CImGui.SameLine(), CImGui.Text("CH3")

            CImGui.Text("Volt.")
            CImGui.SameLine(), CImGui.Text(pst3201_sett.ch1_volt)
            CImGui.SameLine(), CImGui.Text("V")
            CImGui.SameLine(), CImGui.Text(pst3201_sett.ch2_volt)
            CImGui.SameLine(), CImGui.Text("V")
            CImGui.SameLine(), CImGui.Text(pst3201_sett.ch3_volt)
            CImGui.SameLine(), CImGui.Text("V")

            CImGui.Text("Curr.")
            CImGui.SameLine(), CImGui.Text(pst3201_sett.ch1_curr)
            CImGui.SameLine(), CImGui.Text("A")
            CImGui.SameLine(), CImGui.Text(pst3201_sett.ch2_curr)
            CImGui.SameLine(), CImGui.Text("A")
            CImGui.SameLine(), CImGui.Text(pst3201_sett.ch3_curr)
            CImGui.SameLine(), CImGui.Text("A")

            CImGui.Text("O.V.P")
            CImGui.SameLine(), CImGui.Text(pst3201_sett.ch1_ovp)
            CImGui.SameLine(), CImGui.Text("V")
            CImGui.SameLine(), CImGui.Text(pst3201_sett.ch2_ovp)
            CImGui.SameLine(), CImGui.Text("V")
            CImGui.SameLine(), CImGui.Text(pst3201_sett.ch3_ovp)
            CImGui.SameLine(), CImGui.Text("V")

            CImGui.Text("O.C.P")
            CImGui.SameLine(), CImGui.Text(" ")
            CImGui.SameLine(), CImGui.Text(pst3201_sett.ch1_ocp)
            CImGui.SameLine(), CImGui.Text("    ")
            CImGui.SameLine(), CImGui.Text(pst3201_sett.ch2_ocp)
            CImGui.SameLine(), CImGui.Text("    ")
            CImGui.SameLine(), CImGui.Text(pst3201_sett.ch3_ocp)

            CImGui.End()

            CImGui.Begin("Control")
            # color buttons, demonstrate using PushID() to add unique identifier in the ID stack, and changing style.
            CImGui.Text(" STORE    ")
            CImGui.SameLine(), CImGui.Text("PARA/INDEP   ")
            CImGui.SameLine(), CImGui.Text("OVP RESET   ")
            CImGui.SameLine(), CImGui.Text("GPIB RS232")

            CImGui.Button("RECALL")
            CImGui.SameLine(), CImGui.Text("   ")
            CImGui.SameLine(), CImGui.Button(" AUTO  ")
            CImGui.SameLine(), CImGui.Text("   ")
            CImGui.SameLine(), CImGui.Button("  OCP  ") && begin
            if shift_push_button.state == true
                reset_protections(psu);
            else # toggle OCP
                pst3201_conf.ocp_on = get_curr_protection(psu, pst3201_conf.selected_channel);
                crt_state = rev_state_dict[pst3201_conf.ocp_on];
                set_curr_protection(psu, pst3201_conf.selected_channel,crt_state);
            end
            end
            CImGui.SameLine(), CImGui.Text("   ")
            CImGui.SameLine(), CImGui.Button(" LOCAL ")

            CImGui.Text(" RECALL   ")
            CImGui.SameLine(), CImGui.Text("TRACK/INDEP   ")

            CImGui.Button("RECALL")
            CImGui.SameLine(), CImGui.Text("   ")
            CImGui.SameLine(), CImGui.Button(" DELAY ")
            CImGui.SameLine(), CImGui.Text("   ")
            CImGui.SameLine()
            # hack for shift_push_button toggle button
            if shift_push_button.state == false
                CImGui.PushID(1)
                CImGui.PushStyleColor(CImGui.ImGuiCol_Button, CImGui.HSV(shift_push_button.off_color...))
                CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonHovered, CImGui.HSV(shift_push_button.hover_color...))
                CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonActive, CImGui.HSV(shift_push_button.off_color...))
            else
                CImGui.PushID(1)
                CImGui.PushStyleColor(CImGui.ImGuiCol_Button, CImGui.HSV(shift_push_button.on_color...))
                CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonHovered, CImGui.HSV(shift_push_button.hover_color...))
                CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonActive, CImGui.HSV(shift_push_button.on_color...))
            end
            CImGui.Button(shift_push_button.name) && (shift_push_button.state = !shift_push_button.state)
            CImGui.PopStyleColor(3)
            CImGui.PopID()

            CImGui.Text("  CH1  ")
            CImGui.SameLine(), CImGui.Text("    CONTRAST   ")
            CImGui.SameLine(), CImGui.Text("   I up   ")
            CImGui.SameLine(), CImGui.Text("     V up   ")

            CImGui.Button(" VSET ") && begin
            if shift_push_button.state
                pst3201_conf.selected_channel = "C1";
            else
                pst3201_conf.selected_func = "voltage";
            end
            end

            CImGui.SameLine(), CImGui.Text("   ")
            CImGui.SameLine(), CImGui.Button("   7   ") && push!(aux_set, "7")
            CImGui.SameLine(), CImGui.Text("   ")
            CImGui.SameLine(), CImGui.Button("   8   ") && push!(aux_set, "8")
            CImGui.SameLine(), CImGui.Text("   ")
            CImGui.SameLine(), CImGui.Button("   9   ") && push!(aux_set, "9")

            CImGui.Text("  CH2  ")
            CImGui.SameLine(), CImGui.Text("       VOL    ")
            CImGui.SameLine(), CImGui.Text("    I down   ")
            CImGui.SameLine(), CImGui.Text("   V down   ")

            CImGui.Button(" ISET ") && begin
            if shift_push_button.state
                pst3201_conf.selected_channel = "C2";
            else
                pst3201_conf.selected_func = "current";
            end
            end
            CImGui.SameLine(), CImGui.Text("   ")
            CImGui.SameLine(), CImGui.Button("   4   ") && push!(aux_set, "4")
            CImGui.SameLine(), CImGui.Text("   ")
            CImGui.SameLine(), CImGui.Button("   5   ") && push!(aux_set, "5")
            CImGui.SameLine(), CImGui.Text("   ")
            CImGui.SameLine(), CImGui.Button("   6   ") && push!(aux_set, "6")

            CImGui.Text("  CH3  ")
            CImGui.SameLine(), CImGui.Text("  ")
            CImGui.SameLine(), CImGui.Text("                       ")
            CImGui.SameLine(), CImGui.Text("                 EDIT ")

            CImGui.Button("OVPSET") && begin
            if shift_push_button.state
                pst3201_conf.selected_channel = "C3";
            else
                pst3201_conf.selected_func = "OVP";
            end
            end
            CImGui.SameLine(), CImGui.Text("   ")
            CImGui.SameLine(), CImGui.Button("   1   ") && push!(aux_set, "1")
            CImGui.SameLine(), CImGui.Text("   ")
            CImGui.SameLine(), CImGui.Button("   2   ") && push!(aux_set, "2")
            CImGui.SameLine(), CImGui.Text("   ")
            CImGui.SameLine(), CImGui.Button("   3   ") && push!(aux_set, "3")
            CImGui.SameLine()
            #aux = parse(Float64,(string(aux_set...)))
            @c CImGui.InputDouble("", &pst3201_conf.crt_value, 0.01, 1.0, "%.4f")
            CImGui.Text("  STEP")
            CImGui.SameLine(), CImGui.Text("         W")
            CImGui.SameLine(), CImGui.Text("  ")
            CImGui.SameLine(), CImGui.Text("  ")

            CImGui.Button(" F/C  ")
            CImGui.SameLine(), CImGui.Text("   ")
            CImGui.SameLine(), CImGui.Button("   0   ") && push!(aux_set, "0")
            CImGui.SameLine(), CImGui.Text("   ")
            CImGui.SameLine(), CImGui.Button("   .   ") && push!(aux_set, ".")
            CImGui.SameLine(), CImGui.Text("   ")
            CImGui.SameLine(), CImGui.Button(" ENTER ") && begin
            #pst3201_conf.crt_value = parse(Float64,(string(aux_set...)))
            if pst3201_conf.selected_func == "voltage"
                set_source_lev(psu, pst3201_conf.selected_channel, pst3201_conf.crt_value);
            elseif pst3201_conf.selected_func == "current"
                set_max_curr(psu, pst3201_conf.selected_channel, pst3201_conf.crt_value);
            elseif pst3201_conf.selected_func == "OVP"
                set_volt_protection(psu, pst3201_conf.selected_channel, pst3201_conf.crt_value);
            else
                @error "Brace yourself!"
            end
            end
            CImGui.SameLine(), CImGui.Text("  ")
            CImGui.SameLine()
            # # hack for output toggle button
            if refresh_cnt == 100
                crt_outp_state = get_outp(psu, pst3201_conf.selected_channel)
            end
            if crt_outp_state == "off"
                CImGui.PushID(1)
                CImGui.PushStyleColor(CImGui.ImGuiCol_Button, CImGui.HSV(output_push_button.off_color...))
                CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonHovered, CImGui.HSV(output_push_button.hover_color...))
                CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonActive, CImGui.HSV(output_push_button.off_color...))
            else
                CImGui.PushID(1)
                CImGui.PushStyleColor(CImGui.ImGuiCol_Button, CImGui.HSV(output_push_button.on_color...))
                CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonHovered, CImGui.HSV(output_push_button.hover_color...))
                CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonActive, CImGui.HSV(output_push_button.on_color...))

            end
            CImGui.Button(output_push_button.name) && begin 
                set_outp(psu, pst3201_conf.selected_channel, rev_state_dict[crt_outp_state])
                #output_push_button.state = !output_push_button.state
            end
            CImGui.PopStyleColor(3)
            CImGui.PopID()

            CImGui.End()

            CImGui.Begin("REMOTE")
            CImGui.SameLine(), CImGui.Button("REFRESH") && begin
            # update PST3201_Meas and PST3201_Sett
            update_pst3201_state!(pst3201_meas, pst3201_sett, psu, refresh_cnt)
            end
            CImGui.SameLine()
            # hack for refresh_cont_push_button
            if refresh_cont_push_button.state == false
                CImGui.PushID(1)
                CImGui.PushStyleColor(CImGui.ImGuiCol_Button, CImGui.HSV(refresh_cont_push_button.off_color...))
                CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonHovered, CImGui.HSV(refresh_cont_push_button.hover_color...))
                CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonActive, CImGui.HSV(refresh_cont_push_button.off_color...))
            else
                CImGui.PushID(1)
                CImGui.PushStyleColor(CImGui.ImGuiCol_Button, CImGui.HSV(refresh_cont_push_button.on_color...))
                CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonHovered, CImGui.HSV(refresh_cont_push_button.hover_color...))
                CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonActive, CImGui.HSV(refresh_cont_push_button.on_color...))
            end
            CImGui.Button(refresh_cont_push_button.name) && (refresh_cont_push_button.state = !refresh_cont_push_button.state)
            CImGui.PopStyleColor(3)
            CImGui.PopID()
            if(refresh_cont_push_button.state)
                update_pst3201_state!(pst3201_meas, pst3201_sett, psu, refresh_cnt)
				#@info "WIP, not workig yet"
            end

            CImGui.SameLine()
            if connect_push_button.state == false
                CImGui.PushID(1)
                CImGui.PushStyleColor(CImGui.ImGuiCol_Button, CImGui.HSV(connect_push_button.off_color...))
                CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonHovered, CImGui.HSV(connect_push_button.hover_color...))
                CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonActive, CImGui.HSV(connect_push_button.off_color...))
                # disconnect instrument
            else
                CImGui.PushID(1)
                CImGui.PushStyleColor(CImGui.ImGuiCol_Button, CImGui.HSV(connect_push_button.on_color...))
                CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonHovered, CImGui.HSV(connect_push_button.hover_color...))
                CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonActive, CImGui.HSV(connect_push_button.on_color...))
                # connect instrument
                #instrument = instrhandle
            end
            CImGui.Button(connect_push_button.name) && (connect_push_button.state = !connect_push_button.state)
            CImGui.PopStyleColor(3)
            CImGui.PopID()
            
            CImGui.SameLine(), CImGui.Button("RESET") && reset_instr(psu)
            CImGui.SameLine(), CImGui.InputText("", crt_address, length(crt_address))

            CImGui.End()
            # END WIDGETS
            render_gui(window, clear_color; fps=200)
        end

    catch e
        @error "Error in renderloop!" exception=e
        Base.show_backtrace(stderr, catch_backtrace())
    finally
        destroy_gui(ctx,window)
        # rmprocs(2:100)
    end
end
