module adder #(parameter WIDTH=32)(
    input [WIDTH-1:0] in0, in1,
    output [WIDTH-1:0] sum
);


assign sum = in0 + in1;
    
endmodule