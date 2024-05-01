module decade_counter (counter_ifc y);
    always @(y.MR) begin
        // asynchronous reset signal MR (Master Reset).
        if (y.MR)
            y.Q <= 4'b0000;
    end

    always @(posedge y.CLK) begin
        if(!y.MR)
            if(y.Load)
                y.Q <= y.P;
            else if (y.Enable)
                y.Q <= (y.Q+1) % 10;
    end
endmodule                

module top;
    bit clk;
    always #5 clk <= ~clk;

    count_ifc ifc(clk);
    
    // when you make an instance from the DUT or the testbench, you select the convenient modport
    decade_counter u1(ifc.dut) ;
    test u2(ifc.driver);
    
    initial begin
        $dumpfile("counter.vcd") ;
        $dumpvars;
        #200 $finish;
    end
endmodule