module ControlUnit(
    input [31:0] Instr,
    input Zero, bge_flag,
    output MemWrite, ALUSrc, RegWrite,
    output [2:0] ALUControl,
    output [1:0] ImmSrc, ResultSrc, PCSrc
);
    wire Branch;
    wire [1:0] ALUOp;
    wire Jump,Jalr;
    wire ltflag, branchflag, BranchTaken;

    MainDecoder Decoder_Main (
        .op(Instr[6:0]),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .Branch(Branch),
        .ImmSrc(ImmSrc),
        .ALUOp(ALUOp),
        .Jump(Jump),
        .Jalr(Jalr)
    );

    ALUDecoder ALU (
        .op_5(Instr[5]),
        .funct3(Instr[14:12]),
        .funct7_5(Instr[30]),
        .ALUOp(ALUOp),
        .ALUControl(ALUControl)
    );

    // assign PCSrc = (Branch & Zero) | Jump;
    assign ltflag = bge_flag;
    assign branchflag = Instr[14]? ltflag: Zero;
    assign BranchTaken = Branch & (branchflag ^ Instr[12]);
    assign PCSrc[0] = BranchTaken | Jump ;
    assign PCSrc[1] = Jalr;

endmodule