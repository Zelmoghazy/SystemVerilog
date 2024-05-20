module logic_data_type();

  parameter CYCLE = 20;

/* System Verilog improves the classic reg data type so that it can be driven by
   continuous assignments, gates, and modules,in addition to being a variable. 
   It is given the synonym logic so that it does not look like a register declaration. 
    - A logic type is a 4-state type (1,0,x,z)
    - A logic signal can be used anywhere a net is used
    - A logic signal can only have one driver
*/

  logic q;
  logic q_l;
  logic d;
  logic clk;
  logic rst_h;
  logic rst_l;

  
  initial begin
    clk = 0;
    forever #(CYCLE/2) clk = ~clk;
  end
  
  initial begin
    d = 1;
    rst_h = 1;
    #15;
    rst_h=0;
    #7;
    d=0;
    #30 d=1;
    #2 d=0;
    #6 d = 1;
  end

  assign rst_l = ~rst_h;     // Continous assignment
  not n1(q_l,q);
  
  my_diff d1(q,d,clk,rst_l); // instantiate the module
  
  initial
    begin
      $dumpfile("uvm.vcd");
      $dumpvars;
      #200 $finish;
    end
endmodule
  