module rx_fsm (

input rx,
input clk,
input rx_rst,
input rx_arst_n,
input baud_to_fsm,
input edge_enable_fsm ,



output     fsm_enable_sipo,
output reg fsm_enable_baud,
output reg err_flag,
output reg done_flag,
output reg busy_flag


);

parameter idle = 0;
parameter start = 1;
parameter data = 2;
parameter done = 3;
parameter err = 4;

reg [2:0] cs , ns;
reg [3:0] counter = 4'b0000;

always@(posedge clk , negedge rx_arst_n) begin

if(~rx_arst_n) 
	begin
		cs <= idle;
		counter <=0;	
	end
else if(rx_rst)
	begin
		cs <= idle;
		counter <=0;	
	end

else
cs <= ns;
end


always@(*) begin

case(cs)
idle : begin
			fsm_enable_baud <= 1'b0;
			err_flag  <= 1'b0; 
			done_flag <= 1'b0;
			busy_flag <= 1'b0;
			counter = 0;
			if (edge_enable_fsm) 
				ns = start; 
			else 
				ns = idle;

		end
		
start: begin
			fsm_enable_baud <= 1'b1;
			err_flag   <= 1'b0; 
			done_flag  <= 1'b0;
			busy_flag  <= 1'b1;
			ns = data;
		end
		
data : begin

			if ((baud_to_fsm) && (counter < 8)) 
				begin
				    fsm_enable_baud <= 1'b1;
					err_flag  <= 1'b0; 
					done_flag <= 1'b0;
					busy_flag <= 1'b1;
					counter   = counter + 1 ;
					ns = data;
				end
				
			else if (counter==8 && baud_to_fsm)
				begin
				fsm_enable_baud <= 1'b1;
				err_flag  		<= 1'b0; 
				done_flag 		<= 1'b0;
				busy_flag 		<= 1'b1;
				if(rx==1) 
					ns = done;
				else if(rx==0) 
					ns = err ;
				
				end
		end
		
err  : begin
			fsm_enable_baud <= 1'b0;
			err_flag  		<= 1'b1; 
			done_flag 		<= 1'b0;
			busy_flag 		<= 1'b0;
			ns = idle;
		end
		
done : begin
			fsm_enable_baud <= 1'b0;
			err_flag  		<= 1'b0; 
			done_flag 		<= 1'b1;
			busy_flag 		<= 1'b0;
			ns = idle;
		end
endcase

end

assign fsm_enable_sipo = (cs == data && counter < 9 )? baud_to_fsm:1'b0;

endmodule