module Data_MEM(
    input [31:0] A,
    input clk, WE,
    input [31:0] WD,
    output [31:0] RD
);
    reg [31:0] DataMEM [63:0];

    initial 
    begin
        $readmemh("", DataMEM);
    end

    always @(posedge clk)
    begin
        if(WE)
            DataMEM[A[7:2]] <= WD;
    end

    assign RD = DataMEM[A[7:2]];

endmodule