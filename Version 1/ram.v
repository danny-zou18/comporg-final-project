`timescale 1 ns / 1 ps

module single_port_sync_ram
  #(
    parameter ADDR_WIDTH = 13,
    parameter DATA_WIDTH = 8,
    parameter LENGTH = (1 << ADDR_WIDTH)
  )
  (
    input clk,
    input [ADDR_WIDTH-1:0] addr,
    inout [DATA_WIDTH-1:0] data,
    input cs,
    input we,
    input oe
  );

  reg [DATA_WIDTH-1:0] tmp_data;
  reg [DATA_WIDTH-1:0] mem[LENGTH];

  always @ (posedge clk) begin
    if (cs & we) begin
      mem[addr] <= data; // Write to memory using direct address
    end
  end
  
  always @ (negedge clk) begin
    if (cs & !we) begin
      tmp_data <= mem[addr]; // Read from memory using direct address
    end
  end

  assign data = cs & oe & !we ? tmp_data : 'hz;

endmodule