module rff #(parameter WIDTH = 32)(
    input [WIDTH-1:0] in,
    input clk,rst,
    output reg [WIDTH-1:0] out
);

always @(posedge clk)
    begin
        if(rst)
            out <= 32'b0;
        else
            out <= in;
    end

endmodule