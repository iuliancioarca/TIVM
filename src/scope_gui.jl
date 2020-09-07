function ShowSCOPEWindow(scope, scope_conf, rev_state_dict, refresh_cnt)
	CImGui.Begin("TDS2002B Scope")
	# hack for dropdowns until we implementd dicts
	channels = ["CH1" , "CH2"]
	modes = ["NORMal", "AUTO"]
	
	# DRAW DISPLAY INFO
	## CH1
	draw_scope_info("CH1 Scale  ", scope_conf.CH1_Volt_div, " ","V")
	CImGui.SameLine()
	CImGui.Text("  ")
	CImGui.SameLine()
	draw_scope_info("Triger Channel", scope_conf.Trigger_source )
    #CH2
	draw_scope_info("CH2 scale  ", scope_conf.CH2_Volt_div, " ","V")
	CImGui.SameLine()
	CImGui.Text("  ")
	CImGui.SameLine()
	draw_scope_info("Triger Level  ", scope_conf.Trigger_level,"V")
     ## Time Scale
	draw_scope_info("Time Scale ", scope_conf.Time_div, "","s")
	CImGui.SameLine()
	CImGui.Text("  ")
	CImGui.SameLine()
	draw_scope_info("Triger Mode   ",scope_conf.Trigger_mode )	
	CImGui.Text("")
	CImGui.Separator()

# graphs using gimgui
#////////////////////////////////////////////////////////////////////////////////////
      
	#animate, _ = @cstatic animate=true arr=Cfloat[0.6, 0.1, 1.0, 0.5, 0.92, 0.1, 0.2] begin
	#	@c CImGui.Checkbox("Acquire", &animate)
	#	# create a dummy array of contiguous float values to plot
	#	# Tip: If your float aren't contiguous but part of a structure, you can pass a pointer to your first float and the sizeof() of your structure in the Stride parameter.
	#	@cstatic values=fill(Cfloat(0),90) values_offset=Cint(0) values_offset2=Cint(0) refresh_time=Cdouble(0) begin
    #		(!animate || refresh_time == 0.0) && (refresh_time = CImGui.GetTime();)
    #
    #		while refresh_time < CImGui.GetTime() # create dummy data at fixed 60 hz rate for the demo
    #  			@cstatic phase=Cfloat(0) begin
    #       		values[values_offset+1] = cos(phase)
	#				values_offset = (values_offset+1) % length(values)
	#				values_offset2 = (values_offset+2) % length(values)
    #        		phase += 0.10*values_offset
    #        		refresh_time += 1.0/60.0
    #    		end
    #		end
	#	CImGui.PlotLines("CH1", values, length(values), values_offset, "CH1", -5.0, 5.0, (200,200))
	#	CImGui.SameLine()
	#	CImGui.PlotLines("CH2", values, length(values), values_offset2, "CH2", -5.0, 5.0, (200,200))
	#	#PlotLines(label, values, values_count, values_offset=0, overlay_text=C_NULL, scale_min=FLT_MAX, scale_max=FLT_MAX, graph_size=ImVec2(0,0), stride=sizeof(Cfloat)) = igPlotLinesFloatPtr(label, values, values_count, values_offset, overlay_text, scale_min, scale_max, graph_size, stride)
    #	#PlotLines(label, values_getter, data::Ptr, values_count, values_offset=0, overlay_text=C_NULL, scale_min=FLT_MAX, scale_max=FLT_MAX, graph_size=ImVec2(0,0)) = igPlotLinesFnFloatPtr(label, values_getter, data, values_count, values_offset, overlay_text, scale_min, scale_max, graph_size)
    #
	#	end
	#end # @cstatic
 #///////////////////////////////////////////////////////////////////////////////////////////
 #graphs using plots nad displainy an image 
 show_window = true
		if show_window
			#CH1_y_div = parse(Float64,scope_conf.CH1_Volt_div)
			#CH2_y_div = parse(Float64,scope_conf.CH2_Volt_div)
			#time_div  = parse(Float64,scope_conf.Time_div)
			#y = AbstractArray{Float64,300}
			#x = range(0.0, step=1, length=300) |> collect   # need to change step to waveform time , lenght to waveform lenght               	
			#y1 = rand(300) 
			#y2 = rand(300) 
			
			x = scope_conf.t
			y1 = scope_conf.y1
			y2 = scope_conf.y2
			ImPlot.SetNextPlotLimits(0, x[end], -10, 10, ImGuiCond_Always)
			
            # Using '##' in the label name hides the plot label, but lets 
            # us keep the label ID unique for modifying styling etc.
			if ImPlot.BeginPlot("##line", "x1", "y1", CImGui.ImVec2(-1,300))
				ImPlot.PlotLine(x, y1 ;label="CH1")
				ImPlot.PlotLine(x, y2 ;label="CH2")
			 	ImPlot.EndPlot()
			end
		end

