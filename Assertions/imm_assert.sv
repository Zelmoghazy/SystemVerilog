module test (count_ifc x);
    initial begin
        x.P      <= 4'b0111;
        x.MR     <= 1'b0;
        x.Enable <= 1'b1 ;
        x.Load   <= 1'b0;

        #3 x.MR<= 1'b1;

        /*
            - The Immediate Assertion

            - If the expression evaluates to X, Z or 0, then it is interpreted as being false and
              the assertion is said to fail.

            - Otherwise, the expression is interpreted as being true and the assertion is said to pass.

            - An immediate assertion has optional then and else clauses to create a custom error message.
        */
        assertion1: assert(x.Q == 4'b0000)
            $display("The output value is correct");
        else
            $fatal("The reset is not synchronous");

        #6 x.MR<= 1'b0;

        #43 Enable <= 1'b0;
        #15 Enable <= 1'b1;

        #16 Load <= 1'b1 ;
        #9  Load <= 1'b0 ;
    end
endmodule

/* Severity System Tasks */
module test_module ;
initial begin
    #5 $info("Starting simulation...") ;
    #5 $warning("This is a warning message...") ;
    #5 $error("This is an error message. ") ;
    #5 $fatal("This is a fatal error message. ") ; // Simulation will terminate here
    #5 $info("Simulation ended. ") ;               // This will not be executed due to the previous $fatal
end
endmodule