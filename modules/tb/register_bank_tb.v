`include "../register_bank.v"
`timescale 1s/1ms

module register_bank_tb;

reg clk = 0;

parameter DW = 16, AW = 3;

reg regb_ld = 0;
reg [DW-1:0] regb_in;
reg [AW-1:0] regb_addr_W, regb_addr_R;
wire [DW-1:0] regb_out;

register_bank #(.DW(DW), .AW(AW)) REGB_1 (
    .in(regb_in),
    .ld(regb_ld),
    .clk(clk),
    .addr_R(regb_addr_R),
    .addr_W(regb_addr_W),
    .out(regb_out)
);

always #0.5 clk = ~clk;

integer i;

initial begin
    $dumpfile("register_bank.vcd");
    $dumpvars(0, register_bank_tb);

    for (i = 0; i < AW ** 2; i = i+1) begin
        regb_addr_R = i;
        #1;
    end

    regb_in = 15;
    regb_addr_W = 2;

    #1
    regb_ld = 1;

    #1
    regb_addr_W = 0;

    #1
    regb_addr_W = 6;
    regb_ld = 0;

    #1;
    for (i = 0; i < AW ** 2; i = i+1) begin
        regb_addr_R = i;
        #1;
    end
    $finish;
end
endmodule