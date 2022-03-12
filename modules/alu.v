// ALU expecífica

// op:
//      00 -> +
//      01 -> -
//      10 -> <<
//      11 -> &

// OPERAR:
//      0: deja pasar in_b
//      1: opera


module alu #(parameter N = 8, N_OP = 2) (
    input [N-1:0] in_a,
    input [N-1:0] in_b,
    input [N_OP-1:0] op,
    input operar,
    output reg [N-1:0] out,
    output reg z, n, v
);

always @(*) begin
    if(operar) begin
        case(op)
            'b00: out = in_a + in_b;
            'b01: out = in_a - in_b;
            // Extiende el signo
            'b10: out = in_a[N-1] ? (in_a >> 1) | 1 << N-1 : (in_a >> 1);
            'b11: out = in_a & in_b;
            default: out = 8'd0;
        endcase
    end
    else
        out = in_b;

    z = out == 0 ? 1 : 0;
end

endmodule