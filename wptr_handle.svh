module wptr_handle #(parameter int WIDTH = 4)(
    input wclk, wrst_n, w_en,
    input logic [WIDTH-1:0] g_rptr_sync,

    output logic full,
    output logic [WIDTH-1:0] b_wptr, g_wptr
);

logic [WIDTH-1:0] g_wptr_next, b_wptr_next;
logic wfull;

assign b_wptr_next = b_wptr + (w_en && !full);
assign g_wptr_next = (b_wptr_next >> 1) ^ b_wptr_next;

always_ff @(posedge wclk) begin
    if(!wrst_n) begin
        b_wptr <= '0;
        g_wptr <= '0;
    end else begin
        b_wptr <= b_wptr_next;
        g_wptr <= g_wptr_next;
    end
end

always_ff @(posedge wclk) begin
    if(!wrst_n)  full <= 1'b0;
    else full <= wfull;
end

assign wfull = (g_wptr_next == {~g_rptr_sync[WIDTH-1:WIDTH-2], g_rptr_sync[WIDTH-3:0]});

endmodule
