
//this is an edit


`timescale 1ns/1ps

module tb_tx_top;

  reg clk;
  reg tx_en;
  reg tx_rst;
  reg tx_arst_n;
  reg [7:0] data_in;
  wire busy;
  wire done;
  wire tx_bit;

  // Instantiate DUT
  tx_top_module dut (
    .clk(clk),
    .tx_en(tx_en),
    .tx_rst(tx_rst),
    .tx_arst_n(tx_arst_n),
    .data_in(data_in),
    .busy(busy),
    .done(done),
    .tx_bit(tx_bit)
  );

  // Clock 100 MHz
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Expected frame storage
  reg [9:0] expected_frame;   // [start][data(8)][stop]
  reg [9:0] received_frame;
  integer bit_count;

  initial begin
    // Reset
    tx_en     = 0;
    tx_rst    = 0;
    tx_arst_n = 0;
    data_in   = 8'h00;

    #50 tx_arst_n = 1;  // release async reset
    #50 tx_rst    = 1;  
    #20 tx_rst    = 0;

    // Data to send
    data_in = 8'b00101001;   // example
    expected_frame = {1'b1, data_in, 1'b0}; // stop=1, data, start=0
    bit_count = 0;

    // Start transmission
    tx_en = 1;
    $display("[%0t] Transmission started",$time);

    // Collect bits on baud ticks
    forever begin
      @(posedge dut.baud_counter_out); // wait each baud pulse
      if (busy) begin
        received_frame[bit_count] = tx_bit;
        $display("[%0t] Captured bit[%0d] = %b",$time,bit_count,tx_bit);
        bit_count = bit_count + 1;
      end
      
    end
	
	
	if (done) begin
        $display("[%0t] Transmission finished",$time);
        if (received_frame === expected_frame)
          $display("TEST PASSED: Frame matched (%b)", received_frame);
        else
          $display("TEST FAILED: Expected %b but got %b", expected_frame, received_frame);
        #1000 $stop;
      end
	
	
	
	
  end

endmodule
