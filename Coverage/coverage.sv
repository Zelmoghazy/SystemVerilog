/*
	- A cover group is similar to a class - you define it once and then
	  instantiate it one or more times.

	- It contains cover points, options, formal arguments, and an optional trigger.
	
	- A cover group contains one or more data points (called cover points),
	  all of which are sampled at the same time. You should create very
	  clear cover group names that explicitly indicate what you are
  	  measuring and, if possible, reference to the verification plan.

	- A cover group can be defined inside a class or at the program or
	  module level. It can sample any visible variable such as
	  program/module variables, signals from an interface, or any signal in
      the design (using a hierarchical reference). A cover group inside a
      class can sample variables in that class, as well as data values from
      embedded classes.  

  	- A cover group must be instantiated for it to collect data.

  	- When you specify a variable or expression in a cover point, 
  	  SystemVerilog creates a number of "bins" to record how many times
  	  each value has been seen.

  	- System Verilog automatically creates bins for cover points.  
  	  It looks at the domain of the sampled expression to determine the
	  range of possible values.
	- The domain for enumerated data types is the number of named values.
 */

bit running = 1;

interface busifc(input bit clk);
	bit [31:0] data;
	bit [2:0]  port;
	bit [3:0]  kind;

	modport tb(output data, port, kind, input clk);
	modport dut(input data, port, kind);

endinterface : busifc	

/* Design under test */
module bus(busifc.dut abc);
	// Add design here
endmodule : bus

/*
	If $finish is called explicitly, or implicitly (when a program finishes execution),
	eda playground will not run the TCL file run.do, and you will not see the detailed report.
	You will see only the line reporting the coverage from the get_coverage() function
 */

