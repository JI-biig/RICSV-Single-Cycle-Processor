module RegFile(
    input clk,
    input [4:0] A1, A2, A3,
    input [31:0] WD3,
    input WE3,
    output [31:0] RD1, RD2
);
    reg [31:0] RF [31:0];

    always @(posedge clk)
    begin   
        if(WE3)
            RF[A3] <= WD3;
    end

    // X0 is hardwired to Zero
    assign RD1 = (A1)? RF[A1]: 32'b0;
    assign RD2 = (A2)? RF[A2]: 32'b0;



endmodule