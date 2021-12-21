module test;

reg clk=1'b0;
reg nCLR=1'b0;
reg [3:0]din=4'b0000;
reg enp=1'b0;
reg ent=1'b0;
reg nLOAD=1'b0;
wire [3:0]q;
wire rco;
wire q0=q[0];
wire q1=q[1];
wire q2=q[2];
wire q3=q[3];

ls161 LS161(
  .n_clr(nCLR),
  .clk(clk),
  .din(din),
  .enp(enp),
  .ent(ent),
  .n_load(nLOAD),
  .q(q),
  .rco(rco)
);

  initial
  begin
    $dumpfile("dump.vcd");
    $dumpvars(1);

#34 nCLR=1'b1;
#20 nLOAD=1'b1;
    ent=1'b0;
#20 ent=1'b1;
    enp=1'b1;
#80 nLOAD=1'b0;
#40	nLOAD=1'b1;
#80 nCLR=1'b0;
#20 nCLR=1'b1;
#380 $finish;
  end

always #10 clk=~clk;

endmodule
