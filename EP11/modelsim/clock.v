module clock(
    input clk,
    input rst_n,
	output Phi2,
    output cpu_clken
    );

wire [3:0] q;
wire ff1_out;

ls161 LS161(
  .n_clr(rst_n),
  .clk(clk),
  .din(4'b0),
  .enp(1'b1),
  .ent(1'b1),
  .n_load(1'b1),
  .q(q),
  .rco()
);

ls74 LS74
(
  .n_pre1(1'b1),
  .n_pre2(1'b1),
  .n_clr1(1'b1),
  .n_clr2(1'b1),
  .clk1(clk),
  .clk2(clk),
  .d1(q[3]),
  .d2(),
  .q1(ff1_out),
  .q2(),
  .n_q1(),
  .n_q2()
);

wire int1 = (q[3] ^ ff1_out);
assign cpu_clken = (q[3] & int1);
assign Phi2 = q[3];

endmodule
