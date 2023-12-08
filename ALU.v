`timescale 1ns / 1ps

module alu(
  input [11:0] A,B,  // ALU 16-bit Inputs
  input [3:0] ALU_Sel,// ALU Selection
  output [11:0] ALU_Out // ALU 16-bit Output
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
        4'b0101: // Not
           ALU_Result = ~A;
        default: ALU_Result = 0;
        endcase
    end

endmodule
