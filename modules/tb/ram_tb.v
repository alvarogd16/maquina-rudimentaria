`include "../ram.v"
`timescale 1s/1ms

module ram_tb;

localparam AW = 5, DW = 8, ROM_FILE = "../mem_files/rom_test.mem";

reg clk = 0;

reg [AW-1:0] ram_addr;
reg [DW-1:0] ram_in;
reg ram_w = 0;
wire [DW-1:0] ram_out;

ram #(.AW(AW), .DW(DW), .ROM_FILE(ROM_FILE)) RAM_1 (
    .clk(clk),
    .addr(ram_addr),
    .w(ram_w),
    .data_in(ram_in),
    .data_out(ram_out)
);

always # 0.5 clk = ~clk;

integer i;

initial begin
    $dumpfile("ram_tb.vcd");
    $dumpvars(0, ram_tb);

    ram_addr = 0;
    ram_in = 'h00;
    ram_w = 1;

    #1
    ram_w = 0;

    for (i = 0; i < 2 ** AW; i = i+1) begin
        ram_addr = i;
        #1;
    end

    $finish;
end
endmodule