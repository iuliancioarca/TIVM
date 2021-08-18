# TIVM

]add https://github.com/iuliancioarca/TIVM.git

```
using TIVM

dmm_handle = connect!("ASRL1::INSTR")
psu_handle = connect!("ASRL4::INSTR")
fgen_handle = connect!("ASRL5::INSTR")
scope_handle = connect!("USB0::0x0699::0x0364::C057729::INSTR")
relays_handle = connect!("ASRL7::INSTR")

dmm = TIVM.GDM8246(dmm_handle);
psu = TIVM.PST3201(psu_handle);
fgen = TIVM.GFG3015(fgen_handle);
scope = TIVM.TDS2002B(scope_handle);
relays = TIVM.Relays(relays_handle);

# warmup
try
	@info query(psu_handle, "*IDN?")
	@info query(dmm_handle, "*IDN?")
	@info query(fgen_handle, "*IDN?")
	@info query(scope_handle, "*IDN?")
catch
	@info query(psu_handle, "*IDN?")
	@info query(dmm_handle, "*IDN?")
	@info query(fgen_handle, "*IDN?")
	@info query(scope_handle, "*IDN?")
end

# START gui
@async start_gui(psu = psu, dmm = dmm, fgen = fgen, 
        scope = scope, relays=relays)

# disconnect
#disconnect!(dmm_handle)
#disconnect!(psu_handle)
#disconnect!(fgen_handle)
#disconnect!(scope_handle)
#disconnect!(relays_handle)

```

Lab scripts in "test" folder
