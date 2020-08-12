
function update_fgen_conf!(fgen_conf, fgen::GFG3015, refresh_cnt)
    base = 10
    (refresh_cnt==base*1) && (fgen_conf.crt_func = get_wfm(fgen, fgen_conf.crt_chan))
	
	# this is the most frequent source of timeouts
    #(refresh_cnt==base*2) && (fgen_conf.amplit_unit = get_amplit_unit(fgen, fgen_conf.crt_chan))

	(refresh_cnt==base*4) && (fgen_conf.freq = get_freq(fgen, fgen_conf.crt_chan))
	(refresh_cnt==base*5) && (fgen_conf.amplit = get_amplit(fgen, fgen_conf.crt_chan))
	(refresh_cnt==base*6) && (fgen_conf.offs = get_offs(fgen, fgen_conf.crt_chan))
	
    (refresh_cnt==base*7) && (fgen_conf.duty = get_duty(fgen, fgen_conf.crt_chan))
    return nothing
end

function toggle_func!(fgen::GFG3015, fgen_conf)
    idx_sel = parse(Int64, fgen_conf.idx_sel)
    idx_sel += 1
    idx_sel > 3 ? idx_sel=1 : idx_sel
    crt_fct = fgen.rev_wfm_dict["$idx_sel"]
    set_wfm(fgen, fgen_conf.crt_chan, crt_fct)
    fgen_conf.idx_sel = string(idx_sel)
    return nothing
end