`include "MAC/SubModules/SequentialMultiplier.v"
`include "MAC/SubModules/Accumulator16Bit.v"

module MulAndAcc(
    input [4:0] mac_multiplicand_i,
    input [4:0] mac_multiplier_i,
    input mac_clk_i,
    input mac_nreset_i,
    
    output [15:0] mac_result_o,
    output updating_acc_result_o, // when this turns into 1 at a clk falling edge, the accumulator's output will be updated at the following rising edge 
    output fetching_input_o // input values will be read at a clk rising edge when this is 1. It is OK to change the inputs when this is 0
    );


    // Multiplier that, has one 10-bit adder circuit, and sequentially accumulates its partial sums into an array of D flip flops (a.k.a. a register)
    wire [9:0] mul_output;

    SequentialMultiplier main_multiplier_module( // Fetch input at rising edge, let out output at falling edge
        .multiplicand_i(mac_multiplicand_i),
        .multiplier_i(mac_multiplier_i),
        .mul_clk_i(mac_clk_i),
        .mul_nreset_i(mac_nreset_i),
        .mul_result_o(mul_output),
        .is_result_o(updating_acc_result_o)
    );

    Accumulator16Bit main_accumulator( // update final result when multiplier is done at rising edge
        .new_in_i({6'b000000, mul_output}),
        .acc_clk_i(mac_clk_i),
        .acc_nreset_i(mac_nreset_i),
        .sel_i(updating_acc_result_o),
        .acc_result_o(mac_result_o)
    );

endmodule