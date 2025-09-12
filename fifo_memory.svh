module fifo_memory #(parameter int DEPTH = 8, parameter int DATA_WIDTH = 8, parameter int WIDTH = 3)(
    input logic wclk, w_en,
    input logic rclk, r_en,
    input logic [DATA_WIDTH-1:0] data_in,
    input logic full, empty,
    input logic [WIDTH-1:0] b_wptr, b_rptr,

    output logic [DATA_WIDTH-1:0] data_out
    
);
//parameter WIDTH = $clog2(DATA_WIDTH);
logic [DATA_WIDTH-1:0] fifo [DEPTH-1:0];

always_ff @(posedge wclk) begin
    if(w_en && !full) begin
        fifo[b_wptr[WIDTH-1:0]] <= data_in;
    end
end

assign data_out = fifo[b_rptr[WIDTH-1:0]];

endmodule
