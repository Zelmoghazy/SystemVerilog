// Code your design here
module my_diff(q,d,clk,rst_l); 
  input d,clk,rst_l;
  output q;
  
  wire d,clk,rst_l;
  reg q;
  
  
  always @ (posedge clk)
    begin
      if(rst_l == 1'b0) begin
        q <= 1'b0;
      end
      else q<=d;
    end
  endmodule;