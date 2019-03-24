module Simptel-O9(CLOCK_50)


module control_unit(.opCode(), 
			  .clk(CLOCK_50), .reset(0),
                          .ALUOp(), 
                          PCWriteCond, ALUSrcB, PCSource,
                          PCWrite, IorD, MemRead, MemWrite, MemtoReg, IRWrite, ALUSrcA, RegWrite, RegDst);
    
  
  datapath dpath(
	.PCWriteCond(),
	.PCWrite(),
	.IorD,
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

endmodule 



