`timescale 1ns/1ns
`include "MAC/SubModules/NegDLatch.v"

module tb_DLatch();

    reg tb_d;
    reg tb_nenable;
    reg tb_nreset;
    wire tb_q;

    