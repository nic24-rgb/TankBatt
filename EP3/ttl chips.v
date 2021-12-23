//Chip pinout:
/*        _____________
        _|             |_
n_clr1 |_|1          14|_| VCC
        _|             |_                     
d1     |_|2          13|_| n_clr2
        _|             |_
clk1   |_|3          12|_| d2
        _|             |_
n_pre1 |_|4          11|_| clk2
        _|             |_
q1     |_|5          10|_| n_pre2
        _|             |_
n_q1   |_|6           9|_| q2
        _|             |_
GND    |_|7           8|_| n_q2
         |_____________|
*/

module ls74
(
	input  n_pre1, n_pre2,
	input  n_clr1, n_clr2,
	input  clk1, clk2,
	input  d1, d2,
	output reg q1, q2,
    output n_q1, n_q2
);

always @(posedge clk1 or negedge n_pre1 or negedge n_clr1) begin
	if(!n_pre1)
		q1 <= 1;
	else if(!n_clr1)
		q1 <= 0;
	else
		q1 <= d1;
end
assign n_q1 = ~q1;
	
always @(posedge clk2 or negedge n_pre2 or negedge n_clr2) begin
	if(!n_pre2)
		q2 <= 1;
	else if(!n_clr2)
		q2 <= 0;
	else
		q2 <= d2;
end
assign n_q2 = ~q2;

endmodule

//Chip pinout:
/*     _____________
     _|             |_
1J  |_|1          14|_| VCC
     _|             |_                     
1nQ |_|2          13|_| 1nCLR
     _|             |_
1Q  |_|3          12|_| 1CK
     _|             |_
1K  |_|4          11|_| 2K
     _|             |_
2Q  |_|5          10|_| 2nCLR
     _|             |_
2nQ |_|6           9|_| 2CK
     _|             |_
GND |_|7           8|_| 2J
      |_____________|
*/

module ls107(
   input clear, 
   input clk, 
   input j, 
   input k, 
   output reg q, 
   output qnot
);

assign qnot=~q;
  always @(negedge clk)
  if (!clear) q<=1'b0; else
  case ({j, k})
 2'b00: q<=q;
 2'b01: q<=1'b0;
 2'b10: q<=1'b1;
 2'b11: q<=~q;
 endcase
endmodule

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
