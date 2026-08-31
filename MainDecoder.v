module MainDecoder(
    input [6:0] op,
    output reg ResultSrc, MemWrite, ALUSrc, RegWrite, Branch,
    output reg [1:0] ImmSrc, ALUOp
);

    always @(*)
    begin
        case(op)
            7'b0000011: {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp} = 9'b1001_0100_0;
            7'b0100011: {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp} = 9'b0011_1x00_0;
            7'b0110011: {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp} = 9'b1xx0_0001_0;
            7'b1100011: {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp} = 9'b0100_0x10_1;
            default: {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp} = 9'bxxxx_xxxx_x;
        endcase
    end

endmodule