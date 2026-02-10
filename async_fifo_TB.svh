module async_fifo_TB;

  parameter DATA_WIDTH = 16;
  parameter DEPTH = 8;

  logic [DATA_WIDTH-1:0] data_out;
  logic full;
  logic empty;
  logic [DATA_WIDTH-1:0] data_in;
  logic w_en, wclk, wrst_n;
  logic r_en, rclk, rrst_n;

  // Queue to push data_in
  reg [DATA_WIDTH-1:0] wdata_q[$], wdata;

  asynchronous_fifo_top #(.DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH)) as_fifo (wclk, wrst_n,rclk, rrst_n,w_en,r_en,data_in,data_out,full,empty);

real wr_clk_period;
real rd_clk_period;

initial begin : generate_clock1
  wr_clk_period = $urandom_range(3,10);
  forever #(wr_clk_period/2.0) wclk = ~wclk;
end

initial begin : generate_clock2
  rd_clk_period = $urandom_range(5,15);
  forever #(rd_clk_period/2.0) rclk = ~rclk;
end




//  initial begin : generate_clock1
//     forever #5ns wclk = ~wclk;
//  end

//  initial begin : generate_clock2
//     forever #10ns rclk = ~rclk;
//  end
//   always #10ns wclk = ~wclk;
//   always #35ns rclk = ~rclk;
  
  initial begin
    wclk = 1'b0; wrst_n = 1'b0;
    w_en = 1'b0;
    data_in = 0;
    
    repeat(10) @(posedge wclk);
    wrst_n = 1'b1;

    repeat(2) begin
      for (int i=0; i<100; i++) begin
        @(posedge wclk iff !full);
        w_en = (i%2 == 0)? 1'b1 : 1'b0;
        if (w_en) begin
          data_in = $urandom;
          wdata_q.push_back(data_in);
        end
      end
      //#50;
      
    end
    disable generate_clock1;
  end

  int read_failed, read_passed;
  initial begin
    rclk = 1'b0; rrst_n = 1'b0;
    r_en = 1'b0;

    repeat(20) @(posedge rclk);
    rrst_n = 1'b1;

    repeat(2) begin
      for (int i=0; i<100; i++) begin
        @(posedge rclk iff !empty);
        r_en = (i%2 == 0)? 1'b1 : 1'b0;
        if (r_en) begin
          wdata <= wdata_q.pop_front();
          if(data_out !== wdata) begin
            $display("Time = %0t: Comparison Failed: expected wr_data = %h, rd_data = %h", $time, wdata, data_out);
            read_failed++;
          end 
          else begin
            $display("Time = %0t: Comparison Passed: expected wr_data = %h, rd_data = %h", $time, wdata, data_out);
            read_passed++;
          end
        end
      end
      //#50;
    end
    //disable generate_clock1;

    if(read_failed == 0)  $display("TEST_RESULT: PASS");
    else $$display("TEST_RESULT: FAIL Failed=%0d", read_failed);

    $display("Read Passed: %0d, Read Failed: %0d", read_passed, read_failed);
    disable generate_clock2;
    //$finish;
  end
  
  // initial begin 
  //   $dumpfile("dump.vcd"); $dumpvars;
  // end
endmodule
