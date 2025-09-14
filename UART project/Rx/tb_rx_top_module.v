`timescale 1ns/1ps

module tb_rx_top_module;

  localparam CLK_PERIOD = 10;               
  localparam BIT_PERIOD = 104166;           

  reg clk;
  reg rx_en;
  reg rx_rst;
  reg rx_arst_n;
  reg rx;

  wire done;
  wire err;
  wire busy;
  wire [7:0] data_out;

  rx_top_module dut (
    .clk(clk),
    .rx_en(rx_en),
    .rx_rst(rx_rst),
    .rx_arst_n(rx_arst_n),
    .rx(rx),
    .done(done),
    .err(err),
    .busy(busy),
    .data_out(data_out)
  );

  
  always #(CLK_PERIOD/2) clk = ~clk;

  task send_uart_frame;
    input [7:0] data;
    input stop_bit; 
    integer i;
    begin
      rx <= 1'b0;
      #(BIT_PERIOD);

      for (i = 0; i < 8; i = i + 1) begin
        rx <= data[i];
        #(BIT_PERIOD);
      end

      rx <= stop_bit;
      #(BIT_PERIOD);
  
      rx <= 1'b1;
      #(BIT_PERIOD);
    end
  endtask


  initial begin
    // Init
    clk = 0;

    #(5*CLK_PERIOD);
    rx_arst_n = 1;
    rx_rst = 1;
    rx_en = 1;
	rx = 1;
	
	#(5*CLK_PERIOD);
     rx_rst = 0;
	 
/* 	#(5*CLK_PERIOD);
    send_uart_frame(8'hA5, 1); //correct frame */
	
	#(5*CLK_PERIOD);
	send_uart_frame(8'hAA, 0); //fault frame
   
  /*   forever begin
      rx <= 1'b1; 
      #(BIT_PERIOD);
    end */
	
  end

endmodule
