module SimptelO9(CLOCK_50);
  input CLOCK_50;
  
  wire [5:0] opCode;
  wire PCWriteCond, ALUOp, IorD, MemWrite, MemtoReg, IRWrite, ALUSrcA, RegWrite, RegDst, PCWrite;
  wire [1:0] ALUSrcB, PCSource;
  
 wire reset;
 wire memread;

  control_unit cunit(.opCode(opCode[5:0]), 
			  .clk(CLOCK_50), .reset(reset),
                          .ALUOp(ALUOp), 
                          .PCWriteCond(PCWriteCond), .ALUSrcB(ALUSrcB[1:0]), .PCSource(PCSource),
                          .PCWrite(PCWrite), .IorD(IorD), .MemWrite(MemWrite), .MemtoReg(MemtoReg), 
                          .IRWrite(IRWrite), .ALUSrcA(ALUSrcA), .RegWrite(RegWrite), .RegDst(RegDst));
    
  
  datapath dpath(
	.PCWriteCond(PCWriteCond),
	.PCWrite(PCWrite),
	.IorD(IorD),
	.MemRead(memread),
	.MemWrite(MemWrite),
	.MemtoReg(MemtoReg),
	.IRWrite(IRWrite),
	.PCSource(PCSource[1:0]),
	.ALUOp(ALUOp),
	.ALUSrcB(ALUSrcB[1:0]),
	.ALUSrcA(ALUSrcA),
	.RegWrite(RegWrite),
	.RegDst(RegDst),
	.clk(CLOCK_50),
	.reset(reset),
  .opCode(opCode[5:0])
);

endmodule 


