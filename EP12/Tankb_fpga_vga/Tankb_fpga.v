module Tankb_fpga(
	input FPGA_CLK1_50,
	//input BTN_RESET,	
	output VGA_HS,
	output VGA_VS,
	output	[5:0]VGA_R,
	output	[5:0]VGA_G,
	output	[5:0]VGA_B
);

//power-on reset
reg [5:0] reset_cnt = 0;
wire nRESET = &reset_cnt;
always @(posedge clk) begin
    reset_cnt <= reset_cnt + !nRESET;
end
//end power-on reset
//wire & reg setup
wire clk;
//wire nRESET = BTN_RESET;
wire PUR = nRESET;

wire A5_1_nq,A6_1_q,A6_1_nq,A6_2_q,A6_2_nq;
wire H1,H2,H4,H8,H16,H32,H64,H128,nH256;
wire A5_2_d=(~H64 & H32);
wire H256=~nH256;
wire B6_ca,C6_ca,E6_ca,D6_ca;
wire nHSYNC;
wire M6Hz=~A6_2_q;
wire nM6PRI=A6_1_nq;//schematics?
wire D5_2_nq;
wire Phi=H4;
wire nH4_nH8=(~H4 & ~H8);
wire V1,V2,V4,V8,V16,V32,V64,V128,nVSYNC;
wire H256star,nH256star;
wire nCOMPSYNC=(nHSYNC & nVSYNC);
wire nINTACK,nIRQ,VBLANK;
wire F5_1_d=~(V128 & V64 & V32);
wire [7:0] L2_q,K2_d;
wire J2_q;
wire [5:0] J3_q;
wire BLUE,GREEN,RED,RBG2;
wire E5_14=!(H4 & H2 & H1);
wire [3:0] D4_2_y;
wire C4_11=(D4_2_y[2] & D4_2_y[0]);
wire [3:0] B2_y,C2_y,B3_y;
wire [11:0] VA;
wire [7:0] MRW1_q;
//new wire & reg
wire Phi2=Phi;
//end wire & reg setup 

//start of clk pll

clk_pll clk1(
		.refclk(FPGA_CLK1_50),
		.rst(),      //removed ~nRESET for power-on reset
		.outclk_0(clk)
	);

