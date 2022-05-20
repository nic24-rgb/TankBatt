//
// scandoubler.v - modified
// 
module scandoubler
(
	input            clk_sys,
	input            hs_in,
	input            vs_in,
	input      [5:0] r_in,
	input      [5:0] g_in,
	input      [5:0] b_in,
	output reg       hs_out,
	output reg       vs_out,
	output reg [5:0] r_out,
	output reg [5:0] g_out,
	output reg [5:0] b_out
);

//end new input/output define

parameter HCNT_WIDTH = 10;
parameter COLOR_DEPTH = 6;

wire HSync = hs_in;
wire VSync = vs_in;
reg [1:0] scanlines = 2'b00;
reg ce_divider = 1'b1;
reg [1:0] i_div;
reg ce_x1, ce_x2;

always @(posedge clk_sys) begin
	reg last_hs_in;
	last_hs_in <= HSync;
	if(last_hs_in & !HSync) begin
		i_div <= 2'b00;
	end else begin
		i_div <= i_div + 2'd1;
	end
end

always @(*) begin
	if (!ce_divider) begin
		ce_x1 = (i_div == 2'b01);
		ce_x2 = i_div[0];
	end else begin 
		ce_x1 = i_div[0];
		ce_x2 = 1'b1;
	end
end

// --------------------- create output signals -----------------
// latch everything once more to make it glitch free and apply scanline effect
reg scanline;
reg [5:0] r;
reg [5:0] g;
reg [5:0] b;

always @(*) begin
	if (COLOR_DEPTH == 6) begin 
		b = sd_out[5:0];
		g = sd_out[11:6];
		r = sd_out[17:12];
	end
end

always @(posedge clk_sys) begin
	if(ce_x2) begin
		hs_out <= hs_sd;
		vs_out <= vs_in;

		// reset scanlines at every new screen
		if(vs_out != vs_in) scanline <= 0;

		// toggle scanlines at begin of every hsync
		if(hs_out && !hs_sd) scanline <= !scanline;

		// if no scanlines or not a scanline
		if(!scanline || !scanlines) begin //this should be the one used
			r_out <= r;
			g_out <= g;
			b_out <= b;
		end
	end
end

// scan doubler output register
reg [COLOR_DEPTH*3-1:0] sd_out;

// ==================================================================
// ======================== the line buffers ========================
// ==================================================================

// 2 lines of 2**HCNT_WIDTH pixels 3*COLOR_DEPTH bit RGB
(* ramstyle = "no_rw_check" *) reg [COLOR_DEPTH*3-1:0] sd_buffer[2*2**HCNT_WIDTH];//defines sd_buffer

// use alternating sd_buffers when storing/reading data   
reg        line_toggle;//line_toggle

// total hsync time (in 16MHz cycles), hs_total reaches 1024
reg  [HCNT_WIDTH-1:0] hs_max;
reg  [HCNT_WIDTH-1:0] hs_rise;
reg  [HCNT_WIDTH-1:0] hcnt;

always @(posedge clk_sys) begin
	reg hsD, vsD;

	if(ce_x1) begin
		hsD <= hs_in;

		// falling edge of hsync indicates start of line
		if(hsD && !hs_in) begin
			hs_max <= hcnt;
			hcnt <= 0;
		end else begin
			hcnt <= hcnt + 1'd1;
		end

		// save position of rising edge
		if(!hsD && hs_in) hs_rise <= hcnt;

		vsD <= vs_in;
		if(vsD != vs_in) line_toggle <= 0;

		// begin of incoming hsync
		if(hsD && !hs_in) line_toggle <= !line_toggle;

		sd_buffer[{line_toggle, hcnt}] <= {r_in, g_in, b_in};
	end
end

// ==================================================================
// ==================== output timing generation ====================
// ==================================================================

reg  [HCNT_WIDTH-1:0] sd_hcnt;//defines sd_hcnt
reg        hs_sd;

// timing generation runs 32 MHz (twice the input signal analysis speed)
always @(posedge clk_sys) begin
	reg hsD;

	if(ce_x2) begin
		hsD <= hs_in;

		// output counter synchronous to input and at twice the rate
		sd_hcnt <= sd_hcnt + 1'd1;
		if(hsD && !hs_in)     sd_hcnt <= hs_max;
		if(sd_hcnt == hs_max) sd_hcnt <= 0;

		// replicate horizontal sync at twice the speed
		if(sd_hcnt == hs_max)  hs_sd <= 0;
		if(sd_hcnt == hs_rise) hs_sd <= 1;

		// read data from line sd_buffer
		sd_out <= sd_buffer[{~line_toggle, sd_hcnt}];//defines sd_out
	end
end

endmodule
