module Tankb_fpga(
	input FPGA_CLK1_50,
	input BTN_RESET,
	output VGA_HS,
	output VGA_VS,
	output	[5:0]VGA_R,
	output	[5:0]VGA_G,
	output	[5:0]VGA_B
);
//wire & reg setup
wire clk;
wire nRESET = BTN_RESET;
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
//end wire & reg setup 
//start of clk pll

clk_pll clk1(
		.refclk(FPGA_CLK1_50),   //  refclk.clk
		.rst(~nRESET),      //   reset.reset
		.outclk_0(clk)  // outclk0.clk
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
    .q1(VBLANK),
    .n_q1(),
    .q2(nIRQ),
    .n_q2()
  );  

//end vblank
//start of pixel definition

wire RED = (H16 & V16 & nH256 & VBLANK);
wire GREEN = (H8 & V8 & nH256 & VBLANK);
wire BLUE = (H32 & V32 & nH256 & VBLANK);

assign VGA_R = {6{RED}};
assign VGA_G = {6{GREEN}};
assign VGA_B = {6{BLUE}};
//assign VGA_HS = nCOMPSYNC;
assign VGA_HS = ~nHSYNC;
assign VGA_VS = ~nVSYNC;

//end of pixel definition

endmodule 