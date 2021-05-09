# M2kAnalogOut digital multimeter driver
# CH2 is not used for TIVM GUI

mutable struct M2kAnalogOut
    handle
	initialized
    instr_dict
	wfm_dict
	rev_wfm_dict
	unit_dict
	fct_dict
	amplit_dict
	offs_dict
	freq_dict
	duty_dict
	data_dict
	Fs_dict
end
M2kAnalogOut(handle) = M2kAnalogOut(
                handle,
				false,
                Dict(
                    "C1"=>0,
					"C2"=>1,
                    ),
                Dict(
					"sinusoid"=>"1",
					"triangle"=>"2",
					"square"=>"3",
                    ),	
                Dict(
                    "1"=>"sinusoid",
					"2"=>"triangle",
					"3"=>"square",
                    ),					
                Dict(
					"Vpp"=>"1",
					"Vrms"=>"2",
					"dBm"=>"3",				
					"1"=>"Vpp",
					"2"=>"Vrms",
					"3"=>"dBm",
                    ),					
				Dict(
					"C1"=>"sinusoid",
					"C2"=>"sinusoid"
					),
				Dict(
					"C1"=>0.01,
					"C2"=>0.01
					),
				Dict(
					"C1"=>0.0,
					"C2"=>0.0
					),
				Dict(
					"C1"=>1e3,
					"C2"=>1e3
					),
				Dict(
					"C1"=>50.0,
					"C2"=>50.0
					),
				Dict(
					"C1"=>[],
					"C2"=>[]
					),
				Dict(
					"C1"=>7.5e6,
					"C2"=>7.5e6
					)
                    )

# MISC
function connect!(obj::M2kAnalogOut, handle)
	obj.handle = handle
    obj.connected = 1
	return nothing
end
function disconnect!(obj::M2kAnalogOut)
	obj.handle = 0
    obj.connected = 0
	return nothing
end
reset_instr(obj::M2kAnalogOut) = @warn "Not available for ADALM2000"
clear_instr(obj::M2kAnalogOut) = @warn "Not available for ADALM2000"
get_idn(obj::M2kAnalogOut) = "m2kanalogout"


# generate waveforms
function gen_sine(freq, ampl, offs, duty)
    baseFs = 75
    expo = nextpow(10,freq*10)
    Fs = min(75e6, baseFs*expo)
    npts = 100*Int64(round(Fs/freq))
    # npts=nextpow(2,npts)
	t=range(0; stop=200*pi, length=npts)
    #y = (ampl .*sin.(t)) .- (ampl*0.05) .+ offs
	y = (ampl .*sin.(t)) .+ offs
	return y, Fs
end

function gen_square(freq, ampl, offs, duty)
	baseFs = 75
	expo = nextpow(10,freq*10)
	Fs = min(75e6, baseFs*expo)
	npts = Int64(round(Fs/freq))
	# positive part
	npts_pos = Int64(round(npts*duty/100))
	y_pos = ampl .* ones(npts_pos)
	# negative part
	npts_neg = npts - npts_pos
	y_neg = -ampl .* ones(npts_neg)
	# npts=nextpow(2,npts)
	y = repeat([y_pos;y_neg],100)
	y .= y .+ offs
	return y, Fs
end

function gen_triangle(freq, ampl, offs, duty)
    baseFs = 75
    expo = nextpow(10,freq*10)
    Fs = min(75e6, baseFs*expo)
    npts = Int64(round(Fs/freq))
    # positive part
	npts_pos = Int64(round(npts/2))
	y_pos = range(-ampl; stop=ampl, length=npts_pos)
	# negative part
	npts_neg = npts - npts_pos
	y_neg = range(ampl; stop=-ampl, length=npts_neg)
	# npts=nextpow(2,npts)
	y = repeat([y_pos;y_neg],100)
	y .= y .+ offs
	return y, Fs
end

# push waveforms
function gen_wfm!(obj::M2kAnalogOut, ch)
	fct = obj.fct_dict[ch] 
	
	freq = obj.freq_dict[ch]
	ampl = obj.amplit_dict[ch]
	offs = obj.offs_dict[ch]
	duty = obj.duty_dict[ch]
	
	if fct == "sinusoid"
		y, Fs = gen_sine(freq, ampl, offs, duty)
	elseif fct == "square"
		y, Fs = gen_square(freq, ampl, offs, duty)
	elseif fct == "triangle"
		y, Fs = gen_triangle(freq, ampl, offs, duty)
	end
	obj.Fs_dict[ch] = Fs
	obj.data_dict[ch] = y
	return nothing
end

