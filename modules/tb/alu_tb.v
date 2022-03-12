`include "../alu.v"
`timescale 1s/1ms

module alu_tb;


localparam N = 16;

reg [N-1:0] alu_in_a, alu_in_b;
reg [1:0] alu_op;
reg alu_operar;

wire [N-1:0] alu_out;
wire alu_z;


alu #(.N(N)) ALU_1 (
    .in_a(alu_in_a),
    .in_b(alu_in_b),
    .op(alu_op),
    .operar(alu_operar),
    .out(alu_out),
    .z(alu_z)
);

initial begin
    $dumpfile("alu_tb.vcd");
    $dumpvars(0, alu_tb);

    alu_operar = 1;
    alu_in_a = 16'd10;
    alu_in_b = 16'd5;

    alu_op = 2'b00; // Sumamos

    # 1
    alu_op = 2'b01;  // Restamos

    # 1
    alu_op = 2'b10;  // Right shift

    # 1
    alu_op = 2'b11;  // And

    # 1
    alu_in_a = -10;
    alu_in_b = 16'd5;

    alu_op = 2'b00; // Sumamos

    # 1
    alu_op = 2'b01;  // Restamos

    # 1
    alu_op = 2'b10;  // Right shift

    # 1
    alu_op = 2'b11;  // And

    # 1
    alu_operar = 0;

    # 1
    alu_op = 2'b00; // No deberia hacer nada

    # 1
    alu_op = 2'b01;  // No deberia hacer nada

    # 1
    alu_op = 2'b10;  // No deberia hacer nada

    # 2
    $finish;
end
endmodule