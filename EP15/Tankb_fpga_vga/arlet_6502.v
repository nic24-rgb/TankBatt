module arlet_6502(
    input clk,                  // clock signal
    input enable,               // clock enable strobe
    input rst_n,                  // active high reset signal
    output reg [15:0] ab,       // address bus
    input [7:0] dbi,            // 8-bit data bus (input)
    output reg [7:0] dbo,       // 8-bit data bus (output)
    output reg we,              // active high write enable strobe
    input irq_n,                // active low interrupt request
    input nmi_n,                // active low non-maskable interrupt
    input ready,                // CPU updates when ready = 1
    output [15:0] pc_monitor    // program counter monitor signal for debugging
);

    wire [7:0] dbo_c;
    wire [15:0] ab_c;
    wire we_c;
	wire rst = ~rst_n;
	wire nmi = ~nmi_n;
	wire irq = ~irq_n;

    cpu arlet_cpu(
        .clk(clk),
        .reset(rst),
        .AB(ab_c),
        .DI(dbi),
        .DO(dbo_c),
        .WE(we_c),
        .IRQ(irq),
        .NMI(nmi),
        .RDY(ready),
        .PC_MONITOR(pc_monitor)
    );

    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            ab <= 16'd0;
            dbo <= 8'd0;
            we <= 1'b1;
        end
        else
            if (enable)
            begin
                ab <= ab_c;
                dbo <= dbo_c;
                we <= ~we_c;
            end
    end
endmodule
