
// Interface
interface intf();
    logic [3:0] a;
    logic [3:0] b;
    logic [4:0] c;

    modport driver (output a, b, input c);
    modport dut (input a, b, output c);
endinterface


// Design Under Test
module adder(intf xyz);
    assign xyz.c = xyz.a + xyz.b;
endmodule

// Test Bench
module tbench(intf abc);
    initial begin
        abc.a = 6;
        abc.b = 4;
        $$display("Value of a = %0d, b=%0d", abc.a,abc.b);
        #5;
        $display("Sum of a and b = %0d",abc.c);
        $finish;
    end
endmodule

// Top Module

module top;

    // Instantiate interface
    intf i1();

    // Instantiate Design under test
    adder  a1(i1.dut);

    // Instantiate Test Bench
    tbench t1(i1.tbench);

endmodule