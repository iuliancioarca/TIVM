
function update_dmm_conf!(dmm_conf, dmm, refresh_cnt, base)    
    # measurements
    refresh_cnt==base*1  && (dmm_conf.primary = string(get_primary_measurement(dmm, dmm_conf.crt_chan)))
    refresh_cnt==base*5  && begin
    if dmm_conf.crt_func == "RIPPLE"
        dmm_conf.secondary = string(get_secondary_measurement(dmm, dmm_conf.crt_chan))
    else
        dmm_conf.secondary = "----.---"
    end
    end
    # get current function
    refresh_cnt==base*10 && (dmm_conf.crt_func = get_sense_func(dmm, dmm_conf.crt_chan))
    # get range
    #refresh_cnt==base*15 && (dmm_conf.range = get_sense_range_auto(dmm, dmm_conf.crt_chan))
end
