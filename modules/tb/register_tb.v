`include "../register.v"
`timescale 1s/1ms

module register_tb;

localparam N = 8;

reg clk = 0, reg_ld = 0;
reg [N-1:0] reg_in;
wire [N-1:0] reg_out;

register #(.N(N)) REG8_1 (
    .in(reg_in),
    .out(reg_out),
    .ld(reg_ld),
    .clk(clk)
);

always # 0.5 clk = ~clk;

initial begin
    $dumpfile("register_tb.vcd");
    $dumpvars(0, register_tb);

    reg_in = 8'b10101010;

    # 2
    reg_ld = 1;

    # 3
    reg_in = 8'b00000000;
    reg_ld = 0;

    # 4
    reg_ld = 1;

    # 10
    $finish;

end
endmodule