
function main_gui()
    if !@isdefined dmm
        @error "Obj not found or has wrong name! Please rename obj to: dmm , and ensure communication is opened!"
        return nothing
    else
        # this crashes
        # try# check connection       
        # get_idn(dmm)
        # catch
        # @error "dmm object found but communication failed; open communication and try again"
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
        aux_set = ["0"]
        refresh_cnt = 0
        shift_push_button = CImGuiToggleButton(" SHIFT ")
        auto_push_button = CImGuiToggleButton("  AUTO  ")
        refresh_cont_push_button = CImGuiToggleButton("REFRESH CONTINUOUSLY")
        connect_push_button = CImGuiToggleButton("CONNECT")
        rev_state_dict = Dict("on"=>"off", "off"=>"on")
        while !GLFW.WindowShouldClose(window)
            refresh_cnt == 60 && (refresh_cnt=0)
			refresh_cnt = refresh_cnt + 1
            GLFW.PollEvents()
            # start the Dear ImGui frame
            ImGui_ImplOpenGL3_NewFrame()
            ImGui_ImplGlfw_NewFrame()
            CImGui.NewFrame()
            # we use a Begin/End pair to created a named window.
            CImGui.Begin("Display")

            CImGui.Text("Secondary"), CImGui.SameLine(), CImGui.Text("   Primary")
            CImGui.Text(gdm8246_meas.secondary)
            CImGui.SameLine(), CImGui.Text("mV  ")
            CImGui.SameLine(), CImGui.Text(gdm8246_meas.primary)
            CImGui.SameLine(), CImGui.Text("V")
            CImGui.Text("            ")
            CImGui.SameLine(), CImGui.Text("RANG:")
            CImGui.SameLine(), CImGui.Text(gdm8246_sett.range)
            CImGui.SameLine(), CImGui.Text("FCT:")
            CImGui.SameLine(), CImGui.Text(gdm8246_conf.selected_func)
            CImGui.End()


            CImGui.Begin("Control")

            CImGui.Text("  DC mV  ")
            CImGui.SameLine(), CImGui.Text("  AC mV  ")
            CImGui.SameLine(), CImGui.Text("  DIODE  ")
            CImGui.SameLine(), CImGui.Text("   REL   ")           
            CImGui.SameLine(), CImGui.Text("   COMP  ")    
            CImGui.SameLine(), CImGui.Text("         ")    
            CImGui.SameLine(), CImGui.Text("   SET   ") 
            
            CImGui.Button("  DCV   ") && begin
            if shift_push_button.state == false
                set_sense_func(dmm, gdm8246_conf.selected_channel, "DCV")
            else
                # set the range to mV??????
                #set_sense_func(dmm, gdm8246_conf.selected_channel, "DCV")
            end
            end
            CImGui.SameLine(),CImGui.Button("  ACV   ")&& begin
            if shift_push_button.state == false
                set_sense_func(dmm, gdm8246_conf.selected_channel, "ACV")
            else
                # set the range to mV??????
                #set_sense_func(dmm, gdm8246_conf.selected_channel, "DCV")
            end
            end
            CImGui.SameLine(),CImGui.Button("  OHM   ") && begin
            if shift_push_button.state == false
                set_sense_func(dmm, gdm8246_conf.selected_channel, "OHM")
            else
                set_sense_func(dmm, gdm8246_conf.selected_channel, "DIODE")
            end
            end
            CImGui.SameLine(),CImGui.Button("  CONT  ")
            CImGui.SameLine(),CImGui.Button(" MAX/MIN")
            CImGui.SameLine(),CImGui.Button("   UP   ") && begin
                #this should increase reange on current function
            end
            CImGui.SameLine()
            # # hack for AUTO/MAN toggle button
            if auto_push_button.state == false
                CImGui.PushID(1)
                CImGui.PushStyleColor(CImGui.ImGuiCol_Button, CImGui.HSV(auto_push_button.off_color...))
                CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonHovered, CImGui.HSV(auto_push_button.hover_color...))
                CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonActive, CImGui.HSV(auto_push_button.off_color...))
                CImGui.Button("  MAN  ") && begin
                    auto_push_button.state = !auto_push_button.state
                    # toggle autorange on
                end
            else
                CImGui.PushID(1)
                CImGui.PushStyleColor(CImGui.ImGuiCol_Button, CImGui.HSV(auto_push_button.on_color...))
                CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonHovered, CImGui.HSV(auto_push_button.hover_color...))
                CImGui.PushStyleColor(CImGui.ImGuiCol_ButtonActive, CImGui.HSV(auto_push_button.on_color...))
                CImGui.Button(" AUTO  ") && begin
                    auto_push_button.state = !auto_push_button.state
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
            if shift_push_button.state == false
                set_sense_func(dmm, gdm8246_conf.selected_channel, "DCA")
            else
                set_sense_func(dmm, gdm8246_conf.selected_channel, "DCA20")
            end
            end
            CImGui.SameLine(),CImGui.Button("  ACA   ") && begin
            if shift_push_button.state == false
                set_sense_func(dmm, gdm8246_conf.selected_channel, "ACA")
            else
                set_sense_func(dmm, gdm8246_conf.selected_channel, "ACA20")
            end
            end
            CImGui.SameLine(),CImGui.Button(" AC+DC  ") && begin 
            if shift_push_button.state == false
                set_sense_func(dmm, gdm8246_conf.selected_channel, "RIPPLE")
            else
                @warn "not implemented yet"
                #set_sense_func(dmm, gdm8246_conf.selected_channel, "ACA20")
            end
            end
            CImGui.SameLine(),CImGui.Button("  CAP   ")
            CImGui.SameLine(),CImGui.Button("  HOLD  ")
            CImGui.SameLine(),CImGui.Button("  DOWN  ") && begin
            #this should decrease range on current function
            end
            CImGui.SameLine()
            # # hack for shift_push_button toggle button
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

            CImGui.End()

            CImGui.Begin("REMOTE")
            CImGui.SameLine(), CImGui.Button("REFRESH") && begin
            # update gdm8246_meas and PST3201_Sett
                update_gdm8246_state!(gdm8246_meas, gdm8246_sett, dmm, refresh_cnt)
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
                update_gdm8246_state!(gdm8246_meas, gdm8246_sett, dmm, refresh_cnt)
            end

            # hack for connect button            
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
            
            CImGui.SameLine(), CImGui.Button("RESET")
            CImGui.SameLine(), CImGui.InputText("", crt_address, length(crt_address))

            CImGui.End()

            # END WIDGETS
            render_gui(window, clear_color; fps=360)
    end

    catch e
        @error "Error in renderloop!" exception=e
        Base.show_backtrace(stderr, catch_backtrace())
    finally
        destroy_gui(ctx,window)
        # rmprocs(2:100)
    end
end
