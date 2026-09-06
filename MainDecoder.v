module MainDecoder(
    input [6:0] op,
    output reg MemWrite, ALUSrc, RegWrite, Branch,Jump, Jalr,
    output reg [1:0] ImmSrc, ALUOp,ResultSrc
);

    always @(*)
    begin
        case(op)
            7'b0000011: {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, Jalr} = 12'b1001_0010_0000;
            7'b0100011: {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, Jalr} = 12'b0011_1xx0_0000;
            7'b0110011: {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, Jalr} = 12'b1xx0_0000_1000;
            7'b1100011: {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, Jalr} = 12'b0100_0xx1_0100;
            7'b0010011: {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, Jalr} = 12'b1001_0000_1000;
            7'b1101111: {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, Jalr} = 12'b111x_0100_xx10;
            7'b1100111: {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, Jalr} = 12'b1001_x100_0001;
            default: {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump} = 11'b0000_0000_000;
        endcase
    end

endmodule