module Extender(
    input [24:0] in,
    input [2:0] sel_extend,
    output reg [31:0] out_Extend
);

always @(*) begin
    case (sel_extend)
        2'b000: out_Extend = {{20{in[24]}}, in[24:13]}; // I-type Instruction
        2'b001: out_Extend = {{20{in[24]}}, in[24:18], in[4:0]}; // S-type Instruction
        2'b010: out_Extend = {{19{in[24]}}, in[24], in[0], in[23:18], in[4:1], 1'b0}; // B-type
        2'b011: out_Extend = {{12{in[24]}}, in[12:5], in[13], in[23:14], 1'b0}; // J-Type
        3'b100: out_Extend = {in[24:5], 12'b0}; // U-Type
    endcase
end

endmodule