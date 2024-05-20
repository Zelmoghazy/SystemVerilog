/* 
    - Designs have become so complex that even the communication between blocks may need to be separated out into separate entities.

    - To model this, SystemVerilog uses the interface construct that you can think of as an intelligent bundle of wires.

    - They contain the connectivity, synchronization, and optionally, the functionality of the communication between two or more blocks.

 */

interface count_ifc (input bit CLK);
    logic [3:0] Q, P;
    logic Load, Enable, MR;
endinterface

module test (count_ifc x);
    initial begin
        x.P      <= 4'b0111;
        x.MR     <= 1'b0;
        x.Enable <= 1'b1 ;
        x.Load   <= 1'b0;

        #3 x.MR <= 1'b1;
        #6 x.MR <= 1'b0;

        #43 Enable <= 1'b0;
        #15 Enable <= 1'b1;

        #16 Load <= 1'b1 ;
        #9  Load <= 1'b0 ;
    end
endmodule
