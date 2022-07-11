module Top(
	input FPGA_CLK1_50
	//output VGA_HS,
	//output VGA_VS,
	//output	[5:0]VGA_R,
	//output	[5:0]VGA_G,
	//output	[5:0]VGA_B
	//input BTN_RESET
	//input BTN_OSD,
	//input BTN_USER,
	//input [4:0] BUTTONS
);

wire clk;

clk_pll clk1(
		.refclk(FPGA_CLK1_50),
		.rst(),      //removed ~nRESET for power-on reset
		.outclk_0(clk)
	);

Tankb_fpga tank1(
	.CLK18(clk)
	//output VGA_HS,
	//output VGA_VS,
	//output	[5:0]VGA_R,
	//output	[5:0]VGA_G,
	//output	[5:0]VGA_B
	//input BTN_RESET
	//input BTN_OSD,
	//input BTN_USER,
	//input [4:0] BUTTONS
);

endmodule
