function ShowSCOPEWindow(scope, scope_conf, rev_state_dict, refresh_cnt, base)
	CImGui.Begin("TDS2002B Scope")
	# hack for dropdowns until we implementd dicts
	channels = ["CH1" , "CH2"]
	modes = ["NORMAL", "AUTO"]
	Measurement_Type =["FREQuency","MEAN","PERIod","PK2pk","CRMs","MINImum","MAXImum","RISe","FALL","PWIdth","NWIdth"]
	
	# DRAW DISPLAY INFO
	## Row1
	draw_scope_info("CH1 Scale   ", scope_conf.CH1_Volt_div, " ","V/div")
	CImGui.SameLine()
	CImGui.Text("  ")
	CImGui.SameLine()
	draw_scope_info("Triger Channel", scope_conf.Trigger_source )
	
	
    #Row2
	draw_scope_info("CH1 Offset  ", scope_conf.CH1_Offset, " ","div")
	CImGui.SameLine()
	CImGui.Text("  ")
	CImGui.SameLine()
	draw_scope_info("  Triger Level  ", scope_conf.Trigger_level,"","V")
	
	#Row3
	draw_scope_info("CH2 scale   ", scope_conf.CH2_Volt_div, " ","V/div")
	CImGui.SameLine()
	CImGui.Text("  ")
	CImGui.SameLine()
	draw_scope_info("Triger Mode   ",scope_conf.Trigger_mode )	
	
	#Ro4
	draw_scope_info("CH2 Offset  ", scope_conf.CH2_Offset, " ","div")
	CImGui.SameLine()
	CImGui.Text("  ")
	CImGui.SameLine()
	draw_scope_info("  Time Scale    ", scope_conf.Time_div, "","sec/div")
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
			CH1_y_div = parse(Float64,scope_conf.CH1_Volt_div)
			CH2_y_div = parse(Float64,scope_conf.CH2_Volt_div)
			CH1_y_offs = parse(Float64,scope_conf.CH1_Offset)
			CH2_y_offs = parse(Float64,scope_conf.CH2_Offset)			
			#time_div  = parse(Float64,scope_conf.Time_div)

			x = scope_conf.t
			y1 = (scope_conf.y1 .+ CH1_y_offs) ./ CH1_y_div 
			y2 = (scope_conf.y2 .+ CH2_y_offs) ./ CH2_y_div 
			ImPlot.SetNextPlotLimits(0, x[end], -6, 6, ImGuiCond_Always)
			
            # Using '##' in the label name hides the plot label, but lets 
            # us keep the label ID unique for modifying styling etc.
			if ImPlot.BeginPlot("##line", "x1", "Grid Divisions", CImGui.ImVec2(-1,300))
				ImPlot.PlotLine(x, y1 ;label="CH1")
				ImPlot.PlotLine(x, y2 ;label="CH2")
			 	ImPlot.EndPlot()
			end
		end

#	# Draw Acquire button
	scope_conf.Acquire_btn, pressed = draw_toggle_button(scope_conf.Acquire_btn)
	scope_conf.Acquire_btn.state && @async update_scope_conf!(scope_conf, scope, refresh_cnt, base)
#	# Draw Get meas button	
	CImGui.SameLine()
	CImGui.Button("Refresh measurements") && @async begin
		scope_conf.Measurement_Value1 = get_meas_data(scope, "MEAS1")
		scope_conf.Measurement_Value2 = get_meas_data(scope, "MEAS2")
		scope_conf.Measurement_Value3 = get_meas_data(scope, "MEAS3")
		scope_conf.Measurement_Value4 = get_meas_data(scope, "MEAS4")
		scope_conf.Measurement_Value5 = get_meas_data(scope, "MEAS5")		
	end
