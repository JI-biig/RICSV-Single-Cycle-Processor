module ALU #(parameter WIDTH = 32)(
    input [WIDTH-1:0] in0, in1,
    input [2:0] op,
    output Zero, bge_flag,
    output reg [WIDTH-1:0] Result
);

    assign Zero = (Result == 32'b0);
    assign bge_flag = Result[0];

    always @(*)
    begin
        case(op)
            3'b000: Result = in0 + in1;
            3'b001: Result = in0 - in1;
            3'b010: Result = in0 & in1;
            3'b011: Result = in0 | in1;
            // slt instruction in RISCV Architecture is a comparision between signed numbers
            3'b100: Result = ($signed(in0) < $signed(in1))? 32'b1: 32'b0; 
            3'b101: Result = in0 << in1[4:0];
            3'b110: Result = in0 >> in1[4:0];
            3'b111: Result = $signed(in0) >>> in1[4:0];
        endcase
    end
    
endmodule