module rx_baud_counter(

input clk,
input rx_rst,
input rx_arst_n,
input fsm_enable_baud,

output reg baud_to_fsm

);

parameter FRAME_DATA = 10;

reg [13:0] count;
reg [3:0] bits_received;

always@(posedge clk , negedge rx_arst_n) begin

if (~rx_arst_n) 
	begin
	baud_to_fsm   <= 1'b0 ;
	count                 <= 14'b11_1101_0000_1000; //15624 => 1.5 bit
	bits_received         <= 4'b0 ;
	end

else if(rx_rst) 
	begin
	baud_to_fsm   <= 1'b0 ;
	count         		  <= 14'b11_1101_0000_1000; //15624 => 1.5 bit
	bits_received         <= 4'b0 ;
	end

else if (fsm_enable_baud) 
	begin

		if (bits_received==0) 
			begin
				if(count==0)
					begin
					baud_to_fsm 		<= 1'b1 ;
					count 				<= 14'b10_1000_1011_0000; //10416 => 1 bit
					bits_received 		<= bits_received + 1'b1;
					end
				else 
					begin
					baud_to_fsm 		<= 1'b0 ;
					count       		<= count - 1'b1 ;
					end
					
			end
			
		else if (bits_received > 0 && bits_received < 10) 
			begin
				if(count==0)
					begin
					baud_to_fsm 		<= 1'b1 ;
					bits_received 		<= bits_received + 1'b1;
					count 				<= 14'b10_1000_1011_0000; //10416 => 1 bit
					end
				else 
					begin
					baud_to_fsm 		<= 1'b0 ;
					count       		<= count - 1'b1 ;
					end
			end
			
		else if (bits_received == 10)
				begin
					baud_to_fsm <= 1'b0 ;
					count 				<= 14'b10_1000_1011_0000; //10416 => 1 bit
				end
		

	end

else if (~fsm_enable_baud)
	begin
	baud_to_fsm <= 1'b0 ;
	count       <= 14'b11_1101_0000_1000; //15624
	end

end


endmodule