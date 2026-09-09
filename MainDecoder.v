 MainDecoder(
    input [6:0] op,
    output reg MemWrite, ALUSrcB, ALUSrcA, RegWrite, Branch,Jump, Jalr,
    output reg [1:0] ALUOp,ResultSrc,
    output reg [2:0] ImmSrc
);

always @(*)
begin
    case(op)
        7'b0000011: {RegWrite, ImmSrc, ALUSrcB, ALUSrcA, MemWrite, ResultSrc, Branch, ALUOp, Jump, Jalr} = 14'b1000_1000_1000_00;
        7'b0100011: {RegWrite, ImmSrc, ALUSrcB, ALUSrcA, MemWrite, ResultSrc, Branch, ALUOp, Jump, Jalr} = 14'b0001_101x_x000_00;
        7'b0110011: {RegWrite, ImmSrc, ALUSrcB, ALUSrcA, MemWrite, ResultSrc, Branch, ALUOp, Jump, Jalr} = 14'b10xx_0000_0010_00;
        7'b1100011: {RegWrite, ImmSrc, ALUSrcB, ALUSrcA, MemWrite, ResultSrc, Branch, ALUOp, Jump, Jalr} = 14'b0010_000x_x101_00;
        7'b0010011: {RegWrite, ImmSrc, ALUSrcB, ALUSrcA, MemWrite, ResultSrc, Branch, ALUOp, Jump, Jalr} = 14'b1000_1000_0010_00;
        7'b1101111: {RegWrite, ImmSrc, ALUSrcB, ALUSrcA, MemWrite, ResultSrc, Branch, ALUOp, Jump, Jalr} = 14'b1011_x001_00xx_10;
        7'b1100111: {RegWrite, ImmSrc, ALUSrcB, ALUSrcA, MemWrite, ResultSrc, Branch, ALUOp, Jump, Jalr} = 14'b1000_10x1_0000_01;
        7'b0010111: {RegWrite, ImmSrc, ALUSrcB, ALUSrcA, MemWrite, ResultSrc, Branch, ALUOp, Jump, Jalr} = 14'b1100_1100_0000_00;
        default: {RegWrite, ImmSrc, ALUSrcB, ALUSrcA, MemWrite, ResultSrc, Branch, ALUOp, Jump} = 14'b0000_0000_0000_00;
    endcase
end
        
endmodule