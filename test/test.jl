using TIVM

# connect to power supply. the name MUST be "psu" in order for the GUI to work
psu = connect!("ASRL14::INSTR")

# warmup
try
	query(psu, "*IDN?")
catch
	query(psu, "*IDN?")
end

# start GUI
schedule(@task TIVM.start_gui(psu))

# disconnect
#disconnect!(psu)