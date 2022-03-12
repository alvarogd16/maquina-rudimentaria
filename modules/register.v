module register
    #(parameter N = 8) (
        input [N-1:0] in,
        input ld, clk,
        output reg [N-1:0] out);

always @(posedge clk) begin
    if(ld) begin
        out <= in;
    end
end
endmodule