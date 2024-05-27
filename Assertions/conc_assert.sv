/* 
    A concurrent assertion is like a small model that runs
    continuously, checking the values of signals for the entire
    simulation, only at the occurrence of a clock tick.

    - For example :  A Request should be followed by an Acknowledge 
      occurring no more than two clocks after the request is asserted.

    - You can check that using an assertion like this one:

        assert property (@(posedge clk) Req |-> ##[1:2] Ack);

            - We use the implication operator |-> to express some event implies some other thing.
            - ##[1:2] means after one or two clock cycles (after one triggering event step -> 2 posedges = 1 clk cyle)
    
    - There are two types of implication operators:

        - Overlapped implication (|->)
            - If there is a match on the antecedent, then the consequent expression is evaluated in the "same" clock cycle.
            - assert property (@(posedge clk) a |-> b); 
                - checks that, if signal “a” is high on a given positive clock edge,
                  then signal “b” should also be high on the same clock edge

        - Non-Overlapped Implication (|=>)
            - If there is a match on the antecedent, then the consequent expression is evaluated in the "next" clock cycle.
            - assert property (@(posedge clk) a |=> b);
                - checks that, if signal “a” is high on a given positive clock edge,
                  then signal “b” should also be high on the "next" clock edge.
                - Equivalent to : assert property (@(posedge clk) a |-> #1 b);             
    
    - Implication with a fixed delay on the consequent
        - assert property (@(posedge clk) a|-> ##2 b);
            - This property checks, if signal a is high on a given positive clock edge,
              then signal b should be high after exactly 2 clock cycles.

    - Implication with a delay range on the consequent
        - assert property (@(posedge clk) a|-> ##[1:4] b);
            - This property checks, if signal a is high on a given positive clock edge,
              then within 1 to 4 clock cycles, the signal b should be high.

    - Implication with an infinite timing window on the consequent (eventuality operator)
        - assert property (@(posedge clk) a|-> ##[1:$] b);
            - This property checks, if signal a is high on a given positive clock edge,
              then signal b will be high eventually starting from the next clock cycle.

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
        x.P      <= 4'b0101;
        x.MR     <= 1'b0;
        x.Enable <= 1'b1 ;
        x.Load   <= 1'b0;

        #3 x.MR  <= 1'b1;
        #6 x.MR  <= 1'b0;

        #12 x.Load <= 1'b1 ;
        #9  x.Load <= 1'b0 ;

        #5  x.P = 4'b0011;

        #8  x.Enable <= 1'b0;
        #15 x.Enable <= 1'b1;

        
        #16 x.Load <= 1'b1 ;
        #9  x.Load <= 1'b0 ;
    end

    /*  
        check that whenever the load line is active, then at
        the very next rising edge of the clock the counter is
        loaded by the values found on the P inputs. 
    */

    assertion1: assert property (@(posedge x.CLK) 
        x.load |=> (x.Q == x.P)
    );
endmodule


module conc_disable(
    input logic clk,
    input logic a,
    input logic b
);

    property prop_concurrent_assertion;
        // disable saves evaluating the assertion if a condition is not satisfied
        @(posedge clk) disable iff (!a)     
            a |-> !b;
    endproperty

    // Assertion instantiation
    assert property (prop_concurrent_assertion);

endmodule


/*
    The series or expressions spread over one or more clock cycles is called a sequence.
    A complex property can be phrased with multiple sequence blocks. 
*/

module sequences(
    input logic clk,
    input logic [1:0] data
);

    // Sequence definitions
    sequence seq_data0_rising_edge;
        @(posedge clk) 
            data[0]; // data[0] should be high at every posedge
    endsequence

    sequence seq_data1_falling_edge;
        @(negedge clk) 
            data[1]; // data[1] should be high at every negedge
    endsequence
 
    property prop_1;
        seq_data0_rising_edge |-> seq_data1_falling_edge;
    endproperty    

    // Assertion instantiation
    assert property (prop1);  

endmodule

/* SVA Operators */

