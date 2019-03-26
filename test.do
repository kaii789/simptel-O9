vlib work

vlog -timescale 1ns/1ns SimptelO9.v datapath.v ALU.v ALU_Decoder.v ProgramCounter.v RAMO9(4KB).v ShiftLeft.v SignExtend.v control_unit.v datapath_registers.v

vsim SimptelO9

#log {/*}
log * -r
#add wave {/*}
add wave -recursive -depth 10 * 

force {CLOCK_50} 0 0, 1 5 -r 10
# A
# force {go} 0 0, 1 10

run 400ns
