module tankb__cputest_top;

//wire & reg setup
reg PUR=1'b1;
reg clk = 1'b0;
reg nRESET = 1'b1;
wire Phi2,cpu_clken;

//start simulation specific
initial begin
    #10 nRESET=1'b0;
	#1 PUR=1'b0;
	#50 PUR=1'b1;
    #70 nRESET = 1'b1;	
  end
 
always #1 clk <= ~clk;
//end simulation specific

clock cpu_clk1(
    .clk(clk),
    .rst_n(nRESET),
	.Phi2(Phi2),
    .cpu_clken(cpu_clken)
    );

//CPU 6502
wire [15:0] A;
wire r_w;
wire [7:0] cpudata_in,cpudata_out;

arlet_6502 my_cpu(
    .clk    (clk),
    .enable (cpu_clken),
    .rst_n  (nRESET),
    .ab     (A),
    .dbi    (cpudata_in),
    .dbo    (cpudata_out),
    .we     (r_w),
    .irq_n  (1'b1),
    .nmi_n  (1'b1),
    .ready  (cpu_clken),
    .pc_monitor ()
    );

//end of CPU 6502  
//start of ROM
wire [7:0] romdata_out;

rom2716_mrw mrw1(
	.addr(A[10:0]),
	.clk(clk),
	.q(romdata_out)
    );

//end of ROM
//start of Address muxing
wire rom_mrw_cs = (A[15] == 1'b1);

assign cpudata_in = rom_mrw_cs ? romdata_out :
			 8'h00;

//end of Address muxing
endmodule 