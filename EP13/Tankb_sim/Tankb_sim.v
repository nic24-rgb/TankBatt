module Tankb_sim;

reg PUR=1'b1;
reg clk = 1'b0;
reg nRESET = 1'b1;
//reg [15:0] ADDRESS = 16'h0000;
//wire [15:0] A = ADDRESS;
//assign A = ADDRESS;
//reg r_w = 1'b1;

//start simulation specific
initial begin
  #10 nRESET=1'b0;
  #1 PUR=1'b0;
  #50 PUR=1'b1;
  #70 nRESET = 1'b1;	
  end
 
always #1 clk <= ~clk;
//end simulation specific

//wire & reg setup
//wire clk;
//wire PUR = nRESET;
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
//new wire & reg
wire Phi2=Phi;
wire [15:0] A;
wire r_w;
//end wire & reg setup 

//start of clk pll

//clk_pll clk1(
//		.refclk(FPGA_CLK1_50),
//		.rst(),      //removed ~nRESET for power-on reset
//		.outclk_0(clk)
//	);

//end of clk pll

////wires
wire nDIPSW,F4_o9,F4_o8,F4_o6,nIN1,nIN0,nWDR,nOUT1,nOUT0;
wire [7:0] rom1a_dout,rom1b_dout,rom1c_dout,rom1d_dout;
wire [7:0] ram1e1j_dout,ram1f1k_dout,ram1h1l_dout,vram_dout,bullet_dout;
wire [7:0]DIP = 8'b11111111;
wire [7:0]IN1 = 8'b11111111;
wire [7:0]IN0 = 8'b11111111;
wire DIP_Y,IN1_Y,IN0_Y;

//start of address decoding

//assign nROM=!(Phi2 & A[13]);
wire nPhi2,nWO,C4_6,nROM;
assign nROM=!A[13];//temporary replacement for above
wire [3:0] C3_1_y;

   ls139 icC3_1(
    .a(A[11]),
    .b(A[12]),
    .n_g(nROM),
    .y(C3_1_y)
  );

wire nROM_A1_cs = C3_1_y[0];
wire nROM_B1_cs = C3_1_y[1];
wire nROM_C1_cs = C3_1_y[2];
wire nROM_D1_cs = C3_1_y[3];


