module SingleBitAdder(
    input a_i,
    input b_i,
    input cin_i,

    output sum_o,
    output cout_o
    );

    assign sum_o = a_i ^ b_i ^ cin_i;
    assign cout_o = a_i & b_i | a_i & cin_i | b_i & cin_i;

endmodule