module rx_top_module (

input clk,
input rx_en,
input rx_rst,
input rx_arst_n,
input rx,

output done,
output err,
output busy,
output [7:0] data_out

);

wire baud_to_fsm;
wire fsm_to_baud;
wire edge_to_fsm;
wire fsm_to_sipo;
wire edge_data;

rx_fsm fsm(.rx(edge_data) , .clk(clk) , .rx_en(rx_en) , .rx_rst(rx_rst) , .rx_arst_n(rx_arst_n) , .baud_counter_in(baud_to_fsm) , .begin_receive(edge_to_fsm) , .enable_sipo(fsm_to_sipo) , .err_flag(err) , .done_flag(done) , .busy_flag(busy) , .baud_start(fsm_to_baud) );

rx_baud_counter baud_counter( .clk(clk) , .rx_en_fsm(fsm_to_baud) , .rx_rst(rx_rst) , .rx_arst_n(rx_arst_n) , .rx_baud_counter_out(baud_to_fsm) );

rx_edge_detector edge_detector(.rx_bit(rx) , .rx(edge_data)  , .clk(clk) , .rx_en(rx_en) , .rx_rst(rx_rst) , .rx_arst_n(rx_arst_n) , .begin_receive(edge_to_fsm) );

rx_sipo sipo(.rx(rx) , .clk(clk) , .rx_rst(rx_rst) , .rx_arst_n(rx_arst_n) , .data_out(data_out) , .enable(fsm_to_sipo) );


endmodule