//enb of clk pll
//start horizontal timer
   ls107 icA6_1(
    .clear(PUR), 
    .clk(~clk),
    .j(A6_2_nq),
    .k(PUR),
    .q(A6_1_q),
    .qnot(A6_1_nq)
   );

   ls107 icA6_2(
    .clear(PUR), 
    .clk(~clk),
    .j(A6_1_q),
    .k(PUR),
    .q(A6_2_q),
    .qnot(A6_2_nq)
   );

   ls74 icA5(
    .n_pre1(PUR),
    .n_pre2(PUR),
    .n_clr1(PUR),
    .n_clr2(H256),
    .clk1(M6Hz),
    .clk2(H16),
    .d1(A5_1_nq),
    .d2(A5_2_d),
    .q1(H1),
    .n_q1(A5_1_nq),
    .q2(),
    .n_q2(nHSYNC)
   );

   ls161 icB6(
    .n_clr(PUR),
    .clk(M6Hz),
    .din(4'b0),
    .enp(H1), 
    .ent(H1),
    .n_load(PUR),
    .q({H16,H8,H4,H2}),
    .rco(B6_ca)
   );

   ls161 icC6(
    .n_clr(PUR),
    .clk(M6Hz),
    .din(4'b0100),
    .enp(B6_ca), 
    .ent(B6_ca),
    .n_load(~C6_ca),
    .q({nH256,H128,H64,H32}),
    .rco(C6_ca)
   );
//end horizontal timer

//start vertical timer

   ls74 icD5(
    .n_pre1(PUR),
    .n_pre2(PUR),
    .n_clr1(PUR),
    .n_clr2(PUR),
    .clk1(H8),
    .clk2(nHSYNC),
    .d1(H256),
    .d2(D5_2_nq),
    .q1(H256star),
    .n_q1(nH256star),
    .q2(V1),
    .n_q2(D5_2_nq)
   );  

   ls161 icD6(
    .n_clr(PUR),
    .clk(nHSYNC),
    .din(4'b1100),
    .enp(V1), 
    .ent(V1),
    .n_load(~E6_ca),
    .q({V16,V8,V4,V2}),
    .rco(D6_ca)
   );

   ls161 icE6(
    .n_clr(PUR),
    .clk(nHSYNC),
    .din(4'b0111),
    .enp(D6_ca), 
    .ent(D6_ca),
    .n_load(~E6_ca),
    .q({nVSYNC,V128,V64,V32}),
    .rco(E6_ca)
   );

//end vertical timer
//vblank

   ls74 icF5(
    .n_pre1(PUR),
    .n_pre2(nINTACK),
    .n_clr1(PUR),
    .n_clr2(PUR),
    .clk1(V16),
    .clk2(V16),
    .d1(F5_1_d),
    .d2(1'b0),
    .q1(),
    .n_q1(VBLANK),
    .q2(nIRQ),
    .n_q2()
  );  

//end vblank
//start screen render 3

   ls273 icL2(
	.d(MRW1_q),
	.clk(H4),
	.res(PUR),
	.q(L2_q)
   );

   rom2716_cs K2(
	.addr({L2_q,V4,V2,V1}),
	.clk(clk),
	.n_cs(1'b0),//!nPhi2
	.q(K2_d)
   );

   ls166 icJ2(
    .clk(M6Hz),
    .load(C4_11),
    .in(K2_d),
    .out(J2_q)
   );

//end of screen render 3
//start of screen render 4

   ls174 icJ3(
	.d(L2_q[7:2]),
	.clk(C4_11),
	.mr(PUR),
	.q(J3_q)
   );

   prom7052_cs icL3(
	.addr({J3_q[5:0],1'b0,J2_q}),
	.clk(clk),
	.n_cs(VBLANK),
	.q({BLUE,GREEN,RED,RBG2})
   );

//end of screen render 4
//screen render 1a

   ls139 icD4_2(
    .a(H256),
    .b(H256star),
    .n_g(E5_14),
    .y(D4_2_y)
  );

//end of screen render 1a
//start of address buffers
wire C4_3=(1'b1 & H256);//nPhi2 - 1'b1

   ls157 icB2(
	.i0({4{1'b0}}),
	.i1({PUR,1'b0,V128,V64}),
	.n_e(C4_3),//1'b0
	.s(1'b1),
	.z(B2_y)
  );

assign VA[11]=B2_y[3];
assign VA[10]=B2_y[2];
assign VA[9]=B2_y[1];
assign VA[8]=B2_y[0];

   ls157 icC2(
	.i0({4{1'b0}}),
	.i1({V32,V16,V8,H128}),
	.n_e(C4_3),//
	.s(1'b1),
	.z(C2_y)
  );

assign VA[7]=C2_y[3];
assign VA[6]=C2_y[2];
assign VA[5]=C2_y[1];
assign VA[4]=C2_y[0];

   ls157 icB3(
	.i0({4{1'b0}}),
	.i1({H64,H32,H16,H8}),
	.n_e(1'b0),
	.s(1'b1),
	.z(B3_y)
  );

assign VA[3]=B3_y[3];
assign VA[2]=B3_y[2];
assign VA[1]=B3_y[1];
assign VA[0]=B3_y[0];

//end of address buffers
//start of video out

  assign VGA_R = {6{RED}};
  assign VGA_G = {6{GREEN}};
  assign VGA_B = {6{BLUE}};
  assign VGA_HS = ~nHSYNC;
  assign VGA_VS = ~nVSYNC;
  
//end of video out
//start of cpuclk
wire cpu_clken;
clock cpu_clk1(
    .clk(clk),
    .rst_n(nRESET),
	.Phi2(Phi2),
    .cpu_clken(cpu_clken)
    );
//end of cpuclk
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
//start of RAM
wire [7:0] ramdata_out;

ram2114_DP mrw2(
	.data_a(cpudata_out),
	.data_b(),
	.addr_a(A[10:0]),
	.addr_b(VA[10:0]),
	.we_a(r_w),
	.we_b(1'b1),//ensure not blank
	.clk(clk),
	.q_a(ramdata_out),
	.q_b(MRW1_q)
	);
//end of RAM
//start of Address muxing
wire rom_mrw_cs = (A[15] == 1'b1);
wire ram_cs = (A[15:11] == 5'b00001);

assign cpudata_in = rom_mrw_cs ? romdata_out :
					ram_cs ? ramdata_out :
					8'h00;

//end of Address muxing

endmodule 