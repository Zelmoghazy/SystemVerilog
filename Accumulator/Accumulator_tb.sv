module tb_accum;

  // Constants
  parameter CLK_PERIOD = 10; // Clock period in time units
  
  // Inputs
  logic clk;
  logic reset;
  logic [31:0] amt;
  
  // Outputs
  logic [31:0] sum;
  
  // Instantiate the module under test
  accum u_accum (
    .clk(clk),
    .reset(reset),
    .amt(amt),
    .sum(sum)
  );
  
  // Clock generation
  always #((CLK_PERIOD / 2)) clk = ~clk;
  
  // Test stimulus
  initial begin
    clk = 0;
    reset = 1;
    amt = 0;
    #20;
    reset = 0;
    #20;
    
    // Start VCD dumping
    $dumpfile("tb_accum.vcd");
    $dumpvars(0, tb_accum);
  end
  
  // Test with random values
  initial begin
    #30;
    reset = 0;
    repeat (3) begin
      amt = 1;
      #30;
    end
    reset=1;
    repeat (3) begin
      amt = 1;
      #30;
    end
    reset = 0;
    repeat (3) begin
      amt = 1;
      #30;
    end
    $finish;
  end

endmodule
