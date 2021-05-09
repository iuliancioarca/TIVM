#M2kAnalogIn scope driver

mutable struct M2kAnalogIn
    handle
	initialized
    instr_dict
	meas_ch_dict
	meas_type_dict
	hor_scale
	nb_samples
	sampling_rate
	trig_handle
	trig_chan
end

M2kAnalogIn(handle) = M2kAnalogIn(
                handle,
				false,
                Dict(
                    "CH1"=>0,
                    "CH2"=>1,
					"on"=>1,
					"off"=>0
                    ),
				Dict(
                    "MEAS1"=>0,
                    "MEAS2"=>0,
					"MEAS3"=>0,
					"MEAS4"=>0,
					"MEAS5"=>0,
                    ),
				Dict(
                    "MEAS1"=>"FREQuency",
                    "MEAS2"=>"PERIod",
					"MEAS3"=>"MEAN",
					"MEAS4"=>"PK2pk",
					"MEAS5"=>"CRMs",
                    ),					
				1e-3,
				1e3,
				20e6,
				nothing,
				0
                    )

### MISC
function connect!(obj::M2kAnalogIn, handle)
    obj.handle = handle
    obj.connected = 1
	# set one kernel buffer
	setKernelBuffersCount(obj.handle, 1)
	obj.trig_handle = getTrigger(obj.handle)
    return nothing
    end
function disconnect!(obj::M2kAnalogIn)
    obj.handle = 0
    obj.connected = 0
    return nothing
    end

reset_instr(obj::M2kAnalogIn) = @warn "Not available for ADALM2000"
clear_instr(obj::M2kAnalogIn) = @warn "Not available for ADALM2000"
get_idn(obj::M2kAnalogIn) = "m2kanalogin"

function auto_set(obj::M2kAnalogIn)
	@warn "Auto-set not available for ADALM2000 AnalogIN"
end


### VERTICAL
function set_ch_state(obj::M2kAnalogIn, ch, st)
	ch = obj.instr_dict[ch]
	st = obj.instr_dict[st]
	enableChannel(obj.handle, ch, st)
end
function get_ch_state(obj::M2kAnalogIn, ch)
	ch = obj.instr_dict[ch]
	isChannelEnabled(obj.handle, ch)
end
function set_vertical_scale(obj::M2kAnalogIn, ch, value)
	ch = obj.instr_dict[ch]
	pkpk = value*8
	min_val = -pkpk/2
	max_val = pkpk/2
	setRangeMinMax(obj.handle, ch, min_val, max_val)
	#setRange(obj.handle, ch, pkpk)
end
function get_vertical_scale(obj::M2kAnalogIn, ch)
    ch = obj.instr_dict[ch]
    @warn "not implemented yet for ADALM2000"
end

function set_vertical_offset(obj::M2kAnalogIn, ch, lev)
	ch = obj.instr_dict[ch]
	setVerticalOffset(obj.handle, ch, lev)
end
function get_vertical_offset(obj::M2kAnalogIn, ch)
	ch = obj.instr_dict[ch]
	getVerticalOffset(obj.handle, ch)
end

function set_ch_coupling(obj::M2kAnalogIn, ch, cpl)
	@warn "set_ch_coupling not available for ADALM2000 AnalogIN"
end
function get_ch_coupling(obj::M2kAnalogIn, ch)
	@warn "get_ch_coupling not available for ADALM2000 AnalogIN"
	return "DC1M"
end



### HORIZONTAL
function set_horizontal_scale(obj::M2kAnalogIn, value)
	obj.hor_scale = value
	duration = obj.hor_scale*10
	obj.nb_samples = Int64(round(duration * obj.sampling_rate))
	return nothing
end
function get_horizontal_scale(obj::M2kAnalogIn, time)
	obj.hor_scale
end
function set_sample_rate(obj::M2kAnalogIn, sr)
	obj.hor_scale
end

### TRIGGER
function set_trig_mode(obj::M2kAnalogIn, mode)
    # AUTO or NORMal
    @warn "not implemented yet for ADALM2000"
end
function set_trig_ch(obj::M2kAnalogIn, ch)
	ch = obj.instr_dict[ch]
	obj.trig_chan = ch
	setAnalogSourceChannel(obj.trig_handle, obj.trig_chan)
end
function get_trig_ch(obj::M2kAnalogIn)
	getAnalogSourceChannel(obj.trig_handle)
end

function set_trig_level(obj::M2kAnalogIn, level)
	setAnalogLevel(obj.trig_handle, obj.trig_chan, level)
end
function get_trig_level(obj::M2kAnalogIn)
	getAnalogLevel(obj.trig_handle, obj.trig_chan)
end

function get_trig_data(obj::M2kAnalogIn, trig)
	@warn "not implemented yet for ADALM2000"
