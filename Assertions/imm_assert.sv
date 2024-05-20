/* 
    - Assertions are pieces of code that check the relationships
      between design signals, either once or over a period of time.

    - Assertions are instantiated similarly to other design blocks and are 
      active for the entire simulation  

    - The Immediate Assertion :
        - If the expression evaluates to X, Z or 0, then it is interpreted as being false and
          the assertion is said to fail.

        - Otherwise, the expression is interpreted as being true and the assertion is said to pass.

        - An immediate assertion has optional "then" and "else" clauses to create a custom error message.
 */

// Interface
interface count_ifc(input bit CLK);
    logic [3:0] Q, P;
    logic Load, Enable, MR;

    modport driver (output P, Load, Enable, MR, input  Q);
    modport dut    (input  P, Load, Enable, MR, output Q);
endinterface 

// DUT
module decade_counter (count_ifc y);
    always @(y.MR) begin
        // asynchronous reset signal MR (Master Reset).
        if (y.MR)
            y.Q <= 4'b0000;
    end

    always @(posedge CLK) begin
        if(!y.MR)
            if(y.Load)
                y.Q <= y.P;
            else if (y.Enable)
                y.Q <= (y.Q+1) % 10;
    end
endmodule               

module test (count_ifc x);
    initial begin
        x.P      <= 4'b0111;
        x.MR     <= 1'b0;
        x.Enable <= 1'b1 ;
        x.Load   <= 1'b0;

        #3 x.MR<= 1'b1;


        // Immediate assertion : Check that reset is an asynchronous reset
        assertion1: assert(x.Q == 4'b0000)
            $display("The output value is correct");
        else
            $fatal("The reset is not synchronous");  // Stop execution at this point.

        #6  x.MR<= 1'b0;

        #43 Enable <= 1'b0;
        #15 Enable <= 1'b1;

        #16 Load <= 1'b1 ;
        #9  Load <= 1'b0 ;
    end
endmodule

module top;
    bit clk;
    always #5 clk <= ~clk;

    // Instantiate interface
    count_ifc ifc (clk);
    // Instantiate DUT
    decade_counter u1(ifc.dut);
    // Instantiate TB
    test u2 (ifc.driver);

    initial begin
        $dumpfile("counter.vcd") ;
        $dumpvars;
        #200 $finish;
    end
endmodule

/* Severity System Tasks */
module test_module ;
    initial begin
        #5 $info("Starting simulation...") ;
        #5 $warning("This is a warning message...") ;
        #5 $error("This is an error message.") ;        // default in assertions
        #5 $fatal("This is a fatal error message.") ;   // Simulation will terminate here.
        #5 $info("Simulation ended.") ;                 // This will not be executed due to the previous $fatal
    end
endmodule