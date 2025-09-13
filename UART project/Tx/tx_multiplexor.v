module tx_multiplexor (tx_en,data,bit_select,tx_bit);

//parameters
parameter FRAME_DATA  = 8;
parameter FRAME_WIDTH = 10;

//inputs
input tx_en ;
input [FRAME_DATA-1 :0] data    ;
input [3:0] bit_select;

//outputs
output tx_bit;

//data store
reg   [FRAME_WIDTH-1:0] data_store;


always @(*) 

	begin
		if(tx_en)
		data_store <= {1'b1,data,1'b0};
	end

assign tx_bit = (tx_en)? data_store[bit_select]:1'b1;

endmodule