#	# Draw Acquire button
	scope_conf.Acquire_btn, pressed = draw_toggle_button(scope_conf.Acquire_btn)
	scope_conf.Acquire_btn.state && @async update_scope_conf!(scope_conf, scope, refresh_cnt)

 #///////////////////////////////////////////////////////////////////////////////////////////////////////

	CImGui.Text("")
	CImGui.Separator()
	# DRAW BUTTONS
	# ch1 scale 
	CImGui.Button("Set CH1 Scale       ") && begin
		set_vertical_scale(scope, "CH1", scope_conf.CH1_Volt_div_new);
		end
	CImGui.SameLine()
	# Draw INPUT BOX
	CImGui.PushItemWidth(150)
	@c CImGui.InputDouble("S1", &scope_conf.CH1_Volt_div_new, 0.01, 0.5, "%.4f")

    # ch2  scale 
	CImGui.Button("Set CH2 Scale       ") && begin
		set_vertical_scale(scope, "CH2", scope_conf.CH2_Volt_div_new);
		end
	CImGui.SameLine()
	# Draw INPUT BOX
	CImGui.PushItemWidth(150)
	@c CImGui.InputDouble("S2", &scope_conf.CH2_Volt_div_new, 0.01, 1.0, "%.4f")

    # Timer per div 
	CImGui.Button("Set Horizontal Scale") && begin
		set_horizontal_scale(scope,  scope_conf.Time_div_new);
		end
	CImGui.SameLine()
	# Draw INPUT BOX
	CImGui.PushItemWidth(150)
	@c CImGui.InputDouble("T", &scope_conf.Time_div_new, 0.01, 1.0, "%.6f")

	
	# Trigger channel; 
	CImGui.Button("Set Trigger Channel ") && begin
		set_trig_ch(scope,  scope_conf.Trigger_source_new);
	end
	CImGui.SameLine()
	# Draw INPUT BOX
	CImGui.PushItemWidth(150)
	ch_selector = @cstatic ch_selector=Cint(0) begin
		@c CImGui.Combo("TCh", &ch_selector, "CH1\0CH2\0\0")
	end
	scope_conf.Trigger_source_new = channels[ch_selector+1]
		
    # Trigger level; 
	CImGui.Button("Set Trigger Level   ") && begin
	set_trig_level(scope,  scope_conf.Trigger_level_new);
	end
	CImGui.SameLine()
	# Draw INPUT BOX
	CImGui.PushItemWidth(150)
	@c CImGui.InputDouble("Tl", &scope_conf.Trigger_level_new, 0.01, 1.0, "%.4f")

  # Trigger Mode; 
	CImGui.Button("Set Trigger Mode    ") && begin
		set_trig_mode(scope,  scope_conf.Trigger_mode_new);
	end
	CImGui.SameLine()
	## Draw INPUT BOX
	CImGui.PushItemWidth(150)
	mod_selector = @cstatic mod_selector=Cint(0) begin
		@c CImGui.Combo("TMode", &mod_selector, "NORMal\0AUTO\0\0")
	end
	scope_conf.Trigger_mode_new = modes[mod_selector+1]
	
	CImGui.End()
	return scope_conf
end