module test(busifc.tb ifc);
	class Transaction;
		// bus that accepts data and port number
		rand bit [31:0] d;
		rand bit [2:0]  p;
		rand bit [3:0]  k;
		bit reset;
		// Enumerated Types.
		typedef enum {INIT,DECODE,IDLE} fsmstate_e;
		rand fsmstate_e pstate,nstate;
	endclass

	Transaction tr;

	// Covergroup
	covergroup CovPort();
		// We want to test the bus with all possible values of the port number
		CP1 : coverpoint tr.p;
	endgroup : CovPort

	covergroup CovPort2();
		// option.auto_bin_max specifies the maximum number of bins to automatically create.
		CP1 : coverpoint tr.p {option.auto_bin_max = 2;};
	endgroup

	covergroup CovPort3();
		// this applies to all the cover points in the group.
		option.auto_bin_max = 2; 
		CP1 : coverpoint tr.p;
		CP2 : coverpoint tr.d;
	endgroup

	covergroup CovPort3();
		// You can sample expressions
		CP1 : coverpoint (tr.p + tr.k + 5'b00000);
		/* 
			- Note that :
				- When you are adding a 3-bit operand to 4-bit operand, System
			      Verilog considers the expression width to be 4 bits, and thus, if this
			      expression is used as a cover point, only 16 bins will be generated
			      automatically (but result maybe 5-bits and find no bins or result
				  will be 100% coverage and 5-bit values are never generated) so a 
			  	  dummy 5-bit value is added to fix this
				- Another problem : maximum 3-bit + 4-bit number is 22
			      but a 32-bins are generated so we will never reach 100% coverage
			      values from 23->31 will never happen!
		 */

		// The fix is to define the number of bins generated explicitly
		{bins test_bin[] = {[0:22]};}
	endgroup

	covergroup CovPort4();
		CP1 : coverpoint tr.k;
		{
			bins zero = {0};		// 1 bin for value = 0
			bins low  = {[1:3],5};  // 1 bin for the values 1,2,3,5
			bins hi[] = {[8:$]};    // seperate bins for 8,9,...,15
			bins misc = default;	// 1 bin for the rest (not chosen values)
		} // no semicolon - declarative code
		/*
			- When you define the bins. you are restricting the values used for coverage to
			  those that are interesting to you. In this case, SystemVerilog no longer
			  automatically creates bins, and it ignores values that do not fall into a predefined bin.
		 */
	endgroup

	covergroup CovPort5();
		// You can use the iff keyword to add a condition to a cover point.
		CP1 : coverpoint tr.p iff(!tr.reset);
	endgroup : CovPort5

	covergroup CovPort6();
		// For enumerated types, SystemVerilog creates a bin for each value.
		// If you want to group multiple values into a single bin, you have to define your own bins
		CP1 : coverpoint tr.pstate;
	endgroup	

	covergroup CovPort7();
		CP1 : coverpoint tr.k;
		// You use the wildcard keyword to create multiple values for bins.
		{
			wildcard bins even = {4'bxzx0}; // {x, z, ?} -> are treated as a wildcard for 0 or 1
			wildcard bins odd  = {4'b???1};
		}
	endgroup

	covergroup CovPort8();
		CP1 : coverpoint tr.k;
		/*  you can let SystemVerilog automatically create bins, and then use ignore_bins 
			to tell which values to exclude from functional coverage calculation.
		 */
		{
			ignore_bins high = {[6:15]}; // excludes the last 10 bins,
		}
	endgroup

	covergroup CovPort9();
		CP1 : coverpoint tr.k;
		{
			option.auto_bin_max = 8;
			ignore_bins high = {[6:15]}; // 5 uppermost bins are ignored.
		}
	endgroup

	covergroup CovPort9();
		CP1 : coverpoint tr.k;
		{
			// If the testbench generates a value in those bins, an error will be issued.
			illegal_bins high = {[6:15]}; 
		}
	endgroup

	covergroup CovPort10();
		CP1 : coverpoint tr.k;
		CP2 : coverpoint tr.p;
		// measures what values were seen for two or more cover points at the same time
		// The cross construct in SystemVerilog records the combined values of two or more cover points in a group.
		cross CP1, CP2;
	endgroup

	covergroup CovKind();
		CP1: coverpoint tr.p;
		{
			bins port[] = {[0:$]};
		}

		CP2: coverpoint tr.k
		{
			bins zero   = {0};
			bins low    = {[1:3]};
			bins high[] = {[8:$]};
			bins misc   = default;
		}

		/*
			With cross coverage, you specify the cover point with binsof 
			and the set of values with intersect so that a single ignore_bins 
			construct can sweep out many individual bins
		 */
		cross CP1,CP2
		{
			ignore_bins t1 = binsof(CP1) intersect {7};
			ignore_bins t2 = binsof(CP1) intersect {0} && binsof(CP2) intersect {[9:11]};
			ignore_bins t3 = binsof(CP2.low);
		}
	endgroup : CovKind

	// a generic cover group where you can specify a few unique details when you instantiate it.
	// The cover points are passed by reference, while the other arguments are passed as value
	covergroup CovPort(ref bit[2:0] port, input int mid);
		coverpoint port{
			bins lo = {[0:mid-1]};
			bins hi = {[mid:$]};
		}
		
	endgroup : CovPort


	covergroup CovKind2() @ifc.clk;  // here the sampling occurs based on the clock edge of the clocking block.
		// no need for using sample() function
		CP1 : coverpoint tr.k;
	endgroup : CovKind2


	initial begin
		CovPort xyz;
		// Allocate memory for covergroup and class
		xyz = new();
		tr  = new();

		tr.reset = 1;
		xyz.stop(); 		// deactivate the covergroup
		repeat (8) begin
			xyz.start();	// reactivate the covergroup
			assert (tr.randomize);
			// Sample generated port number values
			xyz.sample();
			// wait for clk change
			@ifc.clk;
		end
		running = 0;	// flag to stop clock
		$display("Coverage = %.2f%%",xyz.get_coverage());
	end
endmodule

module top;
	bit clk;
	initial begin
		clk = 0;
		// this way gives coverage report code a chance to run
		while(running == 1) // As long as running == 1, clk is enabled
			#5 clk = ~clk;
	end

	busifc u1(clk);
	bus u2(u1.dut);
	test u3(u1.tb);
endmodule


/*
	# COVERGROUP COVERAGE:
# ----------------------------------------------------------------------------------------------------------
# Covergroup                                             Metric       Goal       Bins    Status               
#                                                                                                          
# ----------------------------------------------------------------------------------------------------------
#  TYPE /top/u3/CovPort                                 100.00%        100          -    Covered              
#     covered/total bins:                                     8          8          -                      
#     missing/total bins:                                     0          8          -                      
#     % Hit:                                            100.00%        100          -                      
#     Coverpoint CP1                                    100.00%        100          -    Covered              
#         covered/total bins:                                 8          8          -                      
#         missing/total bins:                                 0          8          -                      
#         % Hit:                                        100.00%        100          -                      
#  Covergroup instance \/top/u3/#ublk#502948#36/xyz     100.00%        100          -    Covered              
#     covered/total bins:                                     8          8          -                      
#     missing/total bins:                                     0          8          -                      
#     % Hit:                                            100.00%        100          -                      
#     Coverpoint CP1                                    100.00%        100          -    Covered              
#         covered/total bins:                                 8          8          -                      
#         missing/total bins:                                 0          8          -                      
#         % Hit:                                        100.00%        100          -                      
#         bin auto[0]                                        14          1          -    Covered              
#         bin auto[1]                                        10          1          -    Covered              
#         bin auto[2]                                        17          1          -    Covered              
#         bin auto[3]                                        12          1          -    Covered              
#         bin auto[4]                                         9          1          -    Covered              
#         bin auto[5]                                         9          1          -    Covered              
#         bin auto[6]                                        12          1          -    Covered              
#         bin auto[7]                                        17          1          -    Covered              
# 
# TOTAL COVERGROUP COVERAGE: 100.00%  COVERGROUP TYPES: 1

/*

/*
	- The simulator automatically generates a bin for every value for the signal to be sampled,
	- If a certain value happened, the contents for the corresponding bin will be incremented.
	- Bins are the basic units of measurement for functional coverage. When you specify a
	  variable or expression in a cover point, System Verilog(SV) creates a number of “bins”
	  to record how many times each value has been seen.
  	- The bins can be explicitly defined by the user or automatically (implicitly) created by SV.
  	  The number of bins created implicitly can be controlled by auto_bin_max parameter

*/


// Triggering on a SV Assertion

module test(busifc.tb ifc);
	event ready; // event that will be triggered by an assertion
	class Transaction;
		rand bit [2:0] p;
		rand bit [3:0] k;
	endclass : Transaction

	Transaction tr;

	// Event triggering occurrence can be recognized by using the event control "@".
	covergroup CovKind @(ready); // sampling occurs based on the event triggered by an assertion
		CP1: coverpoint tr.k;		
	endgroup : CovKind

	initial begin
		CovKind xyz;
		xyz = new();
		tr  = new();

		repeat (20) begin 
			// A named event can be triggered explicitly using "->".
			assert (tr.randomize) -> ready; // assertion triggers the event when the randomization succeeds
		end
		running = 0;
		$display("Coverage = %.2f%%",xyz.get_coverage());
	end
endmodule