`include "modules/adder.v"
`include "modules/mux2.v"
`include "modules/mux4.v"
`include "modules/register.v"
`include "modules/register_bank.v"
`include "modules/alu.v"
`include "modules/sign_extender.v"

`timescale 1s/1ms

// Maquina Rudimentaria
module cpu;

reg [15:0] ir_in;   // Entrada al registro de instrucción
reg [2:0] regb_R, regb_W;

wire [7:0] out;


// Señales de control
reg ld_ir,
    ld_rdir,
    ld_pc,
    ld_regb,
    ld_ra,
    mux_1_pc,
    reset_pc_sel,
    operar;

reg [1:0] alu_op;

reg clk = 0;

// Señales intermedias
wire [15:0] ir_out,
            regb_out,
            ext_out,
            ra_out,
            alu_out;
wire [7:0] add_dir_out,
            rdir_out,
            inc_out,
            pc_out,
            pc_in;
wire alu_z;



register_bank #(.DW(16), .AW(3)) REGB (
    .in(alu_out),
    .ld(ld_regb),
    .clk(clk),
    .addr_R(regb_R),
    .addr_W(regb_W),
    .out(regb_out)
);

register #(.N(16)) RA (
    .in(regb_out),
    .ld(ld_ra),
    .clk(clk),
    .out(ra_out)
);

sign_extender #(.WIN(5), .WOUT(16)) EXT (
    .in(ir_out[4:0]),
    .out(ext_out)
);

alu #(.N(16)) ALU (
    .in_a(ra_out),
    .in_b(ext_out),
    .operar(operar),
    .op(alu_op),
    .out(alu_out),
    .z(alu_z)
);

register #(.N(16)) IR (
    .in(ir_in),
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
    .in_b(out),
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
    .out(out)
);


always # 0.5 clk = ~clk;

initial begin
    $dumpfile("cpu.vcd");
    $dumpvars(0, cpu);

    // Initialize variables
    ir_in = 'hFFAA;

    // Señales de control
    ld_ir = 1;      // Cargo la instrucción
    ld_rdir = 0;
    ld_pc = 1;
    mux_1_pc = 0;
    reset_pc_sel = 1;


    # 1
    ld_ir = 0;
    ld_rdir = 1;
    reset_pc_sel = 0;

    # 2
    mux_1_pc = 1;

    # 1
    mux_1_pc = 0;

    # 5
    reset_pc_sel = 1;

    # 1
    reset_pc_sel = 0;
    
    # 10;
    $finish;
end

endmodule