function push_wfms(obj::M2kAnalogOut)
	y1 = obj.data_dict["C1"] 
	#y2 = obj.data_dict["C2"]
	y2 = y1
	
	l1 = length(y1)
	l2 = length(y2)
	if l1 !=l2
		@warn "C1 and C2 waveforms must have the same length"
	end
	
	nb_channels = 2
	nb_samples = l1 + l2
	
	data = [y1 y2]'[:]
	
	enableChannelFgen(obj.handle, 0, 1) # enable channels otherwrise pushing data fails
	enableChannelFgen(obj.handle, 1, 1) # enable channels otherwrise pushing data fails
	
	setSampleRateFgen(obj.handle, 0, obj.Fs_dict["C1"])
	setSampleRateFgen(obj.handle, 1, obj.Fs_dict["C2"])
	
	pushInterleaved(obj.handle, data, nb_channels, nb_samples)
	setCyclicCh(obj.handle, 0, 1)
	setCyclicCh(obj.handle, 1, 1)
	
end


## For single channel push. at the moment the push function crashes randomly
#function push_wfm(obj::M2kAnalogOut, ch)
#	data = obj.data_dict[ch] 
#
#	chan = obj.instr_dict[ch]
#	
#	setKernelBuffersCountFgen(obj.handle, chan, 1)
#	
#	enableChannelFgen(obj.handle, 0, 0) # disable the other channel otherwrise pushing data fails
#	enableChannelFgen(obj.handle, 1, 0) # disable the other channel otherwrise pushing data fails
#	
#	enableChannelFgen(obj.handle, chan, 1) # enable channel otherwrise pushing data fails
#	
#	setSampleRateFgen(obj.handle, chan, obj.Fs_dict[ch])
#
#	push(obj.handle, chan, data, sizeof(data))
#	setCyclicCh(obj.handle, chan, 1)
#	enableChannelFgen(obj.handle, 0, 1)
#	enableChannelFgen(obj.handle, 1, 1)
#end
#function push_wfms(obj::M2kAnalogOut)
#	push_wfm(obj, "C1")
#	push_wfm(obj, "C2")
#end



## WFM
function set_wfm(obj::M2kAnalogOut, ch, fct="sinusoid")
	# set_wfm(fgen, "C1", "sinusoid")
	obj.fct_dict[ch] = fct
	gen_wfm!(obj, "C1")
	gen_wfm!(obj, "C2")
	push_wfms(obj)
end
function get_wfm(obj::M2kAnalogOut, ch)
	# get_wfm(fgen, "C1")
	obj.fct_dict[ch]
end

# UNIT	
function set_amplit_unit(obj::M2kAnalogOut, ch, unit="Vpp")
	# set_amplit_unit(fgen, "C1", "Vpp")
	@warn "Only Vpp available for ADALM2000"
end
function get_amplit_unit(obj::M2kAnalogOut, ch)
	# get_amplit_unit(fgen, "C1")
	return "Vpp"
end

# AMPLITUDE
function set_amplit(obj::M2kAnalogOut, ch, value)
	# set_amplit(fgen, "C1", 2.2)
	obj.amplit_dict[ch] = value
	gen_wfm!(obj, "C1")
	gen_wfm!(obj, "C2")
	push_wfms(obj)
end
function get_amplit(obj::M2kAnalogOut, ch)
	# get_amplit(fgen, "C1")
	obj.amplit_dict[ch]
end

# OFFSET
function set_offs(obj::M2kAnalogOut, ch, value)
	# set_offs(fgen, "C1", 1.1)
	obj.offs_dict[ch] = value
	gen_wfm!(obj, "C1")
	gen_wfm!(obj, "C2")
	push_wfms(obj)
end
function get_offs(obj::M2kAnalogOut, ch)
	# get_offs(fgen, "C1")
	obj.offs_dict[ch]
end

# FREQUENCY
function set_freq(obj::M2kAnalogOut, ch, value)
	# set_freq(fgen, "C1", 1333)
	obj.freq_dict[ch] = value
	gen_wfm!(obj, "C1")
	gen_wfm!(obj, "C2")
	push_wfms(obj)
end
function get_freq(obj::M2kAnalogOut, ch)
	# get_freq(fgen, "C1")
	obj.freq_dict[ch]
end

# DUTY CYCLE
function set_duty(obj::M2kAnalogOut, ch, value)
	# set_duty(fgen, "C1", 40)
	obj.duty_dict[ch] = value
	gen_wfm!(obj, "C1")
	gen_wfm!(obj, "C2")
	push_wfms(obj)
end
function get_duty(obj::M2kAnalogOut, ch)
	# get_duty(fgen, "C1")
	obj.duty_dict[ch]
end



