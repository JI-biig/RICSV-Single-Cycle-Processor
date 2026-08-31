module ALUDecoder(
    input op_5,
    input [2:0] funct3,
    input funct7_5,
    input [1:0] ALUOp,
    output reg [2:0] ALUControl
);

    always @(*)
    begin
        casex({ALUOp,funct3,op_5,funct7_5})
            7'b00xxxxx: ALUControl = 3'b000; // ADD
            7'b01xxxxx: ALUControl = 3'b001; // Subtract
            7'b1000011: ALUControl = 3'b001; // Subtract  => Exeption Case First
            7'b10000xx: ALUControl = 3'b000; // ADD
            7'b10010xx: ALUControl = 3'b101; // Set less than
            7'b10110xx: ALUControl = 3'b011; // or
            7'b10111xx: ALUControl = 3'b010; // and
            default: ALUControl = 3'b000;
        endcase
    end

endmodule