module sva_op;  
  logic clk, reset, data;
  
  property delay_op;
    @(posedge clk) disable iff (reset)
      (data == 1) |-> ##[1:3] (data == 0); // Data should remain 0 for 1 to 3 clock cycles after it transitions to 1
      (data == 1) |-> ##[3:$] (data == 0); // Data should remain 0 for at least 3 clock cycles after it transitions to 1
  endproperty

    /*
        - Continuous repetition operator [*n], [*m:n]
            - The expression repeats continuously for the specified range of cycles.
     */
    property cont_rep;
        @(posedge clk) 
            (data == data) [*4]; // checks if the data signal remains stable for 4 consecutive clock cycles.
        // (data == data) ##1 (data == data) ##1 (data == data) ##1 (data == data)
    endproperty

    //-----------------------------------------------------------------------------
  
    /*
        - Go to repetition operator. [->n], [->m:n]
            - Indicates there's one or more delay cycles between each repetition of the expression (consecutive or non-consecutive).
            - a[->3] is equivalent to (!a[*0:$] ##1 a) [*3]
            - which translates to : a is not high for 0 or more cycles then a is high [repeated 3 times]
     */
    property go_to;
        @(posedge clk) 
            a |-> ##1 b[->3] ##1 c;
        // if a signal 'a' is high on a given posedge of the clock,
        // the signal 'b' should be high for 3 clock cycles (not necessarily consecutive)
        // followed by 'c' that should be high after 'b' is high for the third time
    endproperty
        
    //-----------------------------------------------------------------------------

    /*
        - Non-consecutive repetition operator.  [=n], [=m:n]
            - a[=3] is equivalent to (!a[*0:$] ##1 a ##1 !a[*0:$]) [*3]
            - which translates to : a is not high for 0 or more cycles then a is high
              then a is not high for 0 or more cycles [repeated 3 times]
              this notation illustrates that it can be either consecutive or not.
     */
    property non_consec;
        (a) |=> (b[=2]##1 c);
        // if a signal 'a' is high 
        // there should be two occurrences of b either consecutive or non-consecutive
        // and then some time later (i.e., next cycle or later) c occurs.
    endproperty

    //-----------------------------------------------------------------------------

    // Assertion declaration
    assert property (cont_rep);
    assert property (go_to);
    assert property (delay_op);

endmodule


/*
    - SVA Built in methods : 

        - $rose, $fell, $changed and $stable indicate whether or not the value of an expression
          has changed between two adjacent clock ticks.
            - $rose    : new value is 1, and the old value is 0
            - $fell    : new value is 0, and the old value is nonzero
            - $stable  : new value is same as old value.
            - $changed : new value different than old value.

        - The system function $past returns the value of an expression in a previous clock cycle. 
*/

module sva_methods;
    bit a, b=1, rst_n = 1, clk;

    always #5 clk = ~clk;

    initial begin
        #23 a = 1;
        #10 a = 0;
        #15 a = 1;
    end

    initial begin
        #3  b = 0;
        #40 b = 1;
        #10 b = 0;
        #45 b = 1;
    end

    property high;
        @(posedge clk) 
            $rose(a) |=> a;
    endproperty

    property low_for_4_cycles ;
        @(posedge clk) disable iff (!rst_n)
            $fell (b) |=> $stable (b)[*4]; // $stable should be true for 4 consecutive times.
    endproperty

    property toggle_every_cycle;
        @(posedge clk) $changed(a);
    endproperty

    assert property (high)
        else $error ("a is not high after rise");
    
    assert property(low_for_4_cycles ) 
        else $error ("b is not low for at least 4 cycles");

    assert property(toggle_every_cycle) 
        else $error("a does not toggle every cycle");
endmodule


/* Write a System Verilog assertion to check the following : */

// a and b are two signals, which can be active at any time, but should never be active together.

property not_active_together;
    @(posedge clk) 
        not(a && b);
endproperty

// Every time the request req goes high, ack arrives exactly 3 clocks later
property ack;
    @(posedge clk) 
        req |-> ##3 ack;
endproperty

// If a is high at a clock edge, followed by 3 consecutive cycles in which b is high,
// then in each of the 3 cycles the data output DO is equal to the data input D1.
property ack;
    @(posedge clk) 
        a ##1 b[*3] |-> (D0==D1) &&
                        ($past(D0,1)==$past(D1,1)) &&
                        ($past(D0,2)==$past(D1,2));
endproperty

// Every time the valid signal vld is high, the cnt is incremented.    
property valid;
    @(posedge clk) 
       vld |-> (cnt == ($past(cnt)+1)); // Default of $past is 1
endproperty


// If b is high at a clock edge, then 2 cycles before that, a was high.
property check_high;
    @(posedge clk) 
       b |-> ($past(a,2) == 1); 
endproperty

// If there are two occurrences of “a” rising while state = ACTIVE, and no “b” occurs
// between them, then within 3 cycles of the second rise of “a”, START must occur.
property start;
    @(posedge clk) 
       ($rose(a) && (state == ACTIVE)) ##1  
       !b[*1:$] ##1                         // no “b” occurs between them
       ($rose(a) && (state == ACTIVE))      // two occurrences of “a” rising while state = ACTIVE
       |-> ##[1:3] state == START;          // within 3 cycles of the second rise of “a”, START must occur
endproperty

// Every “a” must eventually be acknowledged by “b”, unless “c” appears any time before “b” appears.

property ack;
    @(posedge clk)
        a |-> ##[1:$] b || c;
endproperty

// Every time the request req goes high, gnt arrives exactly 3 clocks later. If this is
// not achieved an error is reported with the message: “no grant after request”.
// But this assertion should only be checked if the reset signal, rst, is not active.        

property grant;
    @(posedge clk) disable iff (rst)    
        req |-> ##3 gnt;
endproperty

assert property (grant)
    else
        $error("no grant after request");

// If a signal “a” is high on a given posedge of the clock, the signal “b” should be
// high for 3 clock cycles followed by “c” that should be high after “b” is high for the
// third time. During this entire sequence, if reset is detected at any point, the
// checker will stop.

property grant;
    @(posedge clk) disable iff (rst)
        a |-> ##1 b[->3] ##1 c;
endproperty

// A request “req” is high for one or more cycles, then returning to zero, is followed
// after one or more cycles, by an acknowledge, “ack” for one or more cycles before
// “ack” returns to zero. “ack” must be zero in the cycle in which “req” returns to
// zero. During this entire sequence, if reset is detected at any point, the checker will stop.
property req;
    @(posedge clk) disable iff (rst)
        !req       ##1 
        req[*1:$]  ##1   // req goes high for one or more cycles and return to zero
        !req
        |-> 
        !ack[#1:$] ##1
        ack[*1:$]  ##1
        !ack;
endproperty