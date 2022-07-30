module rom2716_DP
(
	input [7:0] data_a, data_b,
	input [10:0] addr_a, addr_b,
	input we_a, we_b, clk,
	output reg [7:0] q_a, q_b
);

	// Declare the RAM variable
	reg [7:0] rom[2047:0];
	
	// Port A ROM READ
	always @ (posedge clk)
	begin
		if (we_a) //!
		begin
			rom[addr_a] <= data_a;
			q_a <= data_a;
		end
		else 
		begin
			q_a <= rom[addr_a];
		end 
	end 

	// Port B ROM PROGRAM
	always @ (posedge clk)
	begin
		if (we_b) //
		begin
			rom[addr_b] <= data_b;
			q_b <= data_b;
		end
		else 
		begin
			q_b <= rom[addr_b];
		end 
	end

endmodule

module prom7052_DP
(
	input [7:0] data_a, data_b,
	input [7:0] addr_a, addr_b,
	input we_a, we_b, clk,
	output reg [7:0] q_a, q_b
);

	// Declare the RAM variable
	reg [7:0] rom[255:0];
	
	// Port A ROM READ
	always @ (posedge clk)
	begin
		if (we_a) //!
		begin
			rom[addr_a] <= data_a;
			q_a <= data_a;
		end
		else 
		begin
			q_a <= rom[addr_a];
		end 
	end 

	// Port B ROM PROGRAM
	always @ (posedge clk)
	begin
		if (we_b) //
		begin
			rom[addr_b] <= data_b;
			q_b <= data_b;
		end
		else 
		begin
			q_b <= rom[addr_b];
		end 
	end

endmodule

