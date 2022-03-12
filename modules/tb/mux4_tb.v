`include "../mux4.v"
`timescale 1s/1ms

module mux4_tb;

localparam N = 8;

reg [N-1:0] mux_in_a, mux_in_b, mux_in_c, mux_in_d;
reg [1:0] mux_sel;
wire [N-1:0] mux_out;

mux4 #(.N(N)) MUX4_1 (
    .in_a(mux_in_a),
    .in_b(mux_in_b),
    .in_c(mux_in_c),
    .in_d(mux_in_d),
    .sel(mux_sel),
    .out(mux_out)
);

initial begin
    $dumpfile("mux4_tb.vcd");
    $dumpvars(0, mux4_tb);

    mux_in_a = 'hAA;
    mux_in_b = 'h00;
    mux_in_c = 'hA0;
    mux_in_d = 'h0A;

    mux_sel = 0;

    # 1
    mux_sel = 1;

    # 1
    mux_sel = 2;

    # 1
    mux_sel = 3;

    # 2
    $finish;

end
endmodule