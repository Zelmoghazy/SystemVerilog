/* 
    A concurrent assertion is like a small model that runs
    continuously, checking the values of signals for the entire
    simulation, only at the occurrence of a clock tick.

    For example :  A Request should be followed by an Acknowledge occurring no more
    than two clocks after the request is asserted. You can check that using an
    assertion like this one:
        assert property (@(posedge clk) Req |-> ##[1:2] Ack);
            - We use the implication operator |-> to express some event implies some other thing.
            - ##[1:2] means after one or two clock cycles
    
    - There are two types of implication operators:

        -  Overlapped implication (|->)
            - If there is a match on the antecedent, then the consequent expression is evaluated in the same clock cycle.
            - assert property (@(posedge clk) a|-> b); checks that, if signal “a” is high on a given positive clock
            edge, then signal “b” should also be high on the same clock edge

        - Non-Overlapped Implication (|=>)
            -  If there is a match on the antecedent, then the consequent expression is evaluated in the next clock cycle.
            - assert property (@(posedge clk) a|=> b); checks that, if signal “a” is high on a given positive clock
            edge, then signal “b” should also be high on the next clock edge.
    
    - Implication with a fixed delay on the consequent
        - assert property (@(posedge clk) a|-> ##2 b);
            - This property checks, if signal a is high on a given positive clock edge, then signal b should be high after exactly 2 c/oc/c cycles.

    - Implication with a delay range on the consequent
        - assert property (@(posedge clk) a|-> ##[1:4] b);
            - This property checks, if signal a is high on a given positive clock edge, then within 1 to 4 clock
            cycles, the signal b should be high.

    - Implication with an infinite timing window on the consequent (eventuality operator)
        - assert property (@(posedge clk) a|-> ##[1:$] b);
            - This property checks, if signal a is high on a given positive clock edge, then signal b will be high
            eventually starting from the next clock cycle.
 */

 module decade_counter (counter_ifc y);
    always @(y.MR) begin
        // asynchronous reset signal MR (Master Reset).
        if (y.MR)
            y.Q <= 4'b0000;
    end

    always @(posedge y.CLK) begin
        if(!y.MR)
            if(y.Load)
            /* Design error y.Q <= y.P */
                y.Q <= y.P+1;
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
        #6 x.MR<= 1'b0;

        #43 Enable <= 1'b0;
        #15 Enable <= 1'b1;

        #16 Load <= 1'b1 ;
        #9  Load <= 1'b0 ;
    end

    /*  check that whenever the load line is active, then at
        the very next rising edge of the clock the counter is loaded by the values found
        on the P inputs. */

    assertion1: assert property (@(posedge x.CLK) x.load |=> (x.Q == x.P));
endmodule