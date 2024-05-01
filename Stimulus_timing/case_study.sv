/* 
    An interface block can use a clocking block to specify the timing of synchronous
    signals relative to the clocks.

    Any signal in a clocking block is now driven or sampled synchronously, ensuring
    that your testbench interacts with the signals at the right time.

    If you have multiple clock domains, an interface can contain multiple clocking
    blocks, one per clock domain, as there is single clock expression in each block.
 */


interface intf (input clk);
    logic read, enable;
    logic [7:0] addr,data;

    // clocking block for testbench
    clocking cb @(posedge clk) ;
        default input #10ns output #2ns;
        output read,enable,addr;
        input data;
    endclocking

    modport dut(input read,enable,addr,output data);

    // Synchronous testbench modport
    modport tb (clocking cb);
endinterface :intf


module memory(intf abc) ;
    logic [7:0] mem [256] ;
    initial begin
        foreach (mem [i])
            mem [i] = i >> 1;
    end

    always @(abc.enable, abc.read) begin
        if(abc.enable == 1 && abc.read == 1)
            abc.data = mem[abc.addr];
    end
endmodule


module testbench (intf xyz) ;
    logic [7:0] cbdata;

    initial begin
        xyz.cb.read   <= 1;       // driving a synchronous signal
        xyz.cb.enable <= 1;       // driving a synchronous signal
        xyz.cb.addr   <= 70;      // driving a synchronous signal
        #30 xyz.cb.addr <= 150; 
        #25 xyz.data    <= 67;    // disturbing the DUT data
        #40 xyz.cb.addr <= 5;
    end
    always @(xyz.cb)
        cbdata = xyz.cb.data;     // get the sampled data
endmodule


module top;
    bit clk = 0;
    always #20 clk = ~clk;

    intf i1(clk);
    memory m1(i1.dut);
    testbench(i1.tb);

    initial begin
        $dumpfile("uvm.vcd");
        $dumpvars;
        #200 $finish;
    end
endmodule