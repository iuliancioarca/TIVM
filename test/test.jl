using TIVM

# connect to power supply. the name MUST be "psu" in order for the GUI to work
psu = connect!("ASRL14::INSTR")
# connect to multimeter. the name MUST be "dmm" in order for the GUI to work
dmm = connect!("ASRL5::INSTR")
# connect to fgen. the name MUST be "fgen" in order for the GUI to work
fgen = connect!("ASRL8::INSTR")

# warmup
try
	@info query(psu, "*IDN?")
	@info query(dmm, "*IDN?")
	@info query(fgen, "*IDN?")
catch
	@info query(psu, "*IDN?")
	@info query(dmm, "*IDN?")
	@info query(fgen, "*IDN?")
end

# start GUI
@async TIVM.start_gui(psu, dmm, fgen)

# disconnect
#disconnect!(psu)
#disconnect!(dmm)
#disconnect!(fgen)