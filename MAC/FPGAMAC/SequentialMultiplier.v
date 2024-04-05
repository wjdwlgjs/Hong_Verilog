module SequentialMultiplier(
    input [4:0] multiplicand_i,
    input [4:0] multiplier_i,
    input mul_clk_i,
    input mul_nreset_i, // nreset signal should only rise when clk is at 0
    
    output [9:0] mul_result_o, 
    output is_result_o,
    output mul_fetching_input_o,
    output [2:0] status_count_o
    );
    // {input fetching, bitwise ANDing multiplier digit and multiplicand, and addition} is done on rising edge clk
    // partial sum register update is done on clk falling edge

    wire input_fetched; // supresses counter (keeps count at 0, as input registers will read inputs at rising edge when count = 0) until a rising edge is met while nreset = 1
    // without this, if the nreset input rises while clk is at 1, multiplication sequence will begin without fetching the inputs
    PosedgeDFF fetching_complete_checker( 
        .d_i(1'b1),
        .enable_i(mul_clk_i),
        .nreset_i(mul_nreset_i),
        .q_o(input_fetched)
    );

    // counter
    wire [2:0] count;
    wire modulo_not_reached; 
    wire count_iszero;
    assign status_count_o = count;

    assign modulo_not_reached = ~(count[2] & count[1] & ~count[0]); // create a short falling pulse signal when count == 6, resetting everything including the counter
    assign count_isnotzero = count[2] | count[1] | count[0];

    Counter3Bit main_counter( // consists of falling edge triggered DFFs
        .pulse_i(mul_clk_i),
        .count_nreset_i(input_fetched & modulo_not_reached),
        .count_o(count)
    );

    // PI-SO register made up of D FFs to fetch the multiplier
    wire current_multiplier_digit;

    RegisterPISO5Bit multiplier_fetch( // consists of rising edge triggered DFFs
        .pdi_i(multiplier_i),
        .reg_clk_i(mul_clk_i),
        .reg_nreset_i(mul_nreset_i),
        .shift_sel_i(count_isnotzero), // shift right if count !=0 , fetch parellel input (multiplier_i) if count == 0
        .sdo_o(current_multiplier_digit)
    );

    // PI-PO register made up of D FFs to fetch the multiplicand

    wire [4:0] current_multiplicand;
    RegisterPIPO5Bit multiplicand_fetch( // consists of rising edge triggered DFFs
        .pdi_i(multiplicand_i),
        .reg_clk_i(mul_clk_i),
        .reg_nreset_i(mul_nreset_i),
        .pdi_sel_i(~count_isnotzero), // keep the current thing if count != 0. I made this port to avoid clk gating
        .pdo_o(current_multiplicand)
    );
    /* could have just used somthing like

    reg [4:0] current_multiplicand;
    always @(posedge mul_clk_i) 
        current_multiplicand = multiplicand_i;

    for all the registers, but I assumed the point of the assignment as to make use of flip-flops so.. */

    // main adder
    wire [9:0] adder_operand_a;
    wire [9:0] adder_operand_b;
    wire [9:0] adder_output;

    assign adder_operand_a = {5'b00000, {5{current_multiplier_digit}} & current_multiplicand};

    Adder10Bit main_adder(
        .a10_i(adder_operand_a),
        .b10_i(adder_operand_b),
        .cin10_i(1'b0),
        .sum10_o(adder_output),
        .cout10_o()
    );

    // PI-PO register made up of D FFs for partial sum
    
    RegisterPIPO10BitNeg partial_sum_reg( // consists of falling edge triggered DFFs
        .pdi_i(adder_output),
        .reg_clk_i(mul_clk_i),
        .reg_nreset_i(mul_nreset_i & modulo_not_reached),
        .pdi_sel_i(1'b1),
        .pdo_o(mul_result_o)
    );

    // shift and feed back

    assign adder_operand_b = {mul_result_o[8:0], 1'b0};

    // a signal to indicate that the output is indeed the final product
    assign is_result_o = count[2] & ~count[1] & count[0];
    // a signal to tell the outside world that input reading is in progress
    assign mul_fetching_input_o = mul_nreset_i & ~count_isnotzero;

endmodule

