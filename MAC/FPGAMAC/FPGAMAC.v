module FPGAMAC(
    input [4:0] multiplicand_i,
    input [4:0] multiplier_i,
    input clk_i,
    input nreset_i,
    
    output [15:0] result_o,
    output updating_acc_result_o, 
    output fetching_input_o,
    output clk_o,
    output [2:0] count_o
    );

    wire modulo_not_reached;
    assign modulo_not_reached = ~(count_o[2] & count_o[1] & ~count_o[0]);

    MulAndAcc main_mac(
        .mac_multiplicand_i(multiplicand_i),
        .mac_multiplier_i(multiplier_i),
        .mac_clk_i(~clk_i),
        .mac_nreset_i(nreset_i),
        .mac_result_o(result_o),
        .updating_acc_result_o(updating_acc_result_o),
        .fetching_input_o(fetching_input_o),
        .mul_status_count_o(count_o)
    );

    assign clk_o = ~clk_i;

endmodule