

module Accumulator16Bit(
    input [15:0] new_in_i,
    input acc_clk_i,
    input acc_nreset_i,
    input sel_i, // fetch and accumulate input if 1, hold the current thing if 0
    output [15:0] acc_result_o
    );

    wire [15:0] reg_input;

    Adder16Bit main_adder(
        .a16_i(new_in_i),
        .b16_i(acc_result_o),
        .cin16_i(1'b0),
        .sum16_o(reg_input),
        .cout16_o()
    );

    RegisterPIPO16Bit main_register(
        .pdi_i(reg_input),
        .reg_clk_i(acc_clk_i),
        .reg_nreset_i(acc_nreset_i),
        .pdi_sel_i(sel_i),
        .pdo_o(acc_result_o)
    );

endmodule