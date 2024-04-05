`include "MAC/SubModules/SequentialMultiplier.v"
`timescale 1ns/1ns

module tb_SequentialMultiplier();
    reg [4:0] tb_multiplicand;
    reg [4:0] tb_multiplier;
    reg tb_clk;
    reg tb_nreset; 
    wire [9:0] tb_result;
    wire tb_isresult;
    wire tb_fetching;

    SequentialMultiplier TestMultiplier(
        .multiplicand_i(tb_multiplicand),
        .multiplier_i(tb_multiplier),
        .mul_clk_i(tb_clk),
        .mul_nreset_i(tb_nreset),
    
        .mul_result_o(tb_result), 
        .is_result_o(tb_isresult),
        .fetching_input_o(tb_fetching)
    );

    initial begin
        $dumpfile("MAC/SubModules/TestBenches/BuildFiles/tb_SequentialMultiplier.vcd");
        $dumpvars(0, tb_SequentialMultiplier);
        tb_nreset = 1'b0;
        tb_clk = 1'b0;
        tb_multiplicand = 5'b11111;
        tb_multiplier = 5'b11111;

        #5
        tb_nreset = 1'b1;

        #5
        for (integer i = 0; i < 28; i = i + 1) begin
            tb_clk = ~tb_clk;
            #10;
        end

        #5
        tb_multiplicand = 5'b10101;
        tb_multiplier = 5'b01010;

        #5
        for (integer i = 0; i < 28; i = i + 1) begin
            tb_clk = ~tb_clk;
            #10;
        end

        tb_nreset = 1'b0;

        for (integer i = 0; i < 10; i = i + 1) begin
            tb_clk = ~tb_clk;
            #10;
        end

        tb_clk = 1'b1;
        
        #5

        tb_nreset = 1'b1;
        #5

        for (integer i = 0; i < 10; i = i + 1) begin
            tb_clk = ~tb_clk;
            #10;
        end

        tb_clk = 1;


    end
endmodule



