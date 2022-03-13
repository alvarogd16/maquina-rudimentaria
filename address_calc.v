`include "modules/adder.v"
`include "modules/mux2.v"
`include "modules/register.v"
`include "modules/ram.v"

`timescale 1s/1ms

// --------- Maquina Rudimentaria - Calculo de direcciones ---------
module address_calc;

// ---- Sañales de entrada auxiliares ----

reg [15:0] regb_out;

// ---- Señales de control ----
reg ld_ir,
    ld_rdir,
    ld_pc,
    mux_1_pc,
    reset_pc_sel,
    mem_w;

reg clk = 0;

// ---- Señales intermedias ----
wire [15:0] ir_out,
            mem_out;

wire [7:0] add_dir_out,
            rdir_out,
            inc_out,
            pc_out,
            pc_in,
            mem_dir;

// --- Modulos ----

ram #(.AW(8), .DW(16), .ROM_FILE("modules/mem_files/rom_test.mem")) MEM (
    .clk(clk),
    .w(mem_w),
    .addr(mem_dir),
    .data_in(regb_out),
    .data_out(mem_out)
);

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


always # 0.5 clk = ~clk;

initial begin
    $dumpfile("address_calc.vcd");
    $dumpvars(0, address_calc);
    
    // --- Fetch ----

    // Reset PC - PC to 0
    reset_pc_sel = 1;
    ld_pc = 1;
    # 1;

    // Cicle 0 - Access an instruction in memory from PC
    ld_ir = 0;
    ld_rdir = 0;
    ld_pc = 0;
    mux_1_pc = 0;
    reset_pc_sel = 0;
    mem_w = 0;
    # 1;

    // Cicle 1 - Load the instruction in IR
    ld_ir = 1;
    # 1;

    $finish;
end

endmodule