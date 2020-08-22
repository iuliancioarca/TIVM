using TIVM

dmm = connect!("ASRL5::INSTR")
psu = connect!("ASRL14::INSTR")
fgen = connect!("ASRL8::INSTR")
scope = connect!("USB0::0x0699::0x0364::C057729::INSTR")


# warmup
try
	@info query(psu, "*IDN?")
	@info query(dmm, "*IDN?")
	@info query(fgen, "*IDN?")
	@info query(scope, "*IDN?")
catch
	@info query(psu, "*IDN?")
	@info query(dmm, "*IDN?")
	@info query(fgen, "*IDN?")
	@info query(scope, "*IDN?")
end

# START gui
@async TIVM.start_gui(psu_handle = psu, dmm_handle = dmm, fgen_handle = fgen, scope_handle = scope)


# disconnect
#disconnect!(psu)
#disconnect!(dmm)
#disconnect!(fgen)
#disconnect!(scope)