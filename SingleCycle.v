module SingleCycle(
    input clk,rst,
    input [31:0] Instr,
    input [31:0] ReadData,
    output [31:0] ALUResult, WriteData
);
    wire PCSrc, ResultSrc, ALUSrc, RegWrite, ALUControl, ImmSrc,
         Zero;
    wire [31:0] PC;

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