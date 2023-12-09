`timescale 1 ns / 1 ps

module test_cpu;
  parameter ADDR_WIDTH = 15;
  parameter DATA_WIDTH = 16;
  
  reg osc;
  localparam period = 21;

  wire clk; 
  assign clk = osc; 
  reg halt_flag = 0; // Flag for halt
  reg cs; //
  reg we; // 
  reg oe;
  integer i; 
  reg [ADDR_WIDTH-1:0] MAR;
  wire [DATA_WIDTH-1:0] data;
  reg [DATA_WIDTH-1:0] testbench_data;
  assign data = !oe ? testbench_data : 'hz;

  single_port_sync_ram_large  #(.DATA_WIDTH(DATA_WIDTH)) ram
  (   .clk(clk),
   	.addr(MAR),
      .data(data[DATA_WIDTH-1:0]),
      .cs_input(cs),
      .we(we),
      .oe(oe)
  );
  
  // ALU section
  reg [11:0] A;
  reg [11:0] B;
  reg [11:0] ALU_Out;
  reg [3:0] ALU_Sel;
  alu alu16(
    .A(A),
    .B(B),  // ALU 16-bit Inputs
    .ALU_Sel(ALU_Sel),// ALU Selection
    .ALU_Out(ALU_Out) // ALU 16-bit Output
     );
  
  
  reg [15:0] PC = 'h100;
  reg [15:0] IR = 'h0;
  reg [15:0] MBR = 'h0;
  reg [15:0] AC = 'h0;

  
  // Clock wave
  initial osc = 1;  //init clk = 1 for positive-edge triggered
  always begin
    if (halt_flag == 0) begin
    #period osc = ~osc;
  end else begin
    osc = 0; // Stop the clock when halted.
    #20 $finish;
  end
end


  initial begin
   
     $dumpfile("dump.vcd");
     $dumpvars;
    // Fib program
    @(posedge clk) MAR <= 'h100; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h1120;
    @(posedge clk) MAR <= 'h102; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h212A;
    @(posedge clk) MAR <= 'h104; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h1122;
    @(posedge clk) MAR <= 'h106; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h2123;
    @(posedge clk) MAR <= 'h108; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h1124;
    @(posedge clk) MAR <= 'h10A; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h2122;
    @(posedge clk) MAR <= 'h10C; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h312a;
    @(posedge clk) MAR <= 'h10E; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h2124;
    @(posedge clk) MAR <= 'h110; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h1122;
    
    @(posedge clk) MAR <= 'h112; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h212a;
    @(posedge clk) MAR <= 'h114; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h1126;
    @(posedge clk) MAR <= 'h116; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h3128;
    @(posedge clk) MAR <= 'h118; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h2126;
    @(posedge clk) MAR <= 'h11A; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h9100;

    @(posedge clk) MAR <= 'h11C; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'hA108;
    @(posedge clk) MAR <= 'h12C; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h112a;
    @(posedge clk) MAR <= 'h11E; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'hFFFF;

    @(posedge clk) MAR <= 'h120; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h0000;
    @(posedge clk) MAR <= 'h122; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h0001;
    @(posedge clk) MAR <= 'h124; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h0001;
    @(posedge clk) MAR <= 'h126; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h000A;
    @(posedge clk) MAR <= 'h128; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h0FFF;
    @(posedge clk) MAR <= 'h12A; we <= 1; cs <= 1; oe <= 0; testbench_data <= 'h0000;
    
    
    @(posedge clk) PC <= 'h100;
    
    for (i = 0; i < 62; i = i+1) begin
          // Fetch
          @(posedge clk) MAR <= PC; we <= 0; cs <= 1; oe <= 1;
          @(posedge clk) IR <= data;
          @(posedge clk) PC <= PC + 1;
          // Decode and execute
      case(IR[15:12])
        4'b0001: begin // Load
              @(posedge clk) MAR <= IR[11:0];
              @(posedge clk) MBR <= data;
              @(posedge clk) AC <= MBR;
        end 
		    4'b0010: begin // Store
              @(posedge clk) MAR <= IR[11:0];
              @(posedge clk) MBR <= AC;
              @(posedge clk) we <= 1; oe <= 0; testbench_data <= MBR;      
        end
        4'b0011: begin // Add
              @(posedge clk) MAR <= IR[11:0];
              @(posedge clk) MBR <= data;
          	  @(posedge clk) ALU_Sel <= 'b0001; A <= AC; B <= MBR;
              @(posedge clk) AC <= ALU_Out;
        end
        
        //Extra credit functions
        4'b0100: begin // Subtract
              @(posedge clk) MAR <= IR[11:0];
              @(posedge clk) MBR <= data;
          	  @(posedge clk) ALU_Sel <= 'b0010; A <= AC; B <= MBR;
              @(posedge clk) AC <= ALU_Out;
        end
        4'b0101: begin // And
              @(posedge clk) MAR <= IR[11:0];
              @(posedge clk) MBR <= data;
              @(posedge clk) ALU_Sel <= 'b0011; A <= AC; B <= MBR;
              @(posedge clk) AC <= ALU_Out;
        end
        4'b0110: begin // Or
              @(posedge clk) MAR <= IR[11:0];
              @(posedge clk) MBR <= data;
              @(posedge clk) ALU_Sel <= 'b0100; A <= AC; B <= MBR;
              @(posedge clk) AC <= ALU_Out;
        end
        4'b1111: begin // Not
              @(posedge clk) MAR <= IR[11:0];
              @(posedge clk) MBR <= data;
          	  @(posedge clk) ALU_Sel <= 'b0101; A <= AC; B <= MBR;
              @(posedge clk) AC <= ALU_Out;
        end
        //End of extra credit functions
        
        
        4'b1000: begin // Back
              @(posedge clk) PC <= PC - 1;
        end
        4'b1001: begin // Skip
          @(posedge clk)
          if(IR[11:10]==2'b01 && AC == 0) PC <= PC + 1;
          else if(IR[11:10]==2'b00 && AC < 0) PC <= PC + 1;
          else if(IR[11:10]==2'b10 && AC > 0) PC <= PC + 1;
        end
        4'b1010: begin // Jump
              @(posedge clk) PC <= IR[11:0];
        end
        4'b1011: begin // Clear
          @(posedge clk) AC <= 0;
        end
        4'b1110: begin // Halt
          @(posedge clk) halt_flag <= 1;
        end
      endcase
         
    end
    
      
    @(posedge clk) MAR <= 'h10D; we <= 0; cs <= 1; oe <= 1;
    
    @(posedge clk)
        
   #20 $finish;
  end

endmodule
