module tx_bit_select (baud_counter_clk , bit_select , tx_arst_n);

parameter FRAME_WIDTH = 10;

input tx_arst_n;
input baud_counter_clk;

output     [3:0] bit_select;
reg        [3:0] bit_select_counter = 4'b0000;

always @(posedge baud_counter_clk , negedge tx_arst_n) 

	begin
		if(~tx_arst_n)
		bit_select_counter <= 4'b0000;
	
		else 
			begin
				if(bit_select_counter == (FRAME_WIDTH-1) ) 
				bit_select_counter <= FRAME_WIDTH-1;

				else
				bit_select_counter <= bit_select_counter + 1'b1;
			end

	end

assign bit_select = bit_select_counter;

endmodule