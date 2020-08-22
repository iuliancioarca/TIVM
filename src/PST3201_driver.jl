# PST 3201 power suuply driver

mutable struct PST3201
    handle
	initialized
    instr_dict
end
PST3201(handle) = PST3201(
                handle,
				false,
                Dict(
                    "C1"=>"1",
                    "C2"=>"2",
                    "C3"=>"3",
                    "on"=>"1",
                    "off"=>"0",
                    "1"=>"on",
                    "0"=>"off", 
                    "voltage"=>"VOLT",
                    "current"=>"CURR",
                    )
                    )

# MISC
function connect!(obj::PST3201, handle)
	obj.handle = handle
    obj.connected = 1
	return nothing
end
function disconnect!(obj::PST3201)
	obj.handle = 0
    obj.connected = 0
	return nothing
end
reset_instr(obj::PST3201) = write(obj.handle, "*RST")
clear_instr(obj::PST3201) = write(obj.handle, "*CLS")
get_idn(obj::PST3201) = query(obj.handle, "*IDN?")

# SOURCE VOLTAGE
function set_source_lev(obj::PST3201, ch, lev)
    ch = obj.instr_dict[ch]
    cmd = ":CHAN$ch:VOLT $lev"
    write(obj.handle, cmd)
end
function get_source_lev(obj::PST3201, ch)
    ch = obj.instr_dict[ch]
    cmd = ":CHAN$ch:VOLT?"
    value = strip(query(obj.handle, cmd))
end
		
# PROTECTION
function set_volt_protection(obj::PST3201, ch, lev)
    ch = obj.instr_dict[ch]
    cmd = ":CHAN$ch:PROT:VOLT $lev"
    write(obj.handle, cmd)
end
function get_volt_protection(obj::PST3201, ch)
    ch = obj.instr_dict[ch]
    cmd = ":CHAN$ch:PROT:VOLT?"
    value = strip(query(obj.handle, cmd))
end
function set_curr_protection(obj::PST3201, ch, state)
    ch = obj.instr_dict[ch]
    state = obj.instr_dict[state]
    cmd = ":CHAN$ch:PROT:CURR $state"
    write(obj.handle, cmd)
end
function get_curr_protection(obj::PST3201, ch)
    ch = obj.instr_dict[ch]
    cmd = ":CHAN$ch:PROT:CURR?"
    value = strip(query(obj.handle, cmd))
    value = obj.instr_dict[value]
end
function set_max_curr(obj::PST3201, ch, lev)
    ch = obj.instr_dict[ch]
    cmd = ":CHAN$ch:CURR $lev"
    write(obj.handle, cmd)
end
function get_max_curr(obj::PST3201, ch)
    ch = obj.instr_dict[ch]
    cmd = ":CHAN$ch:CURR?"
    value = strip(query(obj.handle, cmd))
end
function reset_protections(obj::PST3201)
    cmd = ":OUTPut:PROTection:CLEar"
    write(obj.handle, cmd)
end
		
# MEASUREMENTS
function get_meas(obj::PST3201, ch, fct)
    ch = obj.instr_dict[ch]
    fct = obj.instr_dict[fct]
    cmd = ":CHAN$ch:MEAS:$fct?"
    value = strip(query(obj.handle, cmd))
end
        
# OUTPUT ON/OFF
function set_outp(obj::PST3201, ch, state)
    ch = obj.instr_dict[ch]
    state = obj.instr_dict[state]
    cmd = ":OUTPut:STATe $state"
    write(obj.handle, cmd)
end
function get_outp(obj::PST3201, ch)
    ch = obj.instr_dict[ch]
    cmd = ":OUTPut:STATe?"
    value = strip(query(obj.handle, cmd))
    value = obj.instr_dict[value]
end        