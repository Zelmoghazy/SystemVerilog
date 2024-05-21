/* 
    In System Verilog  as a way to schedule the testbench events separetly from the design events
    your testbench code should be defined in a program block, which is similar to
    a module in that it can contain code and variables and be instantiated in other modules.
    However, a program cannot have any hierarchy such as instances of modules. interfaces. or other programs.

    Timing Regions of a program block:
        - Active region : simulation of design code in modules
        - Observed region : Evaluation of system verilog assertions.
        - Reactive region : Execution of testbench code in programs.
        - Postponed region : Sampling design signals for testbench input. 

    - The Program construct provides a race-free interaction between the design and the testbench
    - All elements declared within the program block will get executed in the reactive region.
    - Non-blocking assignments within the module are scheduled in the active region.
    - This solves the problem of racing between design and the testbench, as the
      statements within the program block (scheduled in the reactive region) that are
      sensitive to changes in design signals declared in modules (scheduled in the
      active region), are executed at the end of the time slot.

    - A program block is treated as if it contains a test.
      Simulation ends when you complete the last statement in
      every initial-block, as this is considered the end of the test
      If you had an always block, it would never stop, so it is not allowed in a program.
      Simulation ends even if there are threads still running in the modules..
    
    - If there are several program blocks, simulation ends when the last program completes.

    - You can terminate any program block early by executing $exit.

    - The program block is not the place to put a clock generator.
 */

 module design_ex(outputbit[7:0] addr);
    initial begin
        // at time 0
        addr <= 10;
    end
endmodule


program testbench(input bit [7:0] addr);
    // It can contain one or more initial blocks
    // It cannot contain always blocks, modules, interfaces, or other programs
    // In the program block, variables can only be assigned using "blocking" assignments.
    // Using non-blocking assignments within the program shall be an error
    initial begin
        $display("\tAddr = %0d",addr); // avoid racing condition on reading addr 
    end
endprogram

//testbench top
module tbench_top;
    wire [7:0] addr;

    design_ex dut (addr);
    // It can be instantiated, and ports can be connected the same as a module
    testbench test (addr);
endmodule