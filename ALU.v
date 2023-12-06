`timescale 1ns / 1ps

module alu(
  input [12:0] A,B,  // ALU 16-bit Inputs
  input [3:0] ALU_Sel,// ALU Selection
  output [12:0] ALU_Out // ALU 16-bit Output
);

  reg [12:0] ALU_Result;
  wire [12:0] tmp;
    assign ALU_Out = ALU_Result; // ALU out
    always @(*)
    begin
        case(ALU_Sel)
        4'b0001: // Addition
           ALU_Result = A + B ;
        4'b0010: // Subtraction
           ALU_Result = A - B ;
        4'b0011: // And
          	ALU_Result = A & B;
        4'b0100: // Or
          	ALU_Result = A | B;
        4'b0101: // Clear
           ALU_Result = 0;
        default: ALU_Result = 0;
        endcase
    end

endmodule

// Register File
always @(posedge clk or posedge rst)
begin
    if(rst) begin
        A <= 4'b0000; // Reset register A
        B <= 4'b0000; // Reset register B
    end
end

// Control Logic
always @(*)
begin
    case(opcode)
        4'b0000, 4'b0001, 4'b0010, 4'b0011: writeEnable = 1; // Enable register write for supported operations
        default: writeEnable = 0; // Disable register write for unsupported operations
    endcase
end

endmodule
