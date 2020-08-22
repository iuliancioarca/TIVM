# cd(raw"C:\Users\HP\Desktop\TIVM_Julia_setup\2019_Julia_TIVM_lab_demo")
# load libraries
# using GenericInstruments
using TIVM
using Plots
gr()
# plotly()

# connect to DMM dmm, reset and clear errors
dmm = connect!("ASRL5::INSTR")
query(dmm, "*IDN?")
TIVM.write(dmm,"*RST");
TIVM.write(dmm,"*CLS");

# connect to power supply PST-3201, reset and clear errors
psu = connect!("ASRL14::INSTR")
try # first query to PSU is slow????
    query(psu, "*IDN?")
catch
    query(psu, "*IDN?")
end
TIVM.write(psu,"*RST");
TIVM.write(psu,"*CLS");

# START gui
@async TIVM.start_gui(psu, dmm, 1)

# configure power supply
TIVM.write(psu, ":CHAN1:VOLT 0;:CHAN2:VOLT 0;:CHAN3:VOLT 0"); #set ch voltages
TIVM.write(psu, ":CHAN1:PROT:VOLT 20;:CHAN2:PROT:VOLT 20;:CHAN3:PROT:VOLT 20"); #set OVP
TIVM.write(psu, ":CHAN1:CURR 0.5;:CHAN2:CURR 0.5;:CHAN3:CURR 0.5"); #set OCP
TIVM.write(psu, ":OUTPut:STATe 1"); #output on

# configure DMM
TIVM.write(dmm,":CONF:VOLT:DC 10"); #conf. voltage dc, 1V
sleep(3) # DMM is slow to recover from OL condition

# define constants, input and output parameters
volt_step = 0.1;
volt_range = volt_step:volt_step:3.0;
R = 47;
diode_volt = [];
diode_crt = [];
# voltage loop
for crt_volt in volt_range
    # set current voltage value on power supply
    TIVM.write(psu, ":CHAN1:VOLT "*string(crt_volt)*"");
    sleep(0.3);
    # read from dmm primary display
    volt_meas = parse(Float64, query(dmm, ":VALue?"));
    crt_meas = (crt_volt - volt_meas)/R
    # push measurements into results arrays
    push!(diode_volt, volt_meas)
    push!(diode_crt, crt_meas)
end
TIVM.write(psu, ":OUTPut:STATe 0"); # output off

# discard first point
# popfirst!(diode_volt)
# popfirst!(diode_crt)
# Graph
Plots.plot(diode_volt, diode_crt);
Plots.title!("Caracteristica IAK(VAK)");
Plots.xlabel!("Tensiune[V]");
Plots.ylabel!("Curent[A]");
gui()


# Disconnect all instruments
disconnect!(dmm)
disconnect!(psu)