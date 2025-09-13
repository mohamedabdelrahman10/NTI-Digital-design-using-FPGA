module tx_frame (clk , tx_rst , tx_en , tx_arst_n , data_in , data_out );

parameter FRAME_DATA = 8;

input tx_en ;
input tx_rst;
input tx_arst_n;
input clk;
input      [FRAME_DATA-1:0] data_in ;
output reg [FRAME_DATA-1:0] data_out;

always @(posedge clk,negedge tx_arst_n) 
	begin

		if(~tx_arst_n)
		data_out <= {FRAME_DATA{1'b0}};

		else if(tx_rst)
		data_out <= {FRAME_DATA{1'b0}};

		else if(tx_en)
		data_out <= data_in ;

		else if(~tx_en) //ASK
		data_out <= data_out;

	end

endmodule