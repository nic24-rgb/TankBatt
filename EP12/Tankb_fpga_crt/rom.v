module rom2716_cs
(
	input [10:0] addr,
	input clk,
	input n_cs, 
	output reg [7:0] q
);

	// Declare the ROM variable
	reg [7:0] rom[2047:0];

	initial
	begin
		$readmemh("rom2k.txt", rom);
	end

	always @ (posedge clk)
	begin
		if (!n_cs) begin
			q <= rom[addr];
		end
	end

endmodule

module prom7052_cs
(
	input [7:0] addr,
	input clk,n_cs, 
	output reg [3:0] q
);

	// Declare the ROM variable
	reg [3:0] rom[255:0];

	initial
	begin
		$readmemh("prom3l.txt", rom);
	end

	always @ (posedge clk)
	begin
		if (!n_cs) begin
			q <= rom[addr];
		end
	end

endmodule

module rom2716_mrw
(
	input [10:0] addr,
	input clk,
	//input n_cs, 
	output reg [7:0] q
);

	// Declare the ROM variable
	reg [7:0] rom[2047:0];

	initial
	begin
		$readmemh("screen_rom_ram_write.txt", rom);
	end

	always @ (posedge clk)
	begin
		//if (!n_cs) begin
			q <= rom[addr];
		//end
	end

endmodule
