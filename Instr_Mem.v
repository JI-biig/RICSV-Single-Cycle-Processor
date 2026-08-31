module Instr_MEM #(parameter WIDTH = 32)
(
    input [WIDTH-1:0] Address,
    output [WIDTH-1:0] Instruction
);

    reg [31:0] Mem [31:0];

    initial begin
        $readmemh("", Mem);
    end


    assign Instruction = Mem[Address[31:2]]; // [31:2] not => [31:0] Because of the Byte-Addressable Nature of RISC-V Architecture
                                            //  That Allow Us Accessing {Mem[0]->Mem[1]-> ..} rather than {Mem[0] -> Mem[4] -> ..}
    
endmodule