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
	reset,
	opCode,
	HEX0,
	HEX1,
	HEX2,
	HEX3
);


	input PCWriteCond, PCWrite, IorD, MemRead, MemWrite, MemtoReg, IRWrite, ALUOp, ALUSrcA, RegWrite, RegDst, clk, reset;
	input [1:0] PCSource, ALUSrcB;
	
	output [5:0] opCode;
	output [6:0] HEX0, HEX1, HEX2, HEX3;
	
	wire [31:0] ALU_Out_Reg;
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
 	
	hex_decoder H0(
		.hex_digit(A[3:0]),
		.segments(HEX0)
	);
	
	hex_decoder H1(
		.hex_digit(A[7:4]),
		.segments(HEX1)
	);
	
	hex_decoder H02(
		.hex_digit(A[11:8]),
		.segments(HEX2)
	);
	
	hex_decoder H3(
		.hex_digit(A[15:12]),
		.segments(HEX3)
	);
	
	three_to_one_mux mux_F(
		.sel(PCSource[1:0]),
		.in_0(ALU_Out_Bus[31:0]), // something weird here
		.in_1(ALU_Out_Reg[31:0]),
		.in_2(sign_extend_B_out[31:0]),
		.q(mux_F_out)
	);
	
	ProgramCounter program_counter(
		.reset(reset),
		.clk(clk),
		.PC_in(mux_F_out[31:0]),
		.PC_out(PC_Out_Bus[31:0]),
		.enable(my_or_out)
	);
	
	two_to_one_mux mux_A(
		.sel(IorD),
		.in_0(PC_Out_Bus[31:0]),
		.in_1(ALU_Out_Bus[31:0]),
		.q(mux_A_out[31:0])
	);
	
	RAMO9 Memory(
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
		.in_0(ALU_Out_Bus[31:0]),
		.in_1(mem_out[31:0]),
		.q(mux_C_out[31:0]),
		.sel(MemtoReg)
	);
	
	SignExtend sign_extend_A(
		.to_extend(instruc0_bus[15:0]),
		.extended(sign_extend_out[31:0])
	);
	
	SignExtend_26_bit sign_extend_B(
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
		.in_1(32'b00000000000000000000000000000001),
		.in_2(sign_extend_out[31:0]),
		.in_3(shift_left_out[31:0]),
		.sel(ALUSrcB[1:0]),
		.q(mux_E_out[31:0])
	);
	
	ShiftLeft shift_left_2_A(
		.to_shift(sign_extend_out[31:0]),
		.shifted(shift_left_out[31:0])
	);
	
	ALU_Decoder alu_decoder(
		.Function_code(instruc0_bus[5:0]),
		.ALU_optcode(ALUOp),
		.ALU_control(alu_decoder_out[3:0])
	);
	
	ALU alu(
		.clk(clk),
		.src_A(mux_D_out[31:0]),
		.src_B(mux_E_out[31:0]),
		.ALU_control(alu_decoder_out[3:0]), // be careful here. how to resolve conflict with ALUOp?
		.zero(zero),
		.ALU_result(ALU_Out_Bus[31:0]) // not using a separate register here
	);
	
	ALU_Register alu_register(
		.in(ALU_Out_Bus[31:0]),
		.clk(clk),
		.out(ALU_Out_Reg[31:0])
	);
	
	And_ my_and(
		.in_0(zero),
		.in_1(PCWriteCond),
		.q(my_and_out)
	);
	
	Or_ my_or(
		.in_0(my_and_out),
		.in_1(PCWrite),
		.q(my_or_out)
	);

endmodule

module And_(in_0, in_1, q);
	input in_0, in_1;
	output q;
	
	assign q = in_0 & in_1;
endmodule

module Or_(in_0, in_1, q);
	input in_0, in_1;
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
	output reg [4:0] q;
	
	always @(in_0 or in_1 or sel)
		if (sel == 1'b0)
			q = in_0;
		else
			q = in_1;

endmodule

module four_to_one_mux(in_0, in_1, in_2, in_3, q, sel);
	input [31:0] in_0, in_1, in_2, in_3;
	input [1:0] sel;
	output reg [31:0] q;
	
	always @(in_0 or in_1 or in_2 or in_3 or sel)
		begin
			if (sel == 2'b00)
				q = in_0;
			else if (sel == 2'b01)
				q = in_1;
			else if (sel == 2'b10)
				q = in_2;
			else
				q = in_3;
		end
	
endmodule

module ALU_Register(in, out, clk);
	input [31:0] in;
	input clk;
	output reg [31:0] out;
	
	always @(posedge clk)
		out <= in[31:0];
	
endmodule

module hex_decoder(hex_digit, segments);
    input [3:0] hex_digit;
    output reg [6:0] segments;
   
    always @(*)
        case (hex_digit)
            4'h0: segments = 7'b100_0000;
            4'h1: segments = 7'b111_1001;
            4'h2: segments = 7'b010_0100;
            4'h3: segments = 7'b011_0000;
            4'h4: segments = 7'b001_1001;
            4'h5: segments = 7'b001_0010;
            4'h6: segments = 7'b000_0010;
            4'h7: segments = 7'b111_1000;
            4'h8: segments = 7'b000_0000;
            4'h9: segments = 7'b001_1000;
            4'hA: segments = 7'b000_1000;
            4'hB: segments = 7'b000_0011;
            4'hC: segments = 7'b100_0110;
            4'hD: segments = 7'b010_0001;
            4'hE: segments = 7'b000_0110;
            4'hF: segments = 7'b000_1110;   
            default: segments = 7'h7f;
        endcase
endmodule
