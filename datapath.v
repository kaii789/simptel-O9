module datapath(
	PCWriteCond,
	PCWrite,
	IorD,
	MemRead,
	MemWrite,
	MemtoReg,
	IRWrite,
	PCSource,
	ALUOp,
	ALUSrcB,
	ALUSrcA,
	RegWrite,
	RegDst,
	clk,
	reset
);


	input PCWriteCond, PCWrite, IorD, MemRead, MemWrite, MemtoReg, IRWrite, ALUOp, ALUSrcA, RegWrite, RegDst, clk, reset;
	input [1:0] PCSource;
	input [2:0] ALUSrcB;
	output [5:0] opCode;
	
	wire [31:0] ALU_Out_Bus;
	wire [31:0] instr_shifted;
	wire [31:0] mux_F_out;
	wire [31:0] PC_Out_Bus;
	wire [31:0] mux_A_out;
	wire [31:0] B_reg_out;
	wire [31:0] mem_out;
	//	wire [6:0] instruc3_bus; this is actually just opCode
	wire [4:0] instruc2_bus;
	wire [4:0] instruc1_bus;
	wire [15:0] instruc0_bus;
	wire [31:0] mux_C_out;
	wire [4:0] mux_B_out;
	wire [31:0] sign_extend_out;
	wire [31:0] sign_extend_B_out;
	wire [31:0] A;
	wire [31:0] B;
	wire [31:0] mux_D_out;
	wire [31:0] shift_left_out;
	wire [31:0] mux_E_out;
	wire zero;
	wire my_and_out;
	wire my_or_out;
	wire [3:0] alu_decoder_out;
 	
	three_to_one_mux mux_F(
		.sel(PCSource[1:0]),
		.in_0(ALU_Out_Bus[31:0]), // something weird here
		.in_1(ALU_Out_Bus[31:0]),
		.in_2(instr_shifted[31:0]),
		.q(mux_F_out)
	);
	
	ProgramCounter program_counter(
		.reset(reset),
		.clk(clk),
		.PC_in(mux_F_out[31:0]),
		.PC_out(PC_Out_Bus[31:0]),
		.enable(my_or_out)
	);
	
	two_two_one_mux mux_A(
		.sel(IorD),
		.in_0(PC_Out_Bus[31:0]),
		.in_1(ALU_Out_Bus[31:0]),
		.q(mux_A_out[31:0])
	);
	
	ram65536x32 Memory(
		.address(mux_A_out[15:0]),
		.clock(clk),
		.data(B[31:0]),
		.wren(MemWrite),
		.q(mem_out[31:0])
	);
	
	Instruction_Register IR(
		.memory_data(mem_out),
		.clk(clk),
		.instruc3(opCode[5:0]),
		.instruc2(instruc2_bus[4:0]),
		.instruc1(instruc1_bus[4:0]),
		.instruc0(instruc0_bus[15:0]),
		.IRWrite(IRWrite)
	);
	
	two_to_one_mux_5_bit mux_B(
		.in_0(instruc1_bus[4:0]),
		.in_1(instruc0_bus[15:11]), // take the most significant bits of this bus
		.sel(RegDst),
		.q(mux_B_out[4:0])
	);
	
	Registers register(
		.clk(clk),
		.reset(reset),
		.write_reg(mux_B_out[4:0]),
		.write_data(mux_C_out[31:0]),
		.read_reg1(instruc2_bus[4:0]),
		.read_reg2(instruc1_bus[4:0]),
		.RegWrite(RegWrite),
		.read_data1(A[31:0]),
		.read_data2(B[31:0])
	);
	
	two_to_one_mux mux_C(
		.in_0(ALU_out_bus[31:0]),
		.in_1(mem_out[31:0]),
		.q(mux_C_outp[31:0]),
		.sel(MemtoReg)
	);
	
	SignExtend sign_extend_A(
		.to_extend(instruc0_bus[15:0]),
		.extended(sign_extend_out[31:0])
	);
	
	SignExtend sign_extend_B(
		.to_extend({instruc2_bus[4:0], instruc1_bus[4:0], instruc0_bus[15:0]}),
		.extended(sign_extend_B_out[31:0])
	);
	
	ShiftLeft shift_left_2_B(
		.to_shift(sign_extend_B_out[31:0]),
		.shifted(instr_shifted[31:0])
	);
	
	two_to_one_mux mux_D(
		.in_0(PC_Out_Bus[31:0]),
		.in_1(A[31:0]),
		.q(mux_D_out[31:0]),
		.sel(ALUSrcA)
	);
	
	four_to_one_mux mux_E(
		.in_0(B[31:0]),
		.in_1(32'b00000000000000000000000000000100),
		.in_2(sign_extend_out[31:0]),
		.in_3(shift_left_out[31:0]),
		.sel(ALUSrcB),
	);
	
	ShiftLeft shift_left_2_A(
		.to_shift(sign_extend_out[31:0]),
		.shifted(shift_left_out[31:0])
	);
	
	ALU_Decoder alu_decoder(
		.ALU_optcode(instruc0_bus[5:0]),
		.ALU_control(alu_decoder_out[3:0]),
	);
	
	ALU alu(
		.clk(clk),
		.srcA(mux_D_out[31:0]),
		.srcB(mux_E_out[31:0]),
		.ALU_control(alu_decoder_out[3:0]), // be careful here. how to resolve conflict with ALUOp?
		.zero(zero),
		.ALU_result(ALU_Out_Bus[31:0]) // not using a separate register here
	);
	
	And my_and(
		.in_0(zero),
		.in_1(PCWriteCond),
		.q(my_and_out)
	);
	
	Or my_or(
		.in_1(my_and_out),
		.in_1(PCWrite),
		.q(my_or_out)
	);

endmodule

module And(in_0, in_1, q);
	input in_0, in_1;
	output q;
	
	assign q = in_0 & in_1;
endmodule

module Or(in_0, in_1, q);
	input in_0, in_1, q;
	output q;
	
	assign q = in_0 | in_1;
endmodule

module two_to_one_mux(in_0, in_1, sel, q);
	input [31:0] in_0, in_1;
	input sel;
	output [31:0] q;
	reg [31:0] q;
	
	always @(in_0 or in_1 or sel)
		if (sel == 1'b0)
			q = in_0;
		else
			q = in_1;
		
endmodule

module three_to_one_mux(in_0, in_1, in_2, sel, q);
	input [31:0] in_0, in_1, in_2;
	input [1:0] sel;
	output [31:0] q;
	reg [31:0] q;
	
	always @(in_0 or in_1 or in_2 or sel)
		if (sel == 2'b00)
			q = in_0;
		else if (sel == 2'b01)
			q = in_1;
		else
			q = in_2;
		
endmodule

module two_to_one_mux_5_bit(in_0, in_1, q, sel);
	input [4:0] in_0, in_1;
	input sel;
	output [4:0] q;
	
	always @(in_0 or in_1 or sel)
		if (sel == 1'b0)
			q = in_0;
		else
			q = in_1;

endmodule

module four_to_one_mux(in_0, in_1, in_2, in_3, q, sel);
	input [31:0] in_0, in_1, in_2, in_3;
	input [1:0] sel;
	output [31:0] q;
	
	always @(in_0 or in_1 or in_2 or in_3 or sel)
		if (sel == 2'b00)
			q = in_0
		else if (sel == 2'b01)
			q = in_1
		else if (sel == 2'b10)
			q = in_2
		else
			q = in_3
	
endmodule
