`timescale 1ns/1ps

module tb_Top_Module;

    reg clk;
    reg rst;
    wire [31:0] WriteData, Addr;
    wire MemWrite;

    integer errors;
    integer i;
    reg [31:0] expected_array [0:7];

    // ---------------------------------------------------------------
    // DUT
    // ---------------------------------------------------------------
    Top_Module dut (
        .clk       (clk),
        .rst       (rst),
        .WriteData (WriteData),
        .Addr      (Addr),
        .MemWrite  (MemWrite)
    );

    // ---------------------------------------------------------------
    // Clock: 10ns period
    // ---------------------------------------------------------------
    initial clk = 0;
    always #5 clk = ~clk;

    // ---------------------------------------------------------------
    // Reset and run
    // ---------------------------------------------------------------
    initial begin
        errors = 0;

        expected_array[0] = 32'd1;
        expected_array[1] = 32'd2;
        expected_array[2] = 32'd3;
        expected_array[3] = 32'd4;
        expected_array[4] = 32'd5;
        expected_array[5] = 32'd7;
        expected_array[6] = 32'd8;
        expected_array[7] = 32'd9;

        rst = 1;
        repeat (2) @(posedge clk);
        rst = 0;

        wait_for_done_or_timeout(3000);

        // ---------------- Checks ----------------
        if (dut.data.DataMEM[11] !== 32'd1) begin
            errors = errors + 1;
            $display("FAIL: done flag not set (word[11] = %0d, expected 1) -- program did not finish in time",
                       dut.data.DataMEM[11]);
        end else begin
            $display("done flag OK (word[11] = 1)");
        end

        for (i = 0; i < 8; i = i + 1) begin
            if (dut.data.DataMEM[i] !== expected_array[i]) begin
                errors = errors + 1;
                $display("FAIL: sorted array[%0d] = %0d, expected %0d",
                           i, dut.data.DataMEM[i], expected_array[i]);
            end
        end
        $display("sorted array = %0d %0d %0d %0d %0d %0d %0d %0d",
                   dut.data.DataMEM[0], dut.data.DataMEM[1], dut.data.DataMEM[2],
                   dut.data.DataMEM[3], dut.data.DataMEM[4], dut.data.DataMEM[5],
                   dut.data.DataMEM[6], dut.data.DataMEM[7]);

        if (dut.data.DataMEM[8] !== 32'd39) begin
            errors = errors + 1;
            $display("FAIL: sum (word[8]) = %0d, expected 39", dut.data.DataMEM[8]);
        end else
            $display("sum OK (word[8] = 39)");

        if (dut.data.DataMEM[9] !== 32'd6) begin
            errors = errors + 1;
            $display("FAIL: gcd (word[9]) = %0d, expected 6", dut.data.DataMEM[9]);
        end else
            $display("gcd OK (word[9] = 6)");

        if (dut.data.DataMEM[10] !== 32'd45) begin
            errors = errors + 1;
            $display("FAIL: sum+gcd (word[10]) = %0d, expected 45", dut.data.DataMEM[10]);
        end else
            $display("sum+gcd OK (word[10] = 45)");

        // Also sanity-check the register-file results (x10=sum, x11=gcd, x13=sum+gcd)
        if (dut.singleC.Data.regf.RF[10] !== 32'd39) begin
            errors = errors + 1;
            $display("FAIL: x10 (sum reg) = %0d, expected 39", dut.singleC.Data.regf.RF[10]);
        end
        if (dut.singleC.Data.regf.RF[11] !== 32'd6) begin
            errors = errors + 1;
            $display("FAIL: x11 (gcd reg) = %0d, expected 6", dut.singleC.Data.regf.RF[11]);
        end
        if (dut.singleC.Data.regf.RF[13] !== 32'd45) begin
            errors = errors + 1;
            $display("FAIL: x13 (sum+gcd reg) = %0d, expected 45", dut.singleC.Data.regf.RF[13]);
        end

        $display("----------------------------------------------------");
        if (errors == 0)
            $display("*** TEST PASSED: program executed correctly ***");
        else
            $display("*** TEST FAILED: %0d error(s) found ***", errors);
        $display("----------------------------------------------------");

        $finish;
    end

    task wait_for_done_or_timeout(input integer max_cycles);
        integer c;
        begin
            c = 0;
            while (c < max_cycles && dut.data.DataMEM[11] !== 32'd1) begin
                @(posedge clk);
                c = c + 1;
            end
            // let the final write settle and add a small margin
            repeat (5) @(posedge clk);
            $display("Simulation ran %0d cycles before done flag observed.", c);
        end
    endtask

    initial begin
        $dumpfile("tb_Top_Module.vcd");
        $dumpvars(0, tb_Top_Module);
    end

endmodule
