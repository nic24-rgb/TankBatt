//Chip pinout:
/*        _____________
        _|             |_
n_clr  |_|1          16|_| VCC
        _|             |_                     
clk    |_|2          15|_| rco
        _|             |_
din(0) |_|3          14|_| q(0)
        _|             |_
din(1) |_|4          13|_| q(1)
        _|             |_
din(2) |_|5          12|_| q(2)
        _|             |_
din(3) |_|6          11|_| q(3)
        _|             |_
enp    |_|7          10|_| ent
        _|             |_
GND    |_|8           9|_| n_load
         |_____________|
*/

module ls161 //asynchronous reset/clear
(
	input        n_clr,
	input        clk,
	input  [3:0] din,
	input        enp, ent,
	input        n_load,
	output [3:0] q,
	output       rco
);

  reg [3:0] data = 4'b0;

always @(posedge clk or negedge n_clr) begin
	if(!n_clr)
		data <= 4'd0;
	else
		if(!n_load)
			data <= din;
		else if(enp && ent)
			data <= data + 4'd1;
end

assign q = data;
assign rco = data[0] & data[1] & data[2] & data[3] & ent;

endmodule