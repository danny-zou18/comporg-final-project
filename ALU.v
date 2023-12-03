module SimpleProcessor(
    input wire clk,        // Clock input
    input wire rst,        // Reset input
    input wire [3:0] opcode, // Opcode input
    input wire [3:0] operandA, // Operand A input
    input wire [3:0] operandB, // Operand B input
    output reg [3:0] result // Result output
);

// Internal registers
reg [3:0] regA, regB;

// Control signals
wire writeEnable; // Signal to enable writing to registers

// ALU (Arithmetic Logic Unit)
always @(*)
begin
    case(opcode)
        4'b0000: result = regA + regB; // Addition
        4'b0001: result = regA - regB; // Subtraction
        4'b0010: result = regA & regB; // Bitwise AND
        4'b0011: result = regA | regB; // Bitwise OR
        // Add more operations as needed...
        default: result = 4'b0000; // Default to 0 if opcode is invalid
    endcase
end

// Register File
always @(posedge clk or posedge rst)
begin
    if(rst) begin
        regA <= 4'b0000; // Reset register A
        regB <= 4'b0000; // Reset register B
    end
    else if(writeEnable) begin
        regA <= operandA; // Load operand A to register A
        regB <= operandB; // Load operand B to register B
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
