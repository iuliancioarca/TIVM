
function update_gdm8246_state!(gdm8246_meas, gdm8246_sett, dmm::GDM8246, refresh_cnt)
    base = 10
    # measurements
    (refresh_cnt==base*1) && (gdm8246_meas.primary = get_primary_measurement(dmm, gdm8246_conf.selected_channel))
    (refresh_cnt==base*3) && begin
    if gdm8246_conf.selected_func == "RIPPLE"
        gdm8246_meas.secondary = get_secondary_measurement(dmm, gdm8246_conf.selected_channel)
    else
        gdm8246_meas.secondary = "----.---"
    end
    end
    # get current function
    (refresh_cnt==base*5) && (gdm8246_conf.selected_func = get_sense_func(dmm, gdm8246_conf.selected_channel))
    # get range
    #(refresh_cnt==base*8) && (gdm8246_sett.range = get_sense_range_auto(dmm, gdm8246_conf.selected_channel))
end
