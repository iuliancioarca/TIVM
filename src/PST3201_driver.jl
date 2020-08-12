# PST 3201 power supply driver


pst3201_dict = Dict(
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


reset_instr(handle) = write(handle, "*RST")
clear_instr(handle) = write(handle, "*CLS")
get_idn(handle) = query(handle, "*IDN?")

# SOURCE VOLTAGE
function set_source_lev(handle, ch, lev)
    ch = pst3201_dict[ch]
    cmd = ":CHAN$ch:VOLT $lev"
    write(handle, cmd)
end
function get_source_lev(handle, ch)
    ch = pst3201_dict[ch]
    cmd = ":CHAN$ch:VOLT ?"
    value = strip(query(handle, cmd))
end
		
# PROTECTION
function set_volt_protection(handle, ch, lev)
    ch = pst3201_dict[ch]
    cmd = ":CHAN$ch:PROT:VOLT $lev"
    write(handle, cmd)
end
function get_volt_protection(handle, ch)
    ch = pst3201_dict[ch]
    cmd = ":CHAN$ch:PROT:VOLT ?"
    value = strip(query(handle, cmd))
end
function set_curr_protection(handle, ch, state)
    ch = pst3201_dict[ch]
    state = pst3201_dict[state]
    cmd = ":CHAN$ch:PROT:CURR $state"
    write(handle, cmd)
end
function get_curr_protection(handle, ch)
    ch = pst3201_dict[ch]
    cmd = ":CHAN$ch:PROT:CURR ?"
    value = strip(query(handle, cmd))
    value = pst3201_dict[value]
end
function set_max_curr(handle, ch, lev)
    ch = pst3201_dict[ch]
    cmd = ":CHAN$ch:CURR $lev"
    write(handle, cmd)
end
function get_max_curr(handle, ch)
    ch = pst3201_dict[ch]
    cmd = ":CHAN$ch:CURR ?"
    value = strip(query(handle, cmd))
end
function reset_protections(handle)
    cmd = ":OUTPut:PROTection:CLEar"
    write(handle, cmd)
end
		
# MEASUREMENTS
function get_meas(handle, ch, fct)
    ch = pst3201_dict[ch]
    fct = pst3201_dict[fct]
    cmd = ":CHAN$ch:MEAS:$fct ?"
    value = strip(query(handle, cmd))
end
        
# OUTPUT ON/OFF
function set_outp(handle, ch, state)
    ch = pst3201_dict[ch]
    state = pst3201_dict[state]
    cmd = ":OUTPut:STATe $state"
    write(handle, cmd)
end
function get_outp(handle, ch)
    ch = pst3201_dict[ch]
    cmd = ":OUTPut:STATe ?"
    value = strip(query(handle, cmd))
    value = pst3201_dict[value]
end        