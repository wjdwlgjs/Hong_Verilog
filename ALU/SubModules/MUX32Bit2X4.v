module MUX32Bit2X4(
    input [31:0] in00_i,
    input [31:0] in01_i,
    input [31:0] in10_i,
    input [31:0] in11_i,
    input [1:0] sel_2bit_i,

    output [31:0] result_2x4mux_o
    );

    wire [3:0] decoded_sel;
    wire [31:0] mid00;
    wire [31:0] mid01;
    wire [31:0] mid10;
    wire [31:0] mid11;

    assign decoded_sel[0] = ~sel_2bit_i[1] & ~sel_2bit_i[0];
    assign decoded_sel[1] = ~sel_2bit_i[1] & sel_2bit_i[0];
    assign decoded_sel[2] = sel_2bit_i[1] & ~sel_2bit_i[0];
    assign decoded_sel[3] = sel_2bit_i[1] & sel_2bit_i[0];

    assign mid00 = in00_i & {32{decoded_sel[0]}};
    assign mid01 = in01_i & {32{decoded_sel[1]}};
    assign mid10 = in10_i & {32{decoded_sel[2]}};
    assign mid11 = in11_i & {32{decoded_sel[3]}};

    assign result_2x4mux_o = mid00 | mid01 | mid10 | mid11;

endmodule