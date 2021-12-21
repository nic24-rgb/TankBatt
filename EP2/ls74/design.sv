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