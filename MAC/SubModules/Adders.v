module SingleBitFA(
    input a_i,
    input b_i,
    input cin_i,

    output sum_o,
    output cout_o
    );

    assign sum_o = a_i ^ b_i ^ cin_i;
    assign cout_o = a_i & b_i | a_i & cin_i | b_i & cin_i;

endmodule

module Adder16Bit(
    input [15:0] a16_i,
    input [15:0] b16_i,
    input cin16_i,

    output [15:0] sum16_o,
    output cout16_o
    );

    wire [16:0] carry;
    assign carry[0] = cin16_i;
    assign cout16_o = carry[16];

    genvar i;

    generate 
        for (i = 0; i < 16; i = i + 1) begin
            SingleBitFA fa_inst(
                .a_i(a16_i[i]),
                .b_i(b16_i[i]),
                .cin_i(carry[i]),
                .sum_o(sum16_o[i]),
                .cout_o(carry[i+1])
            );
        end
    endgenerate

endmodule

module Adder10Bit(
    input [9:0] a10_i,
    input [9:0] b10_i,
    input cin10_i,

    output [9:0] sum10_o,
    output cout10_o
    );

    wire [10:0] carry;
    assign carry[0] = cin10_i;
    assign cout10_o = carry[10];

    genvar i;

    generate 
        for (i = 0; i < 10; i = i + 1) begin
            SingleBitFA fa_inst(
                .a_i(a10_i[i]),
                .b_i(b10_i[i]),
                .cin_i(carry[i]),
                .sum_o(sum10_o[i]),
                .cout_o(carry[i+1])
            );
        end
    endgenerate

endmodule



