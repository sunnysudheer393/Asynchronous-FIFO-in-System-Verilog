module asynchronous_fifo_top #(parameter int DEPTH = 8, DATA_WIDTH = 8)(
    input logic wclk, wrst_n, rclk, rrst_n, w_en, r_en,
    input logic [DATA_WIDTH-1:0] data_in,

    output logic [DATA_WIDTH-1:0] data_out,
    output full, empty
);
parameter WIDTH = $clog2(DEPTH);

logic [WIDTH-1:0] g_rptr,g_wptr, g_rptr_sync, g_wptr_sync;
logic [WIDTH-1:0] b_wptr,b_rptr;

//we'll have 2 flops synchronizers, 1 fifo_mem, read and write pointers
flop_synchroniser #( .WIDTH(WIDTH)) w_flop (
    .clk(wclk), .rst_n(wrst_n), .data_in(g_rptr),
    .data_out(g_rptr_sync)
);
flop_synchroniser #( .WIDTH(WIDTH)) r_flop (
    .clk(rclk), .rst_n(rrst_n), .data_in(g_wptr),
    .data_out(g_wptr_sync)
);

wptr_handle #(.WIDTH(WIDTH)) waddr (
    .wclk(wclk), .wrst_n(wrst_n), .w_en(w_en),
    .g_rptr_sync(g_rptr_sync),

    .full(full),
    .b_wptr(b_wptr), .g_wptr(g_wptr)
);

rptr_handle #(.WIDTH(WIDTH)) raddr(
    .rclk(rclk), .rrst_n(rrst_n), .r_en(r_en),
    .g_wptr_sync(g_wptr_sync),

    .empty(empty),
    .g_rptr(g_rptr), .b_rptr(b_rptr)
);

fifo_memory #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH), .WIDTH(WIDTH)) fifo_m (
    .wclk(wclk), .w_en(w_en),
    .rclk(rclk), .r_en(r_en),
    .data_in(data_in),
    .full(full), .empty(empty),
    .b_wptr(b_wptr), .b_rptr(b_rptr),

    .data_out(data_out)
    
);

endmodule
