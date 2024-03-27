`include "ALU/SubModules/SingleBitAdder.v"

module Adder32Bit(
    input [31:0] a32_i,
    input [31:0] b32_i,
    input cin32_i,
    
    output [31:0] sum32_o,
    output cout32_o,
    output adder_overflow_o
    );

    wire [32:0] carry;
    
    assign carry[0] = cin32_i;
    assign cout32_o = carry[32];
    assign adder_overflow_o = carry[32] ^ carry[31];

    genvar i;

    generate 
        for (i = 0; i < 32; i = i + 1) begin
            SingleBitAdder AdderInst(
                .a_i(a32_i[i]),
                .b_i(b32_i[i]),
                .cin_i(carry[i]),
                .sum_o(sum32_o[i]),
                .cout_o(carry[i+1])
            );
        end
    endgenerate

endmodule