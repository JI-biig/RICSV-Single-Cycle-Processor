module Mux3_1 #(parameter WIDTH = 32)
(
    input [WIDTH-1:0] in0, in1, in2,
    input [1:0] sel,
    output [WIDTH-1:0] out
);

assign out = (sel== 2'b00)? in0: (sel == 01)?in1:in2;

endmodule