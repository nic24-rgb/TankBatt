module rom2716_a
(
	input [10:0] addr,
	input clk, 
	output reg [7:0] q
);

	// Declare the ROM variable
	reg [7:0] rom[2047:0];

	initial
	begin
		$readmemh("rom1a.txt", rom);
	end

	always @ (posedge clk)
	begin
		q <= rom[addr];
	end

	//assign q = rom[addr];

endmodule

module rom2716_b
(
	input [10:0] addr,
	input clk, 
	output reg [7:0] q // reg
);

	// Declare the ROM variable
	reg [7:0] rom[2047:0];

	initial
	begin
		$readmemh("rom1b.txt", rom);
	end

	always @ (posedge clk)
	begin
		q <= rom[addr];
	end

	//assign q = rom[addr];

endmodule

module rom2716_c
(
	input [10:0] addr,
	input clk, 
	output reg [7:0] q // reg
);

	// Declare the ROM variable
	reg [7:0] rom[2047:0];

	initial
	begin
		$readmemh("rom1c.txt", rom);
	end

	always @ (posedge clk)
	begin
		q <= rom[addr];
	end

	//assign q = rom[addr];

endmodule

module rom2716_d
(
	input [10:0] addr,
	input clk, 
	output reg [7:0] q // reg
);

	// Declare the ROM variable
	reg [7:0] rom[2047:0];

	initial
	begin
		$readmemh("rom1d.txt", rom);
	end

	always @ (posedge clk)
	begin
		q <= rom[addr];
	end

	//assign q = rom[addr];

endmodule

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
