module NegDLatch(
    input d_i,
    input nenable_i,
    input nreset_i,
    output reg q_o
    );

    always @(*) begin
        if (~nreset_i) q_o <= 0;
        else if (~nenable_i) q_o <= d_i;
    end
endmodule