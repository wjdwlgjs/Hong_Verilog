module ConditionalInverter32Bit(
    // flips the bits of target_i if inv_sel_i == 1;
    input [31:0] target_i,
    input inv_sel_i,

    output [31:0] flip_result_o
    );

    assign flip_result_o = target_i ^ {32{inv_sel_i}};
endmodule