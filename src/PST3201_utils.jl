
function update_psu_conf!(psu_conf, psu, refresh_cnt)
	 base = 4
     # Meas Voltage more often
     refresh_cnt==base*1 && (psu_conf.C1.volt_meas = get_meas(psu, "C1", "voltage"))
     refresh_cnt==base*2 && (psu_conf.C2.volt_meas = get_meas(psu, "C2", "voltage"))
     refresh_cnt==base*3 && (psu_conf.C3.volt_meas = get_meas(psu, "C3", "voltage"))
     # # Meas Current more often
     refresh_cnt==base*4 && (psu_conf.C1.curr_meas = get_meas(psu, "C1", "current"))
     refresh_cnt==base*5 && (psu_conf.C2.curr_meas = get_meas(psu, "C2", "current"))
     refresh_cnt==base*6 && (psu_conf.C3.curr_meas = get_meas(psu, "C3", "current"))
     # # Update settings
     # # Voltage
     refresh_cnt==base*7 && (psu_conf.C1.volt_set = get_source_lev(psu, "C1"))
     refresh_cnt==base*8 && (psu_conf.C2.volt_set = get_source_lev(psu, "C2"))
     refresh_cnt==base*9 && (psu_conf.C3.volt_set = get_source_lev(psu, "C3"))
     # # Max Current
     refresh_cnt==base*10 && (psu_conf.C1.curr_set = get_max_curr(psu, "C1"))
     refresh_cnt==base*11 && (psu_conf.C2.curr_set = get_max_curr(psu, "C2"))
     refresh_cnt==base*12 && (psu_conf.C3.curr_set = get_max_curr(psu, "C3"))
     # # OVP
     refresh_cnt==base*13 && (psu_conf.C1.ovp_set = get_volt_protection(psu, "C1"))
     refresh_cnt==base*14 && (psu_conf.C2.ovp_set = get_volt_protection(psu, "C2"))
     refresh_cnt==base*15 && (psu_conf.C3.ovp_set = get_volt_protection(psu, "C3"))          
     # # OCP
     refresh_cnt==base*16 && (psu_conf.C1.ocp_set = get_curr_protection(psu, "C1"))
     refresh_cnt==base*17 && (psu_conf.C2.ocp_set = get_curr_protection(psu, "C2"))
     refresh_cnt==base*18 && (psu_conf.C3.ocp_set = get_curr_protection(psu, "C3"))
	 # OUTPUT
	 (refresh_cnt==base*10 || refresh_cnt==base*19)&& (psu_conf.output_state = get_outp(psu, psu_conf.crt_chan))
	 # OUTPUT TOGGLE BUTTON STATE
	 if psu_conf.output_state == "off"
		psu_conf.output_btn.state = false
	 else
		psu_conf.output_btn.state = true
	 end
end
