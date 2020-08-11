# PST 3201 power suuply driver
# types
mutable struct PST3201
    handle
	address
	initialized
    instr_dict
end
PST3201(handle, address) = PST3201(
                UInt32(handle),
				address,
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
function connect(obj::PST3201)
    obj.connected = 1
end
function disconnect(obj::PST3201)
    obj.connected = 0
end
reset_instr(obj::PST3201) = viWrite(obj.handle, "*RST\n")
clear_instr(obj::PST3201) = viWrite(obj.handle, "*CLS\n")
get_idn(obj::PST3201) = query(obj.handle, "*IDN?\n")

# SOURCE VOLTAGE
function set_source_lev(obj::PST3201, ch, lev)
    ch = obj.instr_dict[ch]
    cmd = ":CHAN$ch:VOLT $lev\n"
    viWrite(obj.handle, cmd)
end
function get_source_lev(obj::PST3201, ch)
    ch = obj.instr_dict[ch]
    cmd = ":CHAN$ch:VOLT ?\n"
    value = strip(query(obj.handle, cmd))
end
		
# PROTECTION
function set_volt_protection(obj::PST3201, ch, lev)
    ch = obj.instr_dict[ch]
    cmd = ":CHAN$ch:PROT:VOLT $lev\n"
    viWrite(obj.handle, cmd)
end
function get_volt_protection(obj::PST3201, ch)
    ch = obj.instr_dict[ch]
    cmd = ":CHAN$ch:PROT:VOLT ?\n"
    value = strip(query(obj.handle, cmd))
end
function set_curr_protection(obj::PST3201, ch, state)
    ch = obj.instr_dict[ch]
    state = obj.instr_dict[state]
    cmd = ":CHAN$ch:PROT:CURR $state\n"
    viWrite(obj.handle, cmd)
end
function get_curr_protection(obj::PST3201, ch)
    ch = obj.instr_dict[ch]
    cmd = ":CHAN$ch:PROT:CURR ?\n"
    value = strip(query(obj.handle, cmd))
    value = obj.instr_dict[value]
end
function set_max_curr(obj::PST3201, ch, lev)
    ch = obj.instr_dict[ch]
    cmd = ":CHAN$ch:CURR $lev\n"
    viWrite(obj.handle, cmd)
end
function get_max_curr(obj::PST3201, ch)
    ch = obj.instr_dict[ch]
    cmd = ":CHAN$ch:CURR ?\n"
    value = strip(query(obj.handle, cmd))
end
function reset_protections(obj::PST3201)
    cmd = ":OUTPut:PROTection:CLEar\n"
    viWrite(obj.handle, cmd)
end
		
# MEASUREMENTS
function get_meas(obj::PST3201, ch, fct)
    ch = obj.instr_dict[ch]
    fct = obj.instr_dict[fct]
    cmd = ":CHAN$ch:MEAS:$fct ?\n"
    value = strip(query(obj.handle, cmd))
end
        
# OUTPUT ON/OFF
function set_outp(obj::PST3201, ch, state)
    ch = obj.instr_dict[ch]
    state = obj.instr_dict[state]
    cmd = ":OUTPut:STATe $state\n"
    viWrite(obj.handle, cmd)
end
function get_outp(obj::PST3201, ch)
    ch = obj.instr_dict[ch]
    cmd = ":OUTPut:STATe ?\n"
    value = strip(query(obj.handle, cmd))
    value = obj.instr_dict[value]
end        