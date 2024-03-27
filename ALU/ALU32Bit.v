`include "ALU/Submodules/Adder32Bit.v"
`include "ALU/Submodules/MUX32Bit3X8.v"
`include "ALU/Submodules/ConditionalInverter32Bit.v"

module ALU32Bit(
    input [31:0] source_val_i, // A
    input [31:0] target_val_i, // B
    input [2:0] opcode_i,
    output [31:0] alu_result_o,
    output alu_overflow_o
    );

    /* 
    opcode table:
    000: add 
    001: sub (invert B)
    010: and
    011: or
    100: xor
    101: not (invert A)
    110: shift left
    111: Unassigned
    */

    // add/subtract
    wire [31:0] flipped_b;
    wire sub; // 1 when opcode == 001 (A sub B operation)
    assign sub = ~opcode_i[2] & ~opcode_i[1] & opcode_i[0];

    ConditionalInverter32Bit BInverter(
        .target_i(target_val_i),
        .inv_sel_i(sub),
        .flip_result_o(flipped_b)
    );

    wire [31:0] add_sub_result;
    wire temp_overflow;

    Adder32Bit AdderSubtractor(
        .a32_i(source_val_i),
        .b32_i(flipped_b),
        .cin32_i(sub),
        .sum32_o(add_sub_result),
        .cout32_o(),
        .adder_overflow_o(temp_overflow)
    );
    assign alu_overflow_o = ~opcode_i[2] & ~opcode_i[1] & temp_overflow;

    // and
    wire [31:0] and_result;
    assign and_result = source_val_i & flipped_b;

    // or
    wire [31:0] or_result;
    assign or_result = source_val_i | flipped_b;

    // xor
    wire [31:0] xor_result;
    assign xor_result = source_val_i ^ flipped_b;

    // not A
    wire [31:0] flipped_a;
    wire flip_a; // 1 when opcode == 101

    assign flip_a = opcode_i[2] & ~opcode_i[1] & opcode_i[0];

    ConditionalInverter32Bit AInverter(
        .target_i(source_val_i),
        .inv_sel_i(flip_a),
        .flip_result_o(flipped_a)
    );

    // shift left
    wire [31:0] shifted_a;
    assign shifted_a = source_val_i << target_val_i[5:0];

    // MUX part
    MUX32Bit3X8 final_mux(
        .in000_i(add_sub_result),
        .in001_i(add_sub_result),
        .in010_i(and_result),
        .in011_i(or_result),
        .in100_i(xor_result),
        .in101_i(flipped_a),
        .in110_i(shifted_a),
        .in111_i(32'b0),
        .sel_3bit_i(opcode_i),
        .result_3x8mux_o(alu_result_o)
    );

endmodule
