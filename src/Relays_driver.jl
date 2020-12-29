# Relays driver

mutable struct Relays
    handle
	initialized
    instr_dict
end
Relays(handle) = Relays(
                handle,
				false,
                Dict(
                    "on"=>"1",
                    "off"=>"0",
					"1"=>"on",
					"0"=>"off",
					"C1"=>"1",
					"C2"=>"2",
					"C3"=>"3",
					"C4"=>"4",
					"C5"=>"5",
					"C6"=>"6",
					"C7"=>"7",
					"C8"=>"8",
					"C9"=>"9"
                    ))

# MISC
function connect!(obj::Relays, handle)
	obj.handle = handle
    obj.connected = 1
	return nothing
end
function disconnect!(obj::Relays)
	obj.handle = 0
    obj.connected = 0
	return nothing
end
#reset_instr(obj::Relays) = write(obj.handle, "*RST")
#clear_instr(obj::Relays) = write(obj.handle, "*CLS")
get_idn(obj::Relays) = query(obj.handle, "*IDN?")

function set_state(obj::Relays, ch, st)
	ch = obj.instr_dict[ch]
	st = obj.instr_dict[st]
	cmd = ":SET:PIN$ch $st"
	write(obj.handle, cmd)
end


function get_state(obj::Relays, ch)
	ch = obj.instr_dict[ch]
	cmd = ":SET:PIN$ch?"
	st = query(obj.handle, cmd)
	st = obj.instr_dict[st]
end


function all_off(obj::Relays)
	for i=1:9
		set_state(obj, "C$i", "off")
		sleep(0.25)
	end
end