end


### MEASUREMENTS
function set_meas_ch(obj::M2kAnalogIn, Meas_Nr1, ch)
	ch = obj.instr_dict[ch]
	obj.meas_ch_dict[Meas_Nr1] = ch
end

function set_meas_type(obj::M2kAnalogIn, Meas_Nr1, Type)
	obj.meas_type_dict[Meas_Nr1] = Type
end

function set_meas(obj::M2kAnalogIn, Meas_Nr1, ch, Type)
	set_meas_ch(obj,Meas_Nr1, ch)
    set_meas_type(obj, Meas_Nr1, Type)
end
function get_meas_data(obj::M2kAnalogIn, Meas_Nr1)
	t1, y1 = fetch_wfm(obj, "CH1")
	t2, y2 = fetch_wfm(obj, "CH2")
	# 5 meas max Measurement_Type =["FREQuency","MEAN","PERIod","PK2pk","CRMs","MINImum","MAXImum","RISe","FALL","PWIdth","NWIdth"]
	type = obj.meas_type_dict[Meas_Nr1]
	ch = obj.meas_ch_dict[Meas_Nr1]
	if ch == 0
		y = y1
		t = t1
	else
		y=y2
		t = t2
	end
	if type == "FREQuency"
		meas_freq(t,y)
	elseif type == "MEAN"
		meas_mean(y)
	elseif type == "PERIod"
		meas_period(t,y)
	elseif type == "PK2pk"
		meas_pkpk(y)
	elseif type == "CRMs"
		meas_CRMS(y)
	elseif type == "MINImum"
		meas_min(y)
	elseif type == "MAXImum"
		meas_max(y)
	elseif type == "RISe"
		meas_rise(t,y)
	elseif type == "FALL"
		meas_fall(t,y)
	elseif type == "PWIdth"
		meas_pwidth(t,y)
	elseif type == "NWIdth"
		meas_fall(t,y)
	else
		@error "no compatible measurement"
	end
end


### WAVEFORM ACQUISITION
function init_acq(obj::M2kAnalogIn)
	max_srate = min(100e6, round(obj.nb_samples/(10*obj.hor_scale)))
	setSampleRate(obj.handle, max_srate)
	setKernelBuffersCount(obj.handle, 1)
	startAcquisition(obj.handle, obj.nb_samples)
end

function fetch_wfm(obj::M2kAnalogIn, ch)
	ch = obj.instr_dict[ch]
	max_srate = min(100e6, round(obj.nb_samples/(10*obj.hor_scale)))
	dt = 1/max_srate

	xi = getSamplesInterleaved(obj.handle, obj.nb_samples)
	nb = Int64(round(2*obj.nb_samples))
	data = zeros(Float64, nb) # 2 channels x 32 Float64 samples
	for i in 1:nb
		data[i] = unsafe_load(xi,i)
	end
	#data needs to be split between channels
	y1 = data[1:2:end-1]
	y2 = data[2:2:end]

	t = collect(0:dt:dt*(length(y1)-1))
	if ch==0
		y=y1
	else
		y=y2
	end
	return t, y
end

### MEASUREMENT UTILITIES
function meas_freq(t,y)
	1/meas_period(t,y)
end
function meas_mean(y)
	mean(y)
end
function meas_period(t,y)
	# remove mean
	y .= y .- meas_mean(y)
	dt = t[2] - t[1]
	f = fft(y)
	l = Int64(round(length(f)/2))
	fabs = abs.(f)[1:l]

	freq = range(0; stop=1/dt/2, length=l)
	p0 = 1/freq[argmax(fabs)]


	#thr = 0.5*meas_pkpk(y)
	#idx1 = findall(y .< thr)
	#idx2 = findall(y .> -thr)
	#idx3 = intersect(idx1, idx2)
	#idx4 = idx3[2:end] - idx3[1:end-1]

	#idx5 = findall(idx4 .> 3)

	#idx6 = idx3[idx5]
	#t0 = t[idx6]
	#p0 = 2 .* (t0[2:end] - t0[1:end-1])
end
function meas_pkpk(y)
	# remove mean
	y .= y .- meas_mean(y)
	meas_max(y) - meas_min(y)
end
function meas_CRMS(y)
	sqrt(sum(y.^2.) / length(y))
end
function meas_min(y)
	minimum(y)
end
function meas_max(y)
	maximum(y)
end
function meas_rise(t,y)
	@warn "not implemented yet for ADALM2000"
	0
end
function meas_fall(t,y)
	@warn "not implemented yet for ADALM2000"
	0
end
function meas_pwidth(t,y)
	@warn "not implemented yet for ADALM2000"
	0
end
function meas_nwidth(t,y)
	@warn "not implemented yet for ADALM2000"
	0
end
