module SingleCycle(
    input clk,rst,
    input [31:0] Instr,
    input [31:0] ReadData,
    output MemWrite,
    output [31:0] ALUResult, WriteData,
    output [31:0] PC
);
    wire PCSrc, ALUSrc, RegWrite, Zero, bge_flag; 
    wire [2:0] ALUControl;
    wire [1:0] ImmSrc, ResultSrc;

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
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .ALUControl(ALUControl),
        .ImmSrc(ImmSrc)
    );
    
endmodule