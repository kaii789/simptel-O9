module Instruction_Register(clk, memory_data, IRWrite, instruc3, instruc2, instruc1, instruc0);
	input clk;
	input [31:0] memory_data;
	input IRWrite;
	output reg [5:0] instruc3;
	output reg [4:0] instruc2, instruc1;
	output reg [15:0] instruc0;
	
	always @(posedge clk);
		begin
			if (IRWrite) begin
				instruc3 <= memory_data[31:26];
				instruc2 <= memory_data[25:21];
				instruc1 <= memory_data[20:16];
				instruc0 <= memory_data[15:0];
				end
		end
	

endmodule


module Registers(clk, reset, RegWrite, read_reg1, read_reg2, write_reg, write_data, read_data1, read_data2);
	input clk, reset, RegWrite;
	input [4:0] read_reg1, read_reg2, write_reg;
	input [31:0] write_data;
	output [31:0] read_data1, read_data2;
		
	reg [31:0] registers[31:0]; // we 32 registers, each able to hold 4 bytes
	
	always @(posedge clk, posedge reset);
		begin 
			if (reset) 
				begin 
					registers[0] <= 32'b000000000000000000000000000000000000;
					registers[1] <= 32'b000000000000000000000000000000000000;
					registers[2] <= 32'b000000000000000000000000000000000000;
					registers[3] <= 32'b000000000000000000000000000000000000;
					registers[4] <= 32'b000000000000000000000000000000000000;
					registers[5] <= 32'b000000000000000000000000000000000000;
					registers[6] <= 32'b000000000000000000000000000000000000;
					registers[7] <= 32'b000000000000000000000000000000000000;
					registers[8] <= 32'b000000000000000000000000000000000000;
					registers[9] <= 32'b000000000000000000000000000000000000;
					registers[10] <= 32'b000000000000000000000000000000000000;
					registers[11] <= 32'b000000000000000000000000000000000000;
					registers[12] <= 32'b000000000000000000000000000000000000;
					registers[13] <= 32'b000000000000000000000000000000000000;
					registers[14] <= 32'b000000000000000000000000000000000000;
					registers[15] <= 32'b000000000000000000000000000000000000;
					registers[16] <= 32'b000000000000000000000000000000000000;
					registers[17] <= 32'b000000000000000000000000000000000000;
					registers[18] <= 32'b000000000000000000000000000000000000;
					registers[19] <= 32'b000000000000000000000000000000000000;
					registers[20] <= 32'b000000000000000000000000000000000000;
					registers[21] <= 32'b000000000000000000000000000000000000;
					registers[22] <= 32'b000000000000000000000000000000000000;
					registers[23] <= 32'b000000000000000000000000000000000000;
					registers[24] <= 32'b000000000000000000000000000000000000;
					registers[25] <= 32'b000000000000000000000000000000000000;
					registers[26] <= 32'b000000000000000000000000000000000000;
					registers[27] <= 32'b000000000000000000000000000000000000;
					registers[28] <= 32'b000000000000000000000000000000000000;
					registers[29] <= 32'b000000000000000000000000000000000000;
					registers[30] <= 32'b000000000000000000000000000000000000;
					registers[31] <= 32'b000000000000000000000000000000000000;
				end
			else if (RegWrite) 
				begin 
					registers[write_reg] = write_data;
				end
		end
		
		assign read_data1 = registers[read_reg1];
		assign read_data2 = registers[read_reg2];
		
endmodule

// Instruction_Register