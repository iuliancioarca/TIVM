
function update_scope_conf!(scope_conf, scope, refresh_cnt, base)	 
     # Get Channel Volt per Div 
     #refresh_cnt==base*1  && (scope_conf.CH1_Volt_div = string(get_vertical_scale(scope, "CH1")))
     #refresh_cnt==base*2 && (scope_conf.CH2_Volt_div = string(get_vertical_scale(scope, "CH2")))
     ##refresh_cnt==base*3 && (scope_conf.CH1_Offset = string(get_ch_position(scope, "CH1")))
     ##refresh_cnt==base*4 && (scope_conf.CH2_Offset = string(get_ch_position(scope, "CH2")))
     #Get Time per Div
     #refresh_cnt==base*3 && (scope_conf.Time_div = string(get_horizontal_scale(scope, "Time")))
     #Get Triger Seting
     #refresh_cnt==base*4 && (scope_conf.Trigger_source = get_trig_data(scope, "Source"))
     #refresh_cnt==base*5 && (scope_conf.Trigger_level = get_trig_data(scope, "Level"))
     #refresh_cnt==base*6 && (scope_conf.Trigger_mode = get_trig_data(scope, "Mode"))
     #Get Meas - not working yet
     #(refresh_cnt==base*3) && (scope_conf.Measurement_Value1 = string(get_meas_data(scope, "Meas_Nr1")))
     #(refresh_cnt==base*4) && (scope_conf.Measurement_Value2 = string(get_meas_data(scope, "Meas_Nr2")))
     #(refresh_cnt==base*5) && (scope_conf.Measurement_Value3 = string(get_meas_data(scope, "Meas_Nr3")))
	 #(refresh_cnt==base*6) && (scope_conf.Measurement_Value4 = string(get_meas_data(scope, "Meas_Nr4")))
     #(refresh_cnt==base*7) && (scope_conf.Measurement_Value5 = string(get_meas_data(scope, "Meas_Nr5")))
	 
	 # conf acq chan1 and acquire	 
	 (refresh_cnt==base*1) && (conf_acq_ch(scope, "CH1"))
	 (refresh_cnt==base*5) && ((scope_conf.t, scope_conf.y1) = Trigger_Aquistion(scope, "CH1"))
	 
	 # conf acq chan2 and acquire	 
	 (refresh_cnt==base*10) && (conf_acq_ch(scope, "CH2"))
	 (refresh_cnt==base*15) && ((scope_conf.t, scope_conf.y2) = Trigger_Aquistion(scope, "CH2"))	 

end
