
function update_dmm_conf!(dmm_conf, dmm, refresh_cnt)
    base = 5
    # measurements
    (refresh_cnt==base*1 || refresh_cnt==base*12) && (dmm_conf.primary = get_primary_measurement(dmm, dmm_conf.crt_chan))
    (refresh_cnt==base*3 || refresh_cnt==base*14) && begin
    if dmm_conf.crt_func == "RIPPLE"
        dmm_conf.secondary = get_secondary_measurement(dmm, dmm_conf.crt_chan)
    else
        dmm_conf.secondary = "----.---"
    end
    end
    # get current function
    (refresh_cnt==base*5 || refresh_cnt==base*17) && (dmm_conf.crt_func = get_sense_func(dmm, dmm_conf.crt_chan))
    # get range
    #(refresh_cnt==base*8 || refresh_cnt==base*20) && (dmm_conf.range = get_sense_range_auto(dmm, dmm_conf.crt_chan))
end
