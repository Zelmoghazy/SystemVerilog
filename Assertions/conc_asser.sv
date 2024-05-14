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

    /*  
        check that whenever the load line is active, then at
        the very next rising edge of the clock the counter is
        loaded by the values found on the P inputs. 
    */

    assertion1: assert property (@(posedge x.CLK) x.load |=> (x.Q == x.P));
endmodule


module ConcurrentAssertionExample (
    input logic clk,
    input logic a,
    input logic b
);

    // Property definition
    property prop_concurrent_assertion;
        @(posedge clk) disable iff (!a)     // disable saves evaluating the assertion if a condition is not satisfied
        a |-> !b;
    endproperty

    // Assertion instantiation
    assert property (prop_concurrent_assertion);

endmodule


module ConcurrentAssertionExample (
    input logic clk,
    input logic [1:0] data
);

    // Sequence definitions
    sequence seq_data0_rising_edge;
        @(posedge clk) data[0];
    endsequence

    sequence seq_data1_falling_edge;
        @(negedge clk) data[1];
    endsequence

    // Assertion instantiation
    assert property (
        seq_data0_rising_edge |-> seq_data1_falling_edge
    );

endmodule

module example_module;
    // Define input signals
    bit clk;
    bit [3:0] data;

    property p_data_stable;
        @(posedge clk)
        (##1 data === data[*4]); // checks if the data signal remains stable for 4 consecutive clock cycles.
        // data === data #1 data === data #1 data === data #1 data === data
    endproperty

    assert property (p_data_stable);

endmodule


module ExampleModule;  
  logic clk, reset, data;
  
  property p1;
    @(posedge clk) disable iff (reset)
      (data == 1) |-> ##[1:3] (data == 0); // Data should remain 0 for 1 to 3 clock cycles after it transitions to 1
      (data == 1) |-> ##[3:$] (data == 0); // Data should remain 0 for at least 3 clock cycles after it transitions to 1
  endproperty
  
    property p;
        // if a signal 'a' is high on a given posedge of the clock, the signal 'b' should be high for 3 clock cycles (not necessarily consecutive)
        // followed by 'c' that should be high after 'b' is high for the third time
        @(posedge clk) a |-> ##1 b[->3] ##1 c;
    endproperty
        
    a: assert property(p);

  // Assertion declaration
  assert property (p1) else $error("Property p1 failed!");
  
endmodule
