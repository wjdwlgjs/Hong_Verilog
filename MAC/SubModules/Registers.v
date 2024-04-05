`include "MAC/SubModules/DFFs.v"

module RegisterPIPO5Bit( // parellel input, parellel output posedge-triggered register
    input [4:0] pdi_i,
    input reg_clk_i,
    input reg_nreset_i,
    input pdi_sel_i, // keep the current thing if 0. This is to avoid clk gating
    output [4:0] pdo_o
    );

    genvar i;

    generate 
        for (i = 0; i < 5; i = i + 1) begin
            PosedgeDFF dff_inst(
                .d_i((pdi_i[i] & pdi_sel_i) | (pdo_o[i] & ~pdi_sel_i)),
                .enable_i(reg_clk_i),
                .nreset_i(reg_nreset_i),
                .q_o(pdo_o[i])
            );
        end
    endgenerate

endmodule

module RegisterPISO5Bit( 
    input [4:0] pdi_i,
    input reg_clk_i,
    input reg_nreset_i,
    input shift_sel_i, // shift right if 1, fetch parellel input if 0
    
    output sdo_o
    );

    wire [5:0] shift_wires;
    assign sdo_o = shift_wires[5];
    assign shift_wires[0] = shift_wires[5];

    genvar i;

    generate 
        for (i = 0; i < 5; i = i + 1) begin
            PosedgeDFF dff_inst(
                .d_i((shift_wires[i] & shift_sel_i) | (pdi_i[i] & ~shift_sel_i)),
                .enable_i(reg_clk_i),
                .nreset_i(reg_nreset_i),
                .q_o(shift_wires[i+1])
            );
        end
    endgenerate

endmodule

module RegisterPIPO16Bit( // parellel input, parellel output posedge-triggered register
    input [15:0] pdi_i,
    input reg_clk_i,
    input reg_nreset_i,
    input pdi_sel_i, // keep the current thing if 0. This is to avoid clk gating
    output [15:0] pdo_o
    );

    genvar i;

    generate 
        for (i = 0; i < 16; i = i + 1) begin
            PosedgeDFF dff_inst(
                .d_i((pdi_i[i] & pdi_sel_i) | (pdo_o[i] & ~pdi_sel_i)),
                .enable_i(reg_clk_i),
                .nreset_i(reg_nreset_i),
                .q_o(pdo_o[i])
            );
        end
    endgenerate

endmodule

module RegisterPIPO10BitNeg( // parellel input, parellel output Negedge-triggered register
    input [9:0] pdi_i,
    input reg_clk_i,
    input reg_nreset_i,
    input pdi_sel_i, // keep the current thing if 0. This is to avoid clk gating
    output [9:0] pdo_o
    );

    genvar i;

    generate 
        for (i = 0; i < 10; i = i + 1) begin
            NegedgeDFF dff_inst(
                .d_i((pdi_i[i] & pdi_sel_i) | (pdo_o[i] & ~pdi_sel_i)),
                .enable_i(reg_clk_i),
                .nreset_i(reg_nreset_i),
                .q_o(pdo_o[i])
            );
        end
    endgenerate

endmodule