wire [3:0] C3_2_y,D4_1_y;
assign nPhi2=~Phi2;
//assign E4_3=!(nROM & H2);
//assign C4_6=(E4_3 & C3_2_y[1]);
assign C4_6=(!nROM & C3_2_y[1]);

   ls139 icC3_2(
    .a(r_w),
    .b(1'b0),//nPhi2
    .n_g(A[13]),
    .y(C3_2_y)
  );
  
assign nWO=C3_2_y[0];

   ls139 icD4_1(
    .a(A[10]),//AB
    .b(A[11]),//AB
    .n_g(C4_6),
    .y(D4_1_y)
  );

wire nVRAM=D4_1_y[2];
wire nWRAM1=D4_1_y[1];
wire nWRAM0=D4_1_y[0];

   ls42 icF4(
    .in({D4_1_y[3],nWO,A[4],A[3]}),//AB
  	 .out({F4_o9,F4_o8,nDIPSW,F4_o6,nIN1,nIN0,nWDR,nINTACK,nOUT1,nOUT0})
   );

//end address decode

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

wire [7:0] dsp_din;

   ls273 icL2(
	.d(dsp_din),
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
  assign VGA_HS = nCOMPSYNC;
  
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

wire [7:0] cpudata_in,cpudata_out;

arlet_6502 my_cpu(
    .clk    (clk),
    .enable (cpu_clken),
    .rst_n  (nRESET),
    .ab     (A),
    .dbi    (cpudata_in),
    .dbo    (cpudata_out),
    .we     (r_w),
    .irq_n  (nIRQ),
    .nmi_n  (1'b1),
    .ready  (cpu_clken),
    .pc_monitor ()
    );

//end of CPU 6502  
//start of ROMs

   rom2716_a icA1(
	.addr(A[10:0]),//AB
	.clk(clk),
	.q(rom1a_dout)
   );

   rom2716_b icB1(
	.addr(A[10:0]),
	.clk(clk),
	.q(rom1b_dout)
   );

   rom2716_c icC1(
	.addr(A[10:0]),
	.clk(clk),
	.q(rom1c_dout)
   );

   rom2716_d icD1(
	.addr(A[10:0]),
	.clk(clk),
	.q(rom1d_dout)
   );

//end of ROMs
//start RAMs

	ram2114_DP icE1_J1( //a is cpu side, b is display side - WRAM0
	.data_a(cpudata_out),
	.data_b(),
	.addr_a(A[10:0]),
	.addr_b(VA[10:0]),
	.we_a(!nWO & !nWRAM0),//nWO
	.we_b(1'b0),
	.clk(clk),
	.q_a(ram1e1j_dout),
	.q_b(bullet_dout)
	);

   ram2114 icF1_K1( //WRAM1
	.data(cpudata_out),
	.addr(A[10:0]),
	.we(!nWO & !nWRAM1),//
	.clk(clk),
	.q(ram1f1k_dout) 
   );

	ram2114_DP icH1_L1( //a is cpu side, b is display side
	.data_a(cpudata_out),
	.data_b(),
	.addr_a(A[10:0]),
	.addr_b(VA[10:0]),
	.we_a(!nWO & !nVRAM),//nWO
	.we_b(1'b0),
	.clk(clk),
	.q_a(ram1h1l_dout),
	.q_b(vram_dout)
);

//end RAMs
//start of Address muxing

assign cpudata_in = !nROM_A1_cs ? rom1a_dout :
		     !nROM_B1_cs ? rom1b_dout :
		     !nROM_C1_cs ? rom1c_dout :
		     !nROM_D1_cs ? rom1d_dout :
		     !nWRAM0 ? ram1e1j_dout :
		     !nWRAM1 ? ram1f1k_dout :
		     !nVRAM ? ram1h1l_dout :
			 !nDIPSW ? DIP : 
			 8'hFF;

wire nWRAM0_VA = (VA[11:4] == 8'b00000000);
wire nVRAM_VA = (VA[11:10] == 2'b10);

assign dsp_din = nWRAM0_VA ? bullet_dout :
				 nVRAM_VA ? vram_dout :
				 8'hFF;

//end of Address muxing

//initial
//  begin
//#10 nRESET=1'b0;
//#10 PUR=1'b0;
//#10 PUR=1'b1;
//#10 nRESET = 1'b1;
//#10 ADDRESS=16'h0400;
//#10 ADDRESS=16'h0800;
//#10 ADDRESS=16'h0C00;
//#10 ADDRESS=16'h0C08;
//#10 ADDRESS=16'h0C18;   
//#10 ADDRESS=16'h6000;
//#10 ADDRESS=16'h6800;
//#10 ADDRESS=16'h7000;
//#10 ADDRESS=16'h7800;
//#10 ADDRESS=16'hE000;
//#10 ADDRESS=16'hE800;
//#10 ADDRESS=16'hF000;
//#10 ADDRESS=16'hF800;
//#10 r_w=0;
//	ADDRESS=16'h0000;
//#10 ADDRESS=16'h0400;
//#10 ADDRESS=16'h0800;
//#10 ADDRESS=16'h0C00;
//#10 ADDRESS=16'h0C08;
//#10 ADDRESS=16'h0C10;
//#10 ADDRESS=16'h0C18;   
//#10 ADDRESS=16'h6000;
//#10 ADDRESS=16'h6800;
//#10 ADDRESS=16'h7000;
//#10 ADDRESS=16'h7800;
//#10 ADDRESS=16'hE000;
//#10 ADDRESS=16'hE800;
//#10 ADDRESS=16'hF000;
//#10 ADDRESS=16'hF800;
//#10 $finish;
//  end

endmodule 