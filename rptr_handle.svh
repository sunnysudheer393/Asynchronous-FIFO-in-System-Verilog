module rptr_handle #(parameter int WIDTH = 4)(
    input logic rclk, rrst_n, r_en,
    input logic [WIDTH-1:0] g_wptr_sync,

    output logic empty,
    output logic [WIDTH-1:0] g_rptr, b_rptr
);

logic [WIDTH-1:0] b_rptr_next, g_rptr_next;
logic rempty;

assign b_rptr_next = b_rptr + (r_en && !empty);
assign g_rptr_next = (b_rptr_next>>1)^ b_rptr_next;
assign rempty = (g_wptr_sync == g_rptr_next);

always_ff @(posedge rclk) begin
    if(!rrst_n) begin
        g_rptr <= '0;
        b_rptr <= '0;
        //empty <= 1'b1;
    end else begin
        g_rptr <= g_rptr_next;
        b_rptr <= b_rptr_next;
        //empty <= rempty;
    end
end

always_ff @(posedge rclk) begin
    if(!rrst_n) empty <= 1'b1;
    else empty <= rempty;
end

endmodule
