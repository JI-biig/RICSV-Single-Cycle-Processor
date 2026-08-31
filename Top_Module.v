module Top_Module(
    input clk, rst,
    output [31:0] WriteData, Addr,
    output MemWrite
);
    wire [31:0] ReadData, PC, Instr;
    
    SingleCycle singleC(
        .clk(clk), .rst(clk),
        .Instr(Instr),
        .ReadData(ReadData),
        .MemWrite(MemWrite),
        .ALUResult(Addr),
        .WriteData(WriteData),
        .PC(PC)
    );

    Data_MEM data(
        .A(Addr),
        .clk(clk),
        .WE(MemWrite),
        .WD(WriteData),
        .RD(ReadData)
    );

    Instr_MEM inst_MEM(
        .Address(PC),
        .Instruction(Instr)
    );

endmodule