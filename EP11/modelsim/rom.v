module rom2716_mrw
(
	input [10:0] addr,
	input clk, 
	output reg [7:0] q // reg
);

	// Declare the ROM variable
	reg [7:0] rom[2047:0];

	initial
	begin
		$readmemh("screen_rom_ram_read.txt", rom);
	end

	always @ (posedge clk)
	begin
		q <= rom[addr];
	end

	//assign q = rom[addr];

endmodule
