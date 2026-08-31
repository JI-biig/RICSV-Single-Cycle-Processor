module Datapath(
    input PCSrc, ResultSrc, ALUSrc, RegWrite,
    input [2:0] ALUControl,
    input [1:0] ImmSrc,
    input [31:0] Instr,
    input clk,rst,
    output [31:0] PC,
    output Zero,
    output [31:0] ALUResult,
    output [31:0] WriteData,
    input [31:0] ReadData
);
    wire [31:0] PCNext, PCPlus4, ImmExt,PCTarget, Result, SrcA;

    // PC Next 
    rff PC_Next (
        .clk(clk),
        .rst(rst),
        .in(PCNext),
        .out(PC)
    );
    adder PC_Plus4 (
        .in0(PC),
        .in1(3'b100),
        .sum(PCPlus4)
    );  
    adder PC_Target(
        .in0(PC),
        .in1(ImmExt),
        .sum(PCTarget)
    );
    Mux2_1 pcmux(
        .in0(PCPlus4),
        .in1(PCTarget),
        .sel(PCSrc),
        .sum(PCNext)
    );

    // Register file
    Regfile regf(
        .clk(clk),
        .A1(Instr[19:15]),
        .A2(Instr[24:20]),
        .A3(Instr[11:7]),
        .WE3(RegWrite),
        .WD3(Result),
        .RD1(SrcA),
        .RD2(WriteData)
    );
    Extender Ext(
        .in(Instr[31:7]),
        .sel_extend(ImmSrc),
        .out_Extend(ImmExt)
    );

    // ALU 
    ALU alu (
        .in0(SrcA), 
        .in1(SrcB),
        .op(ALUControl),
        .Zero(Zero),
        .Result(ALUResult)
    );
    Mux2_1 addMux(
        .in0(WriteData),
        .in1(ImmExt),
        .sel(ALUSrc),
        .out(SrcB)
    );
    Mux2_1 datamux(
        .in0(ALUResult),
        .in1(ReadData),
        .sel(ResultSrc),
        .out(Result)
    );
    
endmodule