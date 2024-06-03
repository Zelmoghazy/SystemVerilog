/* 
    - SystemVerilog has several constructs to help you control the timing 
      of the communication.

    - Module ports and interfaces by default do not specify any timing requirements or
      synchronization schemes between signals.

    - A clocking block (defined between clocking and endcocking) helps to specify the timing
      requirements between the clock and the signals.

    - It is a collection of signals synchronous with a (particular clock) and helps to
      specify the timing requirements between the clock and the signals.

    - A testbench can have many clocking blocks, but only one per clock.  

    - A clocking block assembles signals that are synchronous to a particular clock,
      and makes their timing explicit.

    - Specifying a clocking block using a SystemVerilog interface can significantly
      reduce the amount of code needed to connect the TestBench without race condition.
 */


/*
    clocking block called cb that is to 
    be clocked on the posedge of signal clk
 */
clocking cb @(posedge clk);
    /* 
        - All signals in the block shall use by default:
          - 5ns input skew (sampled 5ns before posedge of clk)
          - 2ns output skew by default (driven 2ns after posedge of clk).

        - The delay_value represents a skew of how many time units away from 
          the clock event a signal is to be sampled or driven

        - If a default skew is not specified, then all input signals will be 
          sampled #1step and output signals driven 0 ns after the specified event.
    */

    default input #5ns output #2ns; // Default input and output skew values

    input data, valid, ready;
    output x, y;

    output negedge grant;   // overwriting the default, driven with negative edge.

    input #1step addr;      // #1step overwrites the default input skew of #5ns, it means delay defined by timeprecision
endclocking