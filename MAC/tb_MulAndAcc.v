`timescale 1ns/1ns
`include "MAC/MulAndAcc.v"

module tb_MulAndAcc();

    reg [4:0] tb_multiplicand;
    reg [4:0] tb_multiplier;
    reg tb_clk;
    reg tb_nreset;
    
    wire [15:0] tb_result;
    wire tb_updating_acc_result; 
    wire tb_fetching_input;

    MulAndAcc TestMAC(
        .mac_multiplicand_i(tb_multiplicand),
        .mac_multiplier_i(tb_multiplier),
        .mac_clk_i(tb_clk),
        .mac_nreset_i(tb_nreset),
        
        .mac_result_o(tb_result),
        .updating_acc_result_o(tb_updating_acc_result), 
        .fetching_input_o(tb_fetching_input)
    );

    always @(negedge tb_clk) #1 begin
        if (tb_fetching_input) begin
            tb_multiplicand = $random;
            tb_multiplier = $random;
        end
    end


    initial begin
        $dumpfile("MAC/BuildFiles/tb_MulAndAcc.vcd");
        $dumpvars(0, tb_MulAndAcc);

        tb_clk = 1;
        tb_nreset = 0;

        #5
        tb_nreset = 1;

        #5
        tb_clk = 0;


        repeat (100) begin
            #10 tb_clk = ~tb_clk;
        end

    end
endmodule





