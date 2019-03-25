module SimptelO9(CLOCK_50);
  input CLOCK_50;
  
  wire opCode, ALUOp, PCWriteCond, PCWrite, IorD, MemWrite, MemtoReg, IRWrite, ALUSrcA, RegWrite, RegDst;
  wire [1:0] ALUSrcB, PCSource;
  
  control_unit cunit(.opCode(opCode), 
			  .clk(CLOCK_50), .reset(0),
                          .ALUOp(ALUOp), 
                          .PCWriteCond(PCWriteCond), .ALUSrcB(ALUSrcB[1:0]), .PCSource(PCSource),
                          .PCWrite(PCWrite), .IorD(IorD), .MemWrite(MemWrite), .MemtoReg(MemtoReg), 
                          .IRWrite(IRWrite), .ALUSrcA(ALUSrcA), .RegWrite(RegWrite), .RegDst(RegDst));
    
  
  datapath dpath(
	.PCWriteCond(PCWriteCond),
	.PCWrite(PCWrite),
	.IorD(IorD),
	.MemRead(0),
	.MemWrite(MemWrite),
	.MemtoReg(MemtoReg),
	.IRWrite(IRWrite),
	.PCSource(PCSource),
	.ALUOp(ALUOp),
	.ALUSrcB(ALUSrcB[1:0]),
	.ALUSrcA(ALUSrcA),
	.RegWrite(RegWrite),
	.RegDst(RegDst),
	.clk(CLOCK_50),
	.reset(0),
  .opCode(opCode)
);

endmodule 



