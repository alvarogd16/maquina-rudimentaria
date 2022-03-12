`include "../sign_extender.v"
`timescale 1s/1ms

module sign_extender_tb;

localparam WIN = 8, WOUT = 16;

reg [WIN-1:0] ext_in;
wire [WOUT-1:0] ext_out;

sign_extender #(.WIN(WIN), .WOUT(WOUT)) EXT (
    .in(ext_in),
    .out(ext_out)
);

initial begin
    $dumpfile("sign_extender_tb.vcd");
    $dumpvars(0, sign_extender_tb);

    ext_in = 5;

    # 1
    ext_in = -5;

    # 1
    $finish;

end
endmodule