module ControlUnit(
    input [31:0] Instr,
    input Zero,
    output PCSrc, MemWrite, ALUSrc, RegWrite,
    output [2:0] ALUControl,
    output [1:0] ImmSrc, ResultSrc
);
    wire Branch;
    wire [1:0] ALUOp;
    wire Jump;

    MainDecoder Decoder_Main (
        .op(Instr[6:0]),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .Branch(Branch),
        .ImmSrc(ImmSrc),
        .ALUOp(ALUOp),
        .Jump(Jump)
    );

    ALUDecoder ALU (
        .op_5(Instr[5]),
        .funct3(Instr[14:12]),
        .funct7_5(Instr[30]),
        .ALUOp(ALUOp),
        .ALUControl(ALUControl)
    );

    assign PCSrc = (Branch & Zero) | Jump;

endmodule