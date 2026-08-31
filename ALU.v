module ALU #(parameter WIDTH = 32)(
    input [WIDTH-1:0] in0, in1,
    input [2:0] op,
    output Zero,
    output reg [WIDTH-1:0] Result
);

    assign Zero = (Result == 32'b0);

    always @(*)
    begin
        case(op)
            3'b000: Result = in0 + in1;
            3'b001: Result = in0 - in1;
            3'b010: Result = in0 & in1;
            3'b011: Result = in0 | in1;
            3'b101: Result = in0 < in1;
            default: Result = 32'b0;
        endcase
    end
    
endmodule