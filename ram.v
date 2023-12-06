`timescale 1 ns / 1 ps

module single_port_sync_ram_indirect
  #(
    parameter ADDR_WIDTH = 12,
    parameter DATA_WIDTH = 8,
    parameter LENGTH = (1 << ADDR_WIDTH)
  )
  (
    input clk,
    input [ADDR_WIDTH-1:0] addr,
    input [ADDR_WIDTH-1:0] indirect_addr, // New input for indirect addressing
    inout [DATA_WIDTH-1:0] data,
    input cs,
    input we,
    input oe
  );

  reg [DATA_WIDTH-1:0] tmp_data;
  reg [ADDR_WIDTH-1:0] indirect_reg; // Register to hold indirect address
  reg [DATA_WIDTH-1:0] mem[LENGTH];

  always @ (posedge clk) begin
    if (cs & we) begin
      if (indirect_addr != 'bx) begin // Check if indirect address is provided
        mem[indirect_addr] <= data; // Write to memory using indirect address
      end else begin
        mem[addr] <= data; // Write to memory using direct address
      end
    end
  end
  
  always @ (negedge clk) begin
    if (cs & !we) begin
      if (indirect_addr != 'bx) begin // Check if indirect address is provided
        tmp_data <= mem[indirect_addr]; // Read from memory using indirect address
      end else begin
        tmp_data <= mem[addr]; // Read from memory using direct address
      end
    end
  end

  assign data = cs & oe & !we ? tmp_data : 'hz;

endmodule
