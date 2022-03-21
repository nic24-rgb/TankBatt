module ram2114
(
	input [7:0] data,
	input [10:0] addr,
	input we,clk,
	output [7:0] q
);

	reg [7:0] ram[2047:0];

	reg [10:0] addr_reg;

//RAM initialization Option 1 - Fill
	initial 
	begin : INIT
		integer i;
		for(i = 0; i < 2048; i = i + 1)
			ram[i] = {8{1'b0}};
	end 
//
//RAM initialization Option 2 - File load
//	initial
//	begin
//		$readmemh("ram_file.txt", ram);
//	end
//

	always @ (posedge clk)
	begin
		// Write
		if (!we)
			ram[addr] <= data;

		addr_reg <= addr;
	end

	assign q = ram[addr_reg];

endmodule

module ram2114_DP
(
	input [7:0] data_a, data_b,
	input [10:0] addr_a, addr_b,
	input we_a, we_b, clk,
	output reg [7:0] q_a, q_b
);

	// Declare the RAM variable
	reg [7:0] ram[2047:0];
	
//RAM initialization Option 1 - Fill
	initial 
	begin : INIT
		integer i;
		for(i = 0; i < 2048; i = i + 1)
			ram[i] = {8{1'b0}};
	end 
//
//RAM initialization Option 2 - File load
//	initial
//	begin
//		$readmemh("ram_file.txt", ram);
//	end
//

	// Port A 
	always @ (posedge clk)
	begin
		if (!we_a) 
		begin
			ram[addr_a] <= data_a;
			q_a <= data_a;
		end
		else 
		begin
			q_a <= ram[addr_a];
		end 
	end 

	// Port B 
	always @ (posedge clk)
	begin
		if (!we_b) 
		begin
			ram[addr_b] <= data_b;
			q_b <= data_b;
		end
		else 
		begin
			q_b <= ram[addr_b];
		end 
	end

endmodule
