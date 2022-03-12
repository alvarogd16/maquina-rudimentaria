`include "../mux2.v"
`timescale 1s/1ms

module mux2_tb;

localparam N = 8;

reg [N-1:0] mux_in_a, mux_in_b;
reg mux_sel;
wire [N-1:0] mux_out;

mux2 #(.N(N)) MUX2_1 (
    .in_a(mux_in_a),
    .in_b(mux_in_b),
    .sel(mux_sel),
    .out(mux_out)
);

initial begin
    $dumpfile("mux2_tb.vcd");
    $dumpvars(0, mux2_tb);

    mux_in_a = 'hAA;
    mux_in_b = 'h00;

    mux_sel = 0;

    # 1
    mux_sel = 1;

    # 1
    mux_in_b = 'hFF;

    # 1
    mux_sel = 0;

    # 2
    $finish;

end
endmodule