/* 
    Module ports and interfaces by default do not specify any timing requirements or
    synchronization schemes between signals.

    A clocking block defined between clocking and endcocking does exactly that.

    It is a collection of signals synchronous with a particular clock and helps to
    specify the timing requirements between the clock and the signals.

    Specifying a clocking block using a SystemVerilog interface can significantly
    reduce the amount of code needed to connect the TestBench without race
    condition (races are explained later).
 */
 clocking ckl@ (posedge clk) ;
    // All signals in the block shall use a 5ns input skew 
    // and a 2ns output skew by default.
    // skew of how many time units away from the clock event a signal is to be sampled or driven
    // If a default skew is not specified, then all input signals will be sampled #1step and output signlas driven 0 ns after the specified event.
    default input #5ns output #2ns;

    input data, valid, ready;
    output x, y;

    output negedge grant;

    // #1step which overrides the skew of #5ns.
    // Here #1step means the delay defined by the timeprecision
    input #1step addr;
endclocking