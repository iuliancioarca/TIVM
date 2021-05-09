# ADALM2000 analog out(2ch function generator)

# Just write custom mutable structs until xml parsing is implemented
mutable struct M2K_DAC_VOLTAGEx
    handle
end
mutable struct M2kAnalogOut
    handle
    name
    id
    voltage0
    calibscale
    dma_sync
    dma_sync_start
    oversampling_ratio
    sampling_frequency
    sampling_frequency_available
	modules_dict
	shared_devices
	buffer
	wfm_dict
	rev_wfm_dict
	fct
	freq
	ampl
	offs
	duty
end
function M2kAnalogOut(ctx, device="M2kAnalogOut_a")
	modules_dict=Dict(
		"M2kAnalogOut_a"=>10,
		"M2kAnalogOut_b"=>11
        )
	handle = LibIIO.iio_context_get_device(ctx.handle, modules_dict[device])
    name = unsafe_string(LibIIO.iio_device_get_name(handle))
    id = unsafe_string(LibIIO.iio_device_get_id(handle))
    nch = LibIIO.iio_device_get_channels_count(handle)

    ch_handle = LibIIO.iio_device_get_channel(handle,0)
	# some modules are shared between instruments: m2kfabric, ad5625...
	shared_devices=Dict();
	shared_devices["M2kFabric"] = M2KFabric(ctx.handle, 3)

	LibIIO.iio_channel_attr_write_bool(shared_devices["M2kFabric"].voltage0_o.handle,"powerdown",false)
	LibIIO.iio_channel_attr_write_bool(shared_devices["M2kFabric"].voltage1_o.handle,"powerdown",false)
	LibIIO.iio_channel_attr_write_bool(shared_devices["M2kFabric"].voltage0_i.handle,"powerdown",false)
	LibIIO.iio_channel_attr_write_bool(shared_devices["M2kFabric"].voltage1_i.handle,"powerdown",false)
	LibIIO.iio_device_attr_write_bool(shared_devices["M2kFabric"].handle,"clk_powerdown",false)
	LibIIO.iio_channel_attr_write_bool(shared_devices["M2kFabric"].voltage0_o.handle,"powerdown",false)
	LibIIO.iio_channel_attr_write_bool(shared_devices["M2kFabric"].voltage2_o.handle,"user_supply_powerdown",false)
    voltage0 = M2K_DAC_VOLTAGEx(ch_handle)

    calibscale = LibIIO.iio_device_attr_read_double(handle,"calibscale")
    dma_sync = LibIIO.iio_device_attr_read_bool(handle,"dma_sync")
    dma_sync_start = LibIIO.iio_device_attr_read_bool(handle,"dma_sync_start")
    oversampling_ratio = LibIIO.iio_device_attr_read_double(handle,"oversampling_ratio")
    sampling_frequency = LibIIO.iio_device_attr_read_double(handle,"sampling_frequency")
    sampling_frequency_available = LibIIO.iio_device_attr_read(handle,"sampling_frequency_available")

	# initial setup
	# set single kernel buffer
	LibIIO.iio_device_set_kernel_buffers_count(handle,1)

	# enable channels
	LibIIO.iio_channel_enable(voltage0.handle)
	# cyclic buffer for waveform samples
	buffer = LibIIO.iio_device_create_buffer(handle,256,true)
	# configure DACs
	LibIIO.iio_device_attr_write_double(handle,"sampling_frequency",75_000)
	LibIIO.iio_device_attr_write_double(handle,"oversampling_ratio",1)

	wfm_dict = Dict("sinusoid"=>"1",
					"triangle"=>"2",
					"square"=>"3")

    rev_wfm_dict = Dict("1"=>"sinusoid",
					"2"=>"triangle",
					"3"=>"square")

	fct = "sinusoid"
	freq = 1e3
	ampl = 1
	offs = 0
	duty = 50

    M2kAnalogOut(handle,name,id,voltage0,calibscale,dma_sync,dma_sync_start,
    oversampling_ratio,sampling_frequency,sampling_frequency_available,
	modules_dict,shared_devices,buffer,wfm_dict,rev_wfm_dict,fct,freq,ampl,offs,duty)
end

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
reset_instr(obj::M2kAnalogOut) = "not implemented"
clear_instr(obj::M2kAnalogOut) = "not implemented"
get_idn(obj::M2kAnalogOut) = obj.name*obj.id

## WFM
function set_wfm(obj::M2kAnalogOut, ch, fct="sinusoid")
	# set_wfm(fgen, "C1", "sinusoid")
	obj.fct = fct

	m_filter_compensation_table = Dict()
	m_filter_compensation_table[75E6] = 1.1;
	m_filter_compensation_table[75E5] = 1.525879;
	m_filter_compensation_table[75E4] = 1.234153;
	m_filter_compensation_table[75E3] = 1.776357;
	m_filter_compensation_table[75E2] = 1.355253;
	m_filter_compensation_table[75E1] = 1.033976;
	for i=1:1
		#create a signal
		if obj.fct == "sinusoid"
			y,Fs = gen_sine(obj.freq, obj.ampl, obj.offs, obj.duty)
		elseif obj.fct == "square"
			y,Fs = gen_square(obj.freq, obj.ampl, obj.offs, obj.duty)
		elseif obj.fct == "triangle"
			y,Fs = gen_triangle(obj.freq, obj.ampl, obj.offs, obj.duty)
		end
		vlsb = 10/(2^12-1)
		x = Int16.(round.(((y .* (-1 * (1 / vlsb)) .- 0.5) ./ m_filter_compensation_table[Fs]))) .<< 4
		LibIIO.iio_device_attr_write_double(obj.handle,"sampling_frequency",Fs)
		LibIIO.iio_buffer_destroy(obj.buffer)

		# set single kernel buffer
		LibIIO.iio_device_set_kernel_buffers_count(obj.handle,1)
		LibIIO.iio_device_attr_write_bool(obj.handle,"dma_sync_start",false)
		sleep(0.05)
		# init DAC buffers
		obj.buffer = LibIIO.iio_device_create_buffer(obj.handle,length(x),true)
		# LibIIO.iio_device_attr_write_bool(obj.handle,"dma_sync",true)
		# update buf
		LibIIO.iio_channel_write(obj.voltage0.handle, obj.buffer,x,length(x)*2)
		# send samples to hw
		LibIIO.iio_buffer_push(obj.buffer)
		# LibIIO.iio_device_attr_write_bool(obj.handle,"dma_sync_start",true) # sync both chA and chB
		LibIIO.iio_device_attr_write_bool(obj.handle,"dma_sync",false)
	end
end

function get_wfm(obj::M2kAnalogOut, ch)
	# get_wfm(fgen, "C1")
	obj.fct
end

# UNIT
function set_amplit_unit(obj::M2kAnalogOut, ch, unit="Vpp")
	# set_amplit_unit(fgen, "C1", "Vpp")
	@warn "not implemented"
end
function get_amplit_unit(obj::M2kAnalogOut, ch)
	# get_amplit_unit(fgen, "C1")
	#@warn "not implemented;default Vpp"
    "Vpp"
end

# AMPLITUDE
function set_amplit(obj::M2kAnalogOut, ch, value)
	# set_amplit(fgen, "C1", 2.2)
	obj.ampl = value
	set_wfm(obj, ch, obj.fct)
end
function get_amplit(obj::M2kAnalogOut, ch)
	# get_amplit(fgen, "C1")
	obj.ampl
end

# OFFSET
function set_offs(obj::M2kAnalogOut, ch, value)
	# set_offs(fgen, "C1", 1.1)
	obj.offs = value
	set_wfm(obj, ch, obj.fct)
end
function get_offs(obj::M2kAnalogOut, ch)
	# get_offs(fgen, "C1")
	obj.offs
end

# FREQUENCY
function set_freq(obj::M2kAnalogOut, ch, value)
	# set_freq(fgen, "C1", 1333)
	obj.freq = value
	set_wfm(obj, ch, obj.fct)
end
function get_freq(obj::M2kAnalogOut, ch)
	# get_freq(fgen, "C1")
	obj.freq
end

# DUTY CYCLE
function set_duty(obj::M2kAnalogOut, ch, value)
	# set_duty(fgen, "C1", 40)
	obj.duty = value
	set_wfm(obj, ch, obj.fct)
end
function get_duty(obj::M2kAnalogOut, ch)
	# get_duty(fgen, "C1")
	obj.duty
end

# generate waveforms
function gen_sine(freq, ampl, offs, duty)
    baseFs = 75
    expo = nextpow(10,freq*10)
    Fs = min(75e6, baseFs*expo)
    npts = 100*Int64(round(Fs/freq))
    # npts=nextpow(2,npts)
	t=range(0; stop=200*pi, length=npts)
    y = (ampl .*sin.(t)) .- (ampl*0.05) .+ offs
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
