`include "ALU/ALU32Bit.v"
`timescale 1ns/1ns

module ALU_tb();
    reg signed [31:0] tb_source_val;
    reg signed [31:0] tb_target_val;
    reg signed [2:0] tb_opcode;
    
    wire signed [31:0] tb_result;
    wire tb_overflow;

    reg [5:0] tb_shiftval;

    reg signed [31:0] actual_result;

    ALU32Bit TestALU(
        .source_val_i(tb_source_val),
        .target_val_i(tb_target_val),
        .opcode_i(tb_opcode),
        .alu_result_o(tb_result),
        .alu_overflow_o(tb_overflow)
    );

    initial begin
        $dumpfile("ALU\\BuildFiles\\ALU_tb.vcd");
        $dumpvars(0, ALU_tb);
        $monitor("$time: %0d, a: %0d, b: %0d, opcode: %b, result: %0d, ans: %0d, overflow: %b, shiftval: %0d", $time, tb_source_val, tb_target_val, tb_opcode, tb_result, actual_result, tb_overflow, tb_shiftval);
        
        tb_shiftval = 0;
        // test add operation
        tb_source_val = $random;
        tb_target_val = $random;
        tb_opcode = 3'b000;
        actual_result = tb_source_val + tb_target_val;

        #20 // test sub operation
        tb_source_val = $random;
        tb_target_val = $random;
        tb_opcode = 3'b001;
        actual_result = tb_source_val - tb_target_val;

        #20 // test add operation with overflow
        tb_source_val = -1073741829;
        tb_target_val = -1073741829;
        tb_opcode = 3'b000;
        actual_result = tb_source_val + tb_target_val;

        #20 // test sub operation with overflow
        tb_source_val = -1073741829;
        tb_target_val = 1073741829;
        tb_opcode = 3'b001;
        actual_result = tb_source_val - tb_target_val;

        #20 // test bitwise AND operation
        tb_source_val = $random;
        tb_target_val = $random;
        tb_opcode = 3'b010;
        actual_result = tb_source_val & tb_target_val;

        #20 // test bitwise OR operation
        tb_source_val = $random;
        tb_target_val = $random;
        tb_opcode = 3'b011;
        actual_result = tb_source_val | tb_target_val;

        #20 // test bitwise XOR operation
        tb_source_val = $random;
        tb_target_val = $random;
        tb_opcode = 3'b100;
        actual_result = tb_source_val ^ tb_target_val;

        #20 // test not A operation
        tb_source_val = $random;
        tb_target_val = $random;
        tb_opcode = 3'b101;
        actual_result = ~tb_source_val;

        #20 // test shift by B operation
        tb_source_val = $random;
        tb_target_val = $random;
        tb_opcode = 3'b110;
        tb_shiftval = tb_target_val[5:0];
        actual_result = tb_source_val << tb_shiftval;

        #20 // unassigned operation
        tb_source_val = $random;
        tb_target_val = $random;
        tb_opcode = 3'b111;
        actual_result = 0;
    end

endmodule