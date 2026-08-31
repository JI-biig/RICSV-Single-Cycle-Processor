module SingleCycle(
    input clk,rst,
    input [31:0] Instr,
    input [31:0] ReadData,
    output MemWrite,
    output [31:0] ALUResult, WriteData,
    output [31:0] PC
);
    wire PCSrc, ResultSrc, ALUSrc, RegWrite, ALUControl, ImmSrc,
         Zero;

    Datapath Data(
        .PCSrc(PCSrc),
        .ResultSrc(ResultSrc),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .ALUControl(ALUControl),
        .ImmSrc(ImmSrc),
        .Instr(Instr),
        .clk(clk), .rst(rst),
        .PC(PC),
        .Zero(Zero),
        .ALUResult(ALUResult),
        .WriteData(WriteData),
        .ReadData(ReadData)
    );

    ControlUnit Control(
        .Instr(Instr),
        .Zero(Zero),
        .PCSrc(PCSrc),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .ALUControl(ALUControl),
        .ImmSrc(ImmSrc)
    );
    
endmodule