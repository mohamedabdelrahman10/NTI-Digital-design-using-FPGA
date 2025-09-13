module tx_baud_counter(

input clk,
input tx_rst,
input tx_en ,
input tx_arst_n,
output reg counter_out,
output reg busy,
output reg done
);

parameter FRAME_WIDTH = 10;

reg [13:0] count;
reg [3:0] bits_sended;

always@(posedge clk , negedge tx_arst_n) begin

if (~tx_arst_n) 
	begin
	counter_out <= 1'b0 ;
	count       <= 14'b0;  
	bits_sended <= 4'b0 ;
	done        <= 1'b0 ;
	busy 	    <= 1'b0 ;
	end

else if(tx_rst) 
	begin
	counter_out <= 1'b0 ;
	count       <= 14'b0;
	bits_sended <= 4'b0 ;
	done        <= 1'b0;
	busy 	    <= 1'b0;
	end

else if (tx_en) 
	begin

		if (bits_sended==FRAME_WIDTH && count==0) 
			begin
			done 		<= 1'b1;
			busy 		<= 1'b0;
			counter_out <= 1'b0 ;
			end
			
		else if (count==10416) 
			begin
			counter_out <= 1'b1 ;
			bits_sended <= bits_sended + 1'b1;
			count       <= 14'b0;
			end

		else 
			begin
			counter_out <= 1'b0 ;
			count       <= count + 1'b1;
			done        <= 1'b0;
			busy 		<= 1'b1;
			end

	end

else if (~tx_en)
	begin
	counter_out <= 1'b0 ;
	count       <= 14'b0;
	done        <= 1'b0 ;
	busy 	    <= 1'b0 ;
	end

end


endmodule