# TIVM

]add https://github.com/iuliancioarca/TIVM.git

```
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
@async TIVM.start_gui(psu)

# disconnect
# disconnect!(psu)

```