# Simptel-O9

A simple single-cycle processor capable of taking in Assembly/Machine Code instructions. 

# Milestones
Milestone 1:
Implement the microprocessor design with Verilog (datapath and control unit). At this point, we will not have a working RAM module, so the instructions will be simple commands that will not require external storage (e.g. add, subtract, mult, div). We will use ModelSim to simulate instructions in machine code, and show the output.

Milestone 2:
Use Quartus to generate a RAM module. Add support for the control unit for opcodes that require use of memory(e.g, jump, variable assignment).  Connect RAM with the rest of processor, so that we can hard code instructions onto RAM and test with the FPGA. 

Milestone 3:
Add fibonacci value displayer, distance between two points calculator, and finite geometric series calculator as a default programs we can use to demonstrate. 
