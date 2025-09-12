module flop_synchroniser #( parameter int WIDTH = 4) (
    input logic clk, rst_n, 
    input logic [WIDTH-1:0] data_in,
    output logic [WIDTH-1:0] data_out
);
//since it's a two flop sync, we need intermediate signal to store 1st output
logic [WIDTH-1:0] q;

always_ff @(posedge clk) begin
    if(!rst_n) begin
        q <= '0;
        data_out <= '0;
    end else begin
        q <= data_in;
        data_out <= q;
    end
end

endmodule
