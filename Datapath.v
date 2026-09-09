module Datapath(
    input ALUSrcB, ALUSrcA, RegWrite,
    input [2:0] ALUControl, ImmSrc,
    input [1:0] ResultSrc, PCSrc,
    input [31:0] Instr,
    input clk,rst,
    output [31:0] PC,
    output Zero, bge_flag,
    output [31:0] ALUResult,
    output [31:0] WriteData,
    input [31:0] ReadData
);
    wire [31:0] PCNext, PCPlus4, ImmExt,PCTarget, Result, SrcA, SrcB, RD1_out;

    // PC Next 
    rff PC_Next (
        .clk(clk),
        .rst(rst),
        .in(PCNext),
        .out(PC)
    );
    adder PC_Plus4 (
        .in0(PC),
        .in1(32'd4),
        .sum(PCPlus4)
    );  
    adder PC_Target(
        .in0(PC),
        .in1(ImmExt),
        .sum(PCTarget)
    );
    Mux3_1 pcmux(
        .in0(PCPlus4),
        .in1(PCTarget),
        .in2({ALUResult[31:1], 1'b0}),  // (rs1 + imm) & ~1 => Clear LSB to 0
        .sel(PCSrc),
        .out(PCNext)
    );

    // Register file
    RegFile regf(
        .clk(clk),
        .A1(Instr[19:15]),
        .A2(Instr[24:20]),
        .A3(Instr[11:7]),
        .WE3(RegWrite),
        .WD3(Result),
        .RD1(RD1_out),
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
        .bge_flag(bge_flag),
        .Result(ALUResult)
    );

    Mux2_1 PC_RD1Mux (
        .in0(RD1_out),
        .in1(PC),
        .sel(ALUSrcA),
        .out(SrcA)
    );

    Mux2_1 addMux(
        .in0(WriteData),
        .in1(ImmExt),
        .sel(ALUSrcB),
        .out(SrcB)
    );
    Mux3_1 datamux(
        .in0(ALUResult),
        .in1(ReadData),
        .in2(PCPlus4),
        .sel(ResultSrc),
        .out(Result)
    );
    
endmodule