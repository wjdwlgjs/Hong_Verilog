// `include "MAC/SubModules/DFFs.v"

module Counter3Bit( // Negative Edge Counter
    input pulse_i,
    input count_nreset_i,
    output [2:0] count_o
    );

    NegedgeDFF dff_firstbit(
        .d_i(~count_o[0]),
        .enable_i(pulse_i),
        .nreset_i(count_nreset_i),
        .q_o(count_o[0])
    );

    NegedgeDFF dff_secbit(
        .d_i(~count_o[1]),
        .enable_i(count_o[0]),
        .nreset_i(count_nreset_i),
        .q_o(count_o[1])
    );

    NegedgeDFF dff_thirdbit(
        .d_i(~count_o[2]),
        .enable_i(count_o[1]),
        .nreset_i(count_nreset_i),
        .q_o(count_o[2])
    );

endmodule
    