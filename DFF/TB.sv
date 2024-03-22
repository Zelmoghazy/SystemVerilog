module logic_data_type();
  parameter CYCLE = 20;
  logic q,q_l,d,clk,rst_h,rst_l;
  
  initial begin
  clk = 0;
    forever #(CYCLE/2) clk = ~clk;
  end
  
  initial begin
    d=1;
    rst_h = 1;
    #15 rst_h=0;
    #7 d=0;
    #30 d=1;
    #2 d=0;
    #6 d = 1;
  end
  assign rst_l = ~rst_h;
  not n1(q_l,q);
  my_diff d1(q,d,clk,rst_l);
  
  initial
    begin
      $dumpfile("uvm.vcd");
      $dumpvars;
      #200 $finish;
    end
endmodule
  