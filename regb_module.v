`include "modules/register_bank.v"
`include "modules/mux4.v"

`timescale 1s/1ms

module regb_module;

 // ---- Aux signals ----
reg [15:0] regb_in,
            ir_out;

wire [15:0] regb_out;

// ---- Control signals ----
reg Erd;
reg [1:0] sel_Rf;

reg clk = 0;

// ---- Intermediate signals ----
wire [2:0] regb_addr_R;

// ---- Modules ----

mux4 #(.N(3)) SELREG (
    .in_a(ir_out[13:11]),
    .in_b(ir_out[10:8]),
    .in_c(ir_out[7:5]),
    .sel(sel_Rf),
    .out(regb_addr_R)
);

// 8 register (2^3) of 16 bits
register_bank #(.DW(16), .AW(3)) REGB (
    .in(regb_in),
    .ld(Erd),
    .clk(clk),
    .addr_R(regb_addr_R),
    .addr_W(ir_out[13:11]),
    .out(regb_out)
);


always # 0.5 clk = ~clk;

initial begin
    $dumpfile("regb_module.vcd");
    $dumpvars(0, regb_module);

    $finish;
end
endmodule