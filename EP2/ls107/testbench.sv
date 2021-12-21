module test;

reg clk=1'b0;
reg j=1'b0;
reg k=1'b0;
reg nCLR=1'b0;
wire q, n_q;

  ls107 ic1(
    .clear(nCLR), 
    .clk(clk),
    .j(j),
    .k(k),
    .q(q),
    .qnot(n_q)
  );

initial
  begin
    $dumpfile("dump.vcd");
    $dumpvars(1);
#34 nCLR=1'b1;
#40 j=1'b1;
#40 j=1'b0;
    k=1'b1;
#40 j=1'b1;
#80 $finish;
  end

always #10 clk=~clk;

endmodule
