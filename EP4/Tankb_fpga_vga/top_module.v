module top_module(
	input FPGA_CLK1_50,
	input BTN_RESET,
	output VGA_HS,
	output VGA_VS,
	output	[5:0]VGA_R,
	output	[5:0]VGA_G,
	output	[5:0]VGA_B
);

wire nRESET = BTN_RESET;
wire clk_32;

//PLL for clk_50 down to clk_32
scandubclk_pll clk1(
	.refclk(FPGA_CLK1_50),
	.rst(~nRESET),
	.outclk_0(clk_32)
	);

//instantiate tankb_fpga
wire hs,vs;
wire [5:0] r,g,b;

Tankb_fpga tank1(
	.FPGA_CLK1_50(FPGA_CLK1_50),
	.BTN_RESET(BTN_RESET),
	.VGA_HS(hs),
	.VGA_VS(vs),
	.VGA_R(r),
	.VGA_G(g),
	.VGA_B(b)
);

//instantiate scandoubler
scandoubler scandub1(
	.clk_sys(clk_32),
	.hs_in(hs),
	.vs_in(vs),
	.r_in(r),
	.g_in(g),
	.b_in(b),
	.hs_out(VGA_HS),
	.vs_out(VGA_VS),
	.r_out(VGA_R),
	.g_out(VGA_G),
	.b_out(VGA_B)
);

endmodule 