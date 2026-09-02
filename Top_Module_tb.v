`timescale 1ns/1ps

module Top_Module_tb();
    reg clk,rst;
    wire [31:0] WriteData, Addr;
    wire MemWrite;

    Top_Module DUT(
        .clk(clk),
        .rst(rst),
        .WriteData(WriteData),
        .Addr(Addr),
        .MemWrite(MemWrite)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    // Reset sequence
    initial begin
        rst = 1;
        #20
        rst = 0;
    end

initial begin
    $dumpfile("simulation_dump.vcd");
    $dumpvars(0, Top_Module_tb);
end

    // Checking logic
    always @(negedge clk)
    begin
        if(MemWrite) begin
            // Changed & to && for logical comparison
            if(Addr === 100 && WriteData === 25) 
            begin
                $display("Simulation succeeded");
                $finish; // Use $finish to completely exit
            end 
            else if (Addr !== 96) 
            begin
                $display("Simulation failed: Wrote to unexpected address %d", Addr);
                $finish;
            end
        end
    end

endmodule