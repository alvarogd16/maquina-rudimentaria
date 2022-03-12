`include "../adder.v"

module adder_tb;

localparam N = 8;

reg [N-1:0] in_a, in_b;
wire [N-1:0] out;

adder #(.N(N)) ADD8_1 (
    .in_a(in_a),
    .in_b(in_b),
    .out(out)
);

initial begin
    $dumpfile("adder_tb.vcd");
    $dumpvars(0, adder_tb);

    in_a = 5;
    in_b = 1;

    # 1
    in_a = 9;
    in_b = 100;

    # 1
    in_a = -1; // Se representa como FF (complemento a 2)
    in_b = 9;

    # 1
    in_a = 255; // Se representa como FF también
    in_b = 2;

    # 1
    $finish;
end
endmodule