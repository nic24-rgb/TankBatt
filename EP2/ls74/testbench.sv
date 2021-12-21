module test;

reg nPRE=1'b0;
reg clk=1'b0;
reg nCLR=1'b1;
reg D=1'b0;
wire Q;
wire nQ;

ls74 IC1(
  .n_pre1(nPRE),
  .n_pre2(),
  .n_clr1(nCLR),
  .n_clr2(),
  .clk1(clk),
  .clk2(),
  .d1(D),
  .d2(),
  .q1(Q),
  .q2(),
  .n_q1(nQ),
  .n_q2()
);

always #10 clk=~clk;
  
initial
  begin
    $dumpfile("dump.vcd");
    $dumpvars(1);
#34 nCLR=1'b0;  
    nPRE=1'b1;
#40 nCLR=1'b0;
    nPRE=1'b0;
#40 nCLR=1'b1;
    nPRE=1'b1;
    D=1'b1;
#40 nCLR=1'b1;
    nPRE=1'b1;
    D=1'b0;
#40 $finish;
  end

endmodule
