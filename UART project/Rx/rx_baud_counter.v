module rx_baud_counter(

input clk,
input rx_rst,
input rx_en_fsm,
input rx_arst_n,
output reg rx_baud_counter_out

);

parameter FRAME_DATA = 10;

reg [13:0] count;
reg [3:0] bits_received;

always@(posedge clk , negedge rx_arst_n) begin

if (~rx_arst_n) 
	begin
	rx_baud_counter_out   <= 1'b0 ;
	count                 <= 14'b11_1101_0000_1000; //15624 => 1.5 bit
	bits_received         <= 4'b0 ;
	end

else if(rx_rst) 
	begin
	rx_baud_counter_out   <= 1'b0 ;
	count         		  <= 14'b11_1101_0000_1000; //15624 => 1.5 bit
	bits_received         <= 4'b0 ;
	end

else if (rx_en_fsm) 
	begin

		if (bits_received==0) 
			begin
				if(count==0)
					begin
					rx_baud_counter_out <= 1'b1 ;
					count 				<= 14'b10_1000_1011_0000; //10416 => 1 bit
					bits_received 		<= bits_received + 1'b1;
					end
				else 
					begin
					rx_baud_counter_out <= 1'b0 ;
					count       		<= count - 1'b1 ;
					end
					
			end
			
		else if (bits_received > 0 && bits_received < 10) 
			begin
				if(count==0)
					begin
					rx_baud_counter_out <= 1'b1 ;
					bits_received 		<= bits_received + 1'b1;
					count 				<= 14'b10_1000_1011_0000; //10416 => 1 bit
					end
				else 
					begin
					rx_baud_counter_out <= 1'b0 ;
					count       		<= count - 1'b1 ;
					end
			end
			
		else if (bits_received == 10)
				begin
					rx_baud_counter_out <= 1'b0 ;
					count 				<= 14'b10_1000_1011_0000; //10416 => 1 bit
				end
		

	end

else if (~rx_en_fsm)
	begin
	rx_baud_counter_out <= 1'b0 ;
	count       <= 14'b11_1101_0000_1000; //15624
	end

end


endmodule