module adder(in_a, in_b, out);

parameter N = 8;

input [N-1:0] in_a, in_b;
output [N-1:0] out;

assign out = in_a + in_b;

endmodule