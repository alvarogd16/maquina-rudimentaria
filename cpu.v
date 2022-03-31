`include "modules/adder.v"
`include "modules/mux2.v"
`include "modules/mux4.v"
`include "modules/register.v"
`include "modules/register_bank.v"
`include "modules/alu.v"
`include "modules/sign_extender.v"
`include "modules/ram.v"

`timescale 1s/1ms

// Maquina Rudimentaria
module cpu;

// ---- Señales de control ----
reg ld_ir,
    ld_rdir,
    ld_pc,
    mux_1_pc,
    reset_pc_sel,
    mem_w,
    Erd,
    ld_ra,
    operar_alu,
    ld_rz,
    ld_rn,
    ld_rv;

reg [1:0] sel_Rf;

reg clk = 0;

// ---- Señales intermedias ----
wire [15:0] ir_out,
            mem_out,
            regb_out,
            alu_a,
            alu_b,
            ext_out,
            alu_out;

wire [7:0] add_dir_out,
            rdir_out,
            inc_out,
            pc_out,
            pc_in,
            mem_dir;

wire [2:0] regb_addr_R;

wire alu_z,
        alu_n,
        alu_v,
        rz_out,
        rn_out,
        rv_out;

// -----------------
// ---- Modulos ----
// -----------------


ram #(.AW(8), .DW(16), .ROM_FILE("modules/mem_files/rom_test.mem")) MEM (
    .clk(clk),
    .w(mem_w),
    .addr(mem_dir),
    .data_in(regb_out),
    .data_out(mem_out)
);

// ---- Address-calc-module ----

register #(.N(16)) IR (
    .in(mem_out),
    .ld(ld_ir),
    .clk(clk),
    .out(ir_out)
);

adder ADD_DIR (
    .in_a(regb_out[7:0]),
    .in_b(ir_out[7:0]),
    .out(add_dir_out)
);

register RDIR (
    .in(add_dir_out),
    .ld(ld_rdir),
    .clk(clk),
    .out(rdir_out)
);

adder INC (
    .in_a(8'd1),
    .in_b(mem_dir),
    .out(inc_out)
);

mux2 MUX_RESET_PC (
    .in_a(inc_out),
    .in_b(8'd0),
    .sel(reset_pc_sel),
    .out(pc_in)
);

register PC (
    .in(pc_in),
    .ld(ld_pc),
    .clk(clk),
    .out(pc_out)
);

mux2 MUX_1 (
    .in_a(pc_out),
    .in_b(rdir_out),
    .sel(mux_1_pc),
    .out(mem_dir)
);

// ---- Regb-module ----

mux4 #(.N(3)) SELREG (
    .in_a(ir_out[13:11]),
    .in_b(ir_out[10:8]),
    .in_c(ir_out[7:5]),
    .sel(sel_Rf),
    .out(regb_addr_R)
);

// 8 register (2^3) of 16 bits
register_bank #(.DW(16), .AW(3)) REGB (
    .in(alu_out),
    .ld(Erd),
    .clk(clk),
    .addr_R(regb_addr_R),
    .addr_W(ir_out[13:11]),
    .out(regb_out)
);


// ---- Alu-module ----

register #(.N(16)) RA (
    .in(regb_out),
    .ld(ld_ra),
    .clk(clk),
    .out(alu_a)
);

sign_extender #(.WIN(5), .WOUT(16)) EXT (
    .in(ir_out[7:3]),
    .out(ext_out)
);

mux4 #(.N(16)) SELDAT (
    .in_a(mem_out),
    .in_b(mem_out),
    .in_c(ext_out),
    .in_d(regb_out),
    .sel({ir_out[14], ir_out[2]}), // TO CHECK
    .out(alu_b)
);

alu #(.N(16)) ALU (
    .in_a(alu_a),
    .in_b(alu_b),
    .op(ir_out[1:0]),
    .operar(operar_alu),
    .z(alu_z),
    .n(alu_n),
    .v(alu_v),
    .out(alu_out)
);

register #(.N(1)) RZ (
    .in(alu_z),
    .ld(ld_rz),
    .clk(clk),
    .out(rz_out)
);

register #(.N(1)) RN (
    .in(alu_n),
    .ld(ld_rn),
    .clk(clk),
    .out(rn_out)
);

register #(.N(1)) RV (
    .in(alu_v),
    .ld(ld_rv),
    .clk(clk),
    .out(rv_out)
);


always # 0.5 clk = ~clk;

initial begin
    $dumpfile("cpu.vcd");
    $dumpvars(0, cpu);

    $display("CPU Maquina rudimentaria");

    $finish;
end

endmodule