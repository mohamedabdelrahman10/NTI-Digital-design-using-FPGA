module rx_edge_detector (

input clk,
input rx_en,
input rx_rst,
input rx_arst_n,
input rx_bit ,

output begin_receive ,
output rx
);

parameter a = 0;
parameter b = 1;

reg cs , ns;

always@(posedge clk , negedge rx_arst_n) begin
if (rx_rst)
cs <= a;
else if (~rx_en)
cs <= a;
else
cs <= ns;
end

always@(*) begin

case(cs) 

a : if(rx_bit)
		begin
		ns = a;
		end
	
	else if(~rx_bit) 
		begin
		ns = b;
		end
		
b : if (1) ns = b;
		
endcase

end

assign begin_receive = (cs==b)? 1'b1:1'b0;
assign rx = rx_bit;

endmodule