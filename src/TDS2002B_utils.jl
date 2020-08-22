
function update_scope_conf!(scope_conf, scope, refresh_cnt)
	 base = 4
     # Get Channel Volt per Div 
     #refresh_cnt==base*1  && (scope_conf.CH1_Volt_div = get_vertical_scale(scope, "CH1"))
     #refresh_cnt==base*2 && (scope_conf.CH2_Volt_div = get_vertical_scale(scope, "CH2"))
     #Get Time per Div
     #refresh_cnt==base*3 && (scope_conf.Time_div = get_horizontal_scale(scope, "Time"))
     #Get Triger Seting
     #refresh_cnt==base*4 && (scope_conf.Trigger_source = get_trig_data(scope, "Source"))
     #refresh_cnt==base*5 && (scope_conf.Trigger_level = get_trig_data(scope, "Level"))
     #refresh_cnt==base*6 && (scope_conf.Trigger_mode = get_trig_data(scope, "Mode"))
     #Get Meas - not working yet
     #(refresh_cnt==base*7 || refresh_cnt==base*17) && (scope_conf.Measurement_source = get_meas_data(scope, "Meas_Nr1","Channel"))
     #(refresh_cnt==base*8 || refresh_cnt==base*18) && (scope_conf.Measurement_Type = get_meas_data(scope, "Meas_Nr1","Measurement"))
     #(refresh_cnt==base*9 || refresh_cnt==base*19) && (scope_conf.Measurement_Value = get_meas_data(scope, "Meas_Nr1","Value"))
	
	# get waveforms
	(refresh_cnt==base*1 || refresh_cnt==base*10 || refresh_cnt==base*20) && ((scope_conf.t, scope_conf.y1) = Trigger_Aquistion(scope, "CH1"))
	(refresh_cnt==base*5 || refresh_cnt==base*15 || refresh_cnt==base*25) && ((scope_conf.t, scope_conf.y2) = Trigger_Aquistion(scope, "CH2"))

end