#	# Draw Refresg settings button	
	CImGui.SameLine()
	CImGui.Button("Refresh settings") && @async begin
	 scope_conf.CH1_Volt_div = get_vertical_scale(scope, "CH1")
     scope_conf.CH2_Volt_div = get_vertical_scale(scope, "CH2")
     scope_conf.CH1_Offset = get_ch_position(scope, "CH1")
     scope_conf.CH2_Offset = get_ch_position(scope, "CH2")
     scope_conf.Time_div = get_horizontal_scale(scope, "Time")
     scope_conf.Trigger_source = get_trig_data(scope, "Source")
     scope_conf.Trigger_level = get_trig_data(scope, "Level")
     scope_conf.Trigger_mode = get_trig_data(scope, "Mode")		
	end	
	
	
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
	@c CImGui.InputDouble("V/div##1", &scope_conf.CH1_Volt_div_new, 0.01, 0.5, "%.4f")

	# ch1 vertical pos 
	CImGui.SameLine()
	CImGui.Button("Set CH1 Offset") && begin
		set_ch_position(scope, "CH1", scope_conf.CH1_Offset_new);
		end
	CImGui.SameLine()
	# Draw INPUT BOX
	CImGui.PushItemWidth(150)
	@c CImGui.InputDouble("div##1", &scope_conf.CH1_Offset_new, 0.01, 10.0, "%.4f")

    # ch2  scale 
	CImGui.Button("Set CH2 Scale       ") && begin
		set_vertical_scale(scope, "CH2", scope_conf.CH2_Volt_div_new);
		end
	CImGui.SameLine()
	# Draw INPUT BOX
	CImGui.PushItemWidth(150)
	@c CImGui.InputDouble("V/div##2", &scope_conf.CH2_Volt_div_new, 0.01, 1.0, "%.4f")

	# ch2 vertical pos 
	CImGui.SameLine()
	CImGui.Button("Set CH2 Offset") && begin
		set_ch_position(scope, "CH2", scope_conf.CH2_Offset_new);
		end
	CImGui.SameLine()
	# Draw INPUT BOX
	CImGui.PushItemWidth(150)
	@c CImGui.InputDouble("div##2", &scope_conf.CH2_Offset_new, 0.01, 10.0, "%.4f")

    # Timer per div 
	CImGui.Button("Set Horizontal Scale") && begin
		set_horizontal_scale(scope,  scope_conf.Time_div_new);
		end
	CImGui.SameLine()
	# Draw INPUT BOX
	CImGui.PushItemWidth(150)
	@c CImGui.InputDouble("sec", &scope_conf.Time_div_new, 0.01, 1.0, "%.6f")

	
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
		@c CImGui.Combo("TMode", &mod_selector, "NORMAL\0AUTO\0\0")
	end
	scope_conf.Trigger_mode_new = modes[mod_selector+1]
	
	# Measurement 1; 
	CImGui.Button("Set Meas 1 ") && begin
	set_meas(scope,  "MEAS1" , scope_conf.Measurement_source1, scope_conf.Measurement_Type1 );
    end
	CImGui.SameLine()
	## Draw INPUT BOX
	CImGui.PushItemWidth(50)
	ch_selector1 = @cstatic ch_selector1=Cint(0) begin
		@c CImGui.Combo("C1", &ch_selector1, "CH1\0CH2\0")
	end
	scope_conf.Measurement_source1 = channels[ch_selector1+1]
	CImGui.SameLine()
	CImGui.PushItemWidth(137)
	Measurement_Type1 = @cstatic Measurement_Type1=Cint(0) begin
		@c CImGui.Combo("T1", &Measurement_Type1, "FREQuency\0MEAN\0PERIod\0PK2pk\0CRMs\0MINImum\0MAXImum\0RISe\0FALL\0PWIdth\0NWIdth\0")
	end
	scope_conf.Measurement_Type1 = Measurement_Type[Measurement_Type1+1]
	CImGui.SameLine()
	draw_scope_info( "  Meas1:",string(scope_conf.Measurement_Value1) )


	# Measurement 2; 
	CImGui.Button("Set Meas 2 ") && begin
	set_meas(scope,  "MEAS2" , scope_conf.Measurement_source2, scope_conf.Measurement_Type2 );
	end
	CImGui.SameLine()
	## Draw INPUT BOX
	CImGui.PushItemWidth(50)
	ch_selector2 = @cstatic ch_selector2=Cint(0) begin
		@c CImGui.Combo("C2", &ch_selector2, "CH1\0CH2\0")
	end
	scope_conf.Measurement_source2 = channels[ch_selector2+1]
	CImGui.SameLine()
	CImGui.PushItemWidth(137)
	Measurement_Type2 = @cstatic Measurement_Type2=Cint(0) begin
		@c CImGui.Combo("T2", &Measurement_Type2, "FREQuency\0MEAN\0PERIod\0PK2pk\0CRMs\0MINImum\0MAXImum\0RISe\0FALL\0PWIdth\0NWIdth\0")
	end
	scope_conf.Measurement_Type2 = Measurement_Type[Measurement_Type2+1]
	CImGui.SameLine()
	draw_scope_info( "  Meas2:",string(scope_conf.Measurement_Value2) )

	# Measurement 3; 
	CImGui.Button("Set Meas 3 ") && begin
	set_meas(scope,  "MEAS3" , scope_conf.Measurement_source3, scope_conf.Measurement_Type3 );
	end
	CImGui.SameLine()
	## Draw INPUT BOX
	CImGui.PushItemWidth(50)
	ch_selector3 = @cstatic ch_selector3=Cint(0) begin
		@c CImGui.Combo("C3", &ch_selector3, "CH1\0CH2\0")
	end
	scope_conf.Measurement_source3 = channels[ch_selector3+1]
	CImGui.SameLine()
	CImGui.PushItemWidth(137)
	Measurement_Type3 = @cstatic Measurement_Type3=Cint(0) begin
		@c CImGui.Combo("T3", &Measurement_Type3, "FREQuency\0MEAN\0PERIod\0PK2pk\0CRMs\0MINImum\0MAXImum\0RISe\0FALL\0PWIdth\0NWIdth\0")
	end
	scope_conf.Measurement_Type3 = Measurement_Type[Measurement_Type3+1]
	CImGui.SameLine()
	draw_scope_info( "  Meas3:",string(scope_conf.Measurement_Value3) )


	# Measurement 4; 
	CImGui.Button("Set Meas 4 ") && begin
	set_meas(scope,  "MEAS4" , scope_conf.Measurement_source4, scope_conf.Measurement_Type4 );
	end
	CImGui.SameLine()
	## Draw INPUT BOX
	CImGui.PushItemWidth(50)
	ch_selector4 = @cstatic ch_selector4=Cint(0) begin
		@c CImGui.Combo("C4", &ch_selector4, "CH1\0CH2\0")
	end
	scope_conf.Measurement_source4 = channels[ch_selector4+1]
	CImGui.SameLine()
	CImGui.PushItemWidth(137)
	Measurement_Type4 = @cstatic Measurement_Type4=Cint(0) begin
		@c CImGui.Combo("T4", &Measurement_Type4, "FREQuency\0MEAN\0PERIod\0PK2pk\0CRMs\0MINImum\0MAXImum\0RISe\0FALL\0PWIdth\0NWIdth\0")
	end
	scope_conf.Measurement_Type4 = Measurement_Type[Measurement_Type4+1]
	CImGui.SameLine()
	draw_scope_info( "  Meas4:",string(scope_conf.Measurement_Value4) )


	# Measurement 5 
	CImGui.Button("Set Meas 5 ") && begin
	set_meas(scope,  "MEAS5" , scope_conf.Measurement_source5, scope_conf.Measurement_Type5 );
	end
	CImGui.SameLine()
	## Draw INPUT BOX
	CImGui.PushItemWidth(50)
	ch_selector5 = @cstatic ch_selector5=Cint(0) begin
		@c CImGui.Combo("C3", &ch_selector5, "CH1\0CH2\0")
	end
	scope_conf.Measurement_source5 = channels[ch_selector5+1]
	CImGui.SameLine()
	CImGui.PushItemWidth(137)
	Measurement_Type5 = @cstatic Measurement_Type5=Cint(0) begin
		@c CImGui.Combo("T5", &Measurement_Type5, "FREQuency\0MEAN\0PERIod\0PK2pk\0CRMs\0MINImum\0MAXImum\0RISe\0FALL\0PWIdth\0NWIdth\0")
	end
	scope_conf.Measurement_Type5 = Measurement_Type[Measurement_Type5+1]
	CImGui.SameLine()
	draw_scope_info( "  Meas5:",string(scope_conf.Measurement_Value5) )



	CImGui.End()
	return scope_conf
end

