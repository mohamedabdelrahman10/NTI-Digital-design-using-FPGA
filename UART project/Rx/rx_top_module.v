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
wire fsm_enable_baud;
wire edge_enable_fsm;
wire fsm_enable_sipo;

rx_fsm fsm(.rx(rx) , .clk(clk) , .rx_rst(rx_rst) , .rx_arst_n(rx_arst_n) , .baud_to_fsm(baud_to_fsm) , .edge_enable_fsm(edge_enable_fsm) , .fsm_enable_sipo(fsm_enable_sipo) , .err_flag(err) , .done_flag(done) , .busy_flag(busy) , .fsm_enable_baud(fsm_enable_baud) );

rx_baud_counter baud_counter( .clk(clk) , .fsm_enable_baud(fsm_enable_baud) , .rx_rst(rx_rst) , .rx_arst_n(rx_arst_n) , .baud_to_fsm(baud_to_fsm) );

rx_edge_detector edge_detector(.rx(rx) , .clk(clk) , .rx_en(rx_en) , .rx_rst(rx_rst) , .rx_arst_n(rx_arst_n) , .edge_enable_fsm(edge_enable_fsm) );

rx_sipo sipo(.rx(rx) , .clk(clk) , .rx_rst(rx_rst) , .rx_arst_n(rx_arst_n) , .data_out(data_out) , .fsm_enable_sipo(fsm_enable_sipo) );


endmodule