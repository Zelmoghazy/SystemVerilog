module accum(input wire [31:0] amt,clk,reset,output reg [31:0] sum);
  reg [31:0] register;
  
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      register <= 0;
      sum <= 0;
    end else begin
      register <= register + amt;
    end
  end
      
  always @(negedge clk) begin
    if(!reset)
        sum <= register;
  end
endmodule