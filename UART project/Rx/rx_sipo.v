module rx_sipo (

input clk,
input rx_rst,
input rx_arst_n,
input fsm_enable_sipo ,
input rx,
output reg [7:0] data_out

);

reg [7:0] data;
reg [3:0] counter = 4'b0000;



always@(posedge clk , negedge rx_arst_n) begin
if(~rx_arst_n)
	begin
	counter <= 4'b0000;
	data	<= 8'b0;
	end
else if (rx_rst)
	begin
	counter <= 4'b0000;
	data	<= 8'b0;
	end
else if(fsm_enable_sipo) 
	
	begin 
	if(counter < 8)
		begin
			data <= { rx , data[7:1] };
			counter <= counter + 1'b1;
		end
		
	end
	
else if(~fsm_enable_sipo)
data <= data;
	
end

always@(*) begin
//data_out <=8'b0;
if(counter==8)
data_out <= data;
end

endmodule