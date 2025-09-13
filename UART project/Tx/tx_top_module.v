module tx_top_module (clk , tx_en , tx_rst , tx_arst_n , data_in , busy , done , tx_bit);

parameter FRAME_DATA = 8;

input clk;
input tx_en;
input tx_rst;
input tx_arst_n;
input [FRAME_DATA-1:0] data_in;

output busy;
output done;
output tx_bit;

wire [FRAME_DATA-1:0] frame_data_out ;
wire baud_counter_out;
wire [3:0] baud_bit_select;

tx_frame        frame_module        (.tx_en(tx_en) , .clk(clk) , .tx_arst_n(tx_arst_n) , .tx_rst(tx_rst) , .data_in(data_in) , .data_out(frame_data_out) );

tx_baud_counter baud_counter_module (.tx_en(tx_en) , .clk(clk) , .tx_arst_n(tx_arst_n) , .tx_rst(tx_rst) , .counter_out(baud_counter_out) , .done(done) , .busy(busy) );

tx_bit_select   bit_select_module   (.tx_arst_n(tx_arst_n) , .baud_counter_clk(baud_counter_out) , .bit_select(baud_bit_select) );

tx_multiplexor  multiplexor_module  (.tx_en(tx_en) , .data(frame_data_out) , .bit_select(baud_bit_select) , .tx_bit(tx_bit));


endmodule