/* 
    -  The modport (module ports) groups and specifies the port directions to the
       signals declared within the interface.
       
    -  modports are declared inside the interface with the keyword modport.

    -  By specifying the port directions, modport provides "access restrictions".

    -  modport item declared as input is not allowed to be driven or being assigned. 
       Any attempt to drive leads to a compilation error.

    -  Modports can have, input, inout, output, and ref

 */

interface count_ifc (input bit CLK);
    logic [3:0] Q, P;
    logic Load, Enable, MR;

    // Modport Declaration
    modport driver (output P, Load, Enable, MR, input Q);
    modport dut    (input  P, Load, Enable, MR, output Q);
endinterface


module test (count_ifc x);
    initial begin
        x.P      <= 4'b0111;
        x.MR     <= 1'b0;
        x.Enable <= 1'b1;
        x.Load   <= 1'b0;

        #3 x.MR<= 1'b1;
        #6 x.MR<= 1'b0;

        #43 Enable <= 1'b0;
        #15 Enable <= 1'b1;

        #16 Load <= 1'b1 ;
        #9  Load <= 1'b0 ;
    end
endmodule
