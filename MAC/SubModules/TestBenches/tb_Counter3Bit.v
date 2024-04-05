`include "MAC/SubModules/Counter3Bit.v"

module tb_Counter3Bit();

    reg tb_clk;
    reg tb_nreset;
    wire [2:0] tb_count;

    Counter3Bit TestCounter(
        .pulse_i(tb_clk),
        .count_nreset_i(tb_nreset),
        .count_o(tb_count)
    );

    initial begin
        $dumpfile("MAC/SubModules/TestBenches/BuildFiles/tb_Counter3Bit.vcd");
        $dumpvars(0, tb_Counter3Bit);

        tb_nreset = 0;
        tb_clk = 0;

        #10
        tb_nreset = 1;

        for (integer i = 0; i < 24; i = i + 1) begin
            tb_clk = ~tb_clk;
            #10;
        end

        tb_nreset = 0;

        #10
        tb_clk = 1;
    end

endmodule
