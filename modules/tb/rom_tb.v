`include "../rom.v"
`timescale 1s/1ms

module rom_tb;

localparam AW = 5, DW = 8, ROM_FILE = "../mem_files/rom_test.mem";

reg clk = 0;

reg [AW-1:0] rom_addr;
wire [DW-1:0] rom_out;

rom #(.AW(AW), .DW(DW), .ROM_FILE(ROM_FILE)) ROM_1 (
    .clk(clk),
    .addr(rom_addr),
    .data_out(rom_out)
);

always # 0.5 clk = ~clk;

integer i;

initial begin
    $dumpfile("rom_tb.vcd");
    $dumpvars(0, rom_tb);

    for (i = 0; i < 2 ** AW; i = i+1) begin
        rom_addr = i;
        #1;
    end

    $finish;
end
endmodule