module SingleCycle(
    input clk,rst,
    input [31:0] Instr,
    input [31:0] ReadData,
    output MemWrite,
    output [31:0] ALUResult, WriteData,
    output [31:0] PC
);
    wire ALUSrcB, ALUSrcA, RegWrite, Zero, bge_flag; 
    wire [2:0] ALUControl, ImmSrc;
    wire [1:0] ResultSrc, PCSrc;

    Datapath Data(
        .PCSrc(PCSrc),
        .ResultSrc(ResultSrc),
        .ALUSrcB(ALUSrcB),
        .ALUSrcA(ALUSrcA),
        .RegWrite(RegWrite),
        .ALUControl(ALUControl),
        .ImmSrc(ImmSrc),
        .Instr(Instr),
        .clk(clk), .rst(rst),
        .PC(PC),
        .Zero(Zero),
        .bge_flag(bge_flag),
        .ALUResult(ALUResult),
        .WriteData(WriteData),
        .ReadData(ReadData)
    );

    ControlUnit Control(
        .Instr(Instr),
        .Zero(Zero),
        .bge_flag(bge_flag),
        .PCSrc(PCSrc),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUSrcB(ALUSrcB),
        .ALUSrcA(ALUSrcA),
        .RegWrite(RegWrite),
        .ALUControl(ALUControl),
        .ImmSrc(ImmSrc)
    );
    
endmodule