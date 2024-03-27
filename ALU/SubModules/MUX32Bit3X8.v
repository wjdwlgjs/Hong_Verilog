`include "ALU/SubModules/MUX32Bit2X4.v"

module MUX32Bit3X8(
    input [31:0] in000_i,
    input [31:0] in001_i,
    input [31:0] in010_i,
    input [31:0] in011_i,
    input [31:0] in100_i,
    input [31:0] in101_i,
    input [31:0] in110_i,
    input [31:0] in111_i,
    input [2:0] sel_3bit_i,

    output [31:0] result_3x8mux_o
    );

    wire [31:0] zero_three_result;
    wire [31:0] four_seven_result;

    MUX32Bit2X4 ZeroToThree(
        .in00_i(in000_i), // 0
        .in01_i(in001_i), // 1
        .in10_i(in010_i), // 2
        .in11_i(in011_i), // 3
        .sel_2bit_i(sel_3bit_i[1:0]),
        .result_2x4mux_o(zero_three_result)
    );

    MUX32Bit2X4 FourToSeven(
        .in00_i(in100_i), // 4
        .in01_i(in101_i), // 5
        .in10_i(in110_i), // 6
        .in11_i(in111_i), // 7
        .sel_2bit_i(sel_3bit_i[1:0]),
        .result_2x4mux_o(four_seven_result)
    );
    
    assign result_3x8mux_o = zero_three_result & {32{~sel_3bit_i[2]}} | four_seven_result & {32{sel_3bit_i[2]}};

endmodule