/* 
    Your testbench wraps around the design, sending in stimulus and capturing the
    design's response.
 */

module test (input  logic [3:0] Q,
             output logic [3:0] P,
             output logic Load, Enable, MR, CLK);

    always #5 CLK <= ~CLK;

    initial begin
        CLK <= 0;
        P   <= 4'b0111;
        MR  <= 1'b0;
        #3 MR<= 1'b1;
        #6 MR<= 1'b0;
    end

    initial begin
        Load <= 1'b0;
        #83 Load <= 1'b1 ;
        #9  Load <= 1'b0 ;
    end

    initial begin
        Enable <= 1'b1 ;
        #52 Enable <= 1'b0;
        #15 Enable <= 1'b1;
    end
endmodule


/* 
    All these connections can be error prone. As a signal moves through several
    layers of hierarchy, it has to be declared and connected over and over. (Here
    for example, the same signals are defined in the top module, the design, and
    the testbench)

    Worst of all, if you just want to add a new signal, it has to be declared and
    connected in multiple files.
 */
module top;
    logic [3 :0] Q;
    logic [3 :0] P;
    logic Load, Enable, MR, CLK ;

    decade_counter u1(Q, P, Load, Enable, MR, CLK) ;
    
    test u2(Q, P, Load, Enable, MR, CLK);
    
    initial begin
        $dumpfile("counter.vcd") ;
        $dumpvars;
        #200 $finish;
    end
endmodule