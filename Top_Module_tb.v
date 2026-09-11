`timescale 1ns/1ps

module Top_Module_tb;

    reg clk;
    reg rst;

    wire [31:0] WriteData, Addr;
    wire        MemWrite;

    // Expected 10th Fibonacci number (a after 10 loop =55)
    localparam EXPECTED_RESULT = 32'd55;
    localparam RESULT_ADDR     = 32'd32;          // matches (int*)32 in fibonacci.c
    localparam RESULT_WORD_IDX = RESULT_ADDR >> 2; 

    integer cycle_count;
    integer i;
    reg [31:0] pc_prev;
    reg        halted;

    // ---------------------------------------------------------------
    // DUT
    // ---------------------------------------------------------------
    Top_Module dut (
        .clk(clk),
        .rst(rst),
        .WriteData(WriteData),
        .Addr(Addr),
        .MemWrite(MemWrite)
    );

    // ---------------------------------------------------------------
    // Clock: 10ns period
    // ---------------------------------------------------------------
    initial clk = 0;
    always #5 clk = ~clk;

    // ---------------------------------------------------------------
    // Waveform dump
    // ---------------------------------------------------------------
    initial begin
        $dumpfile("simulation.vcd");
        $dumpvars(0, Top_Module_tb);
    end

    // ---------------------------------------------------------------
    // Reset & run
    // ---------------------------------------------------------------
    initial begin
        rst = 1;
        cycle_count = 0;
        halted = 0;
        pc_prev = 32'hFFFF_FFFF;

        @(posedge clk);
        @(posedge clk);
        rst = 0;

        // Run until we detect the halt loop (jal x0,0 => PC stops changing)
        while (!halted && cycle_count < 500) begin
            @(posedge clk);
            cycle_count = cycle_count + 1;

            // dut.singleC.PC is the internal PC wire inside SingleCycle
            if (dut.singleC.PC == pc_prev && cycle_count > 5) begin
                halted = 1;
            end
            pc_prev = dut.singleC.PC;
        end

        $display("--------------------------------------------------");
        if (halted)
            $display("Halt loop detected after %0d cycles at PC=0x%08h",
                      cycle_count, dut.singleC.PC);
        else
            $display("WARNING: halt loop NOT detected within %0d cycles",
                      cycle_count);

        // Give the final store a moment to settle (should already be done)
        @(posedge clk);

        check_result();

        $display("--------------------------------------------------");
        $finish;
    end

    // ---------------------------------------------------------------
    // Result check: read directly from Data_MEM
    // ---------------------------------------------------------------
    task check_result;
        reg [31:0] got;
        begin
            got = dut.data.DataMEM[RESULT_WORD_IDX];
            $display("Result @ addr %0d (word idx %0d) = %0d (0x%08h)",
                      RESULT_ADDR, RESULT_WORD_IDX, got, got);
            if (got === EXPECTED_RESULT) begin
                $display("PASS: fibonacci(10) = %0d as expected", EXPECTED_RESULT);
            end else begin
                $display("FAIL: expected %0d, got %0d", EXPECTED_RESULT, got);
            end
        end
    endtask

endmodule