/* 
    - #1 means a delay of one time unit.
    - if not otherwise specified, the time unit is one second.
    - Any fractions will be rounded, so #0.4 will be considered as 0 delay,
      but #0.6 will be considered as 1 second delay.
 */

module timing;
    initial begin
        #1   $display("%0t", $realtime) ;
        #2   $display("%0t", $realtime) ;
        #0.2 $display("%0t", $realtime) ;
        #0.4 $display("%0t", $realtime) ;   // 0 second delay
        #0.5 $display("%0t", $realtime) ;   // 1 second delay
    end
endmodule


/*
    - timeprecision can be the same as the timeunit or a smaller unit.
        - It can also be 10^n of the smaller unit, provided that it keeps smaller than the timeunit.
    - The value of timeprecision is also used while displaying time values using $display and %t.
 */
module timing_2;

    timeunit 1 ns;          // default time unit
    timeprecision 1ps;      // minimum delay you can use -> used for $display by default


    initial begin
        #1      $display("%0t", $realtime) ;   // 1      ns -> 1000 ps
        #2      $display("%0t", $realtime) ;   // 2      ns -> 2000 ps
        #0.2    $display("%0t", $realtime) ;   // 0.2    ns -> 200  ps
        #0.367  $display("%0t", $realtime) ;   // 0.367  ns -> 367  ps
        #0.0004 $display("%0t", $realtime) ;   // 0.0004 ns -> 0.4  ps -> 0
    end
endmodule


/*
    - $timeformat(<code>,<precision>,<suffix string>,<minimum width>)
        - <code>: (0: s, -3: ms, -6: us, -9: ns, -12: ps, -15: fs)
        - <precision>: represents the number of fractional digits
        - <suffix_string>: a string written after the numerical time value
        - <minimum width>: the minimum space on which the value is written.
 */
module time_format;

    timeunit 1 ns;          // default time unit
    timeprecision 1ps;      // minimum delay you can use -> used for $display by default

    initial begin
        $timeformat (-9, 5, "ns ", 12) ; I
        #2      $display("x %t x", $realtime) ;
        #0.2    $display("x %t x", $realtime) ;
        #0.367  $display("x %t x", $realtime) ;
        #0.0004 $display("x %t x", $realtime) ;
    end
endmodule

/* 
    Instead of writing timeunit, and timeprecision explicitly, you can alternatively use the
    'timescale unit/precision compiler directive.
 */

'timescale 1ns/1ps
module time_format_2;
    initial begin
        $timeformat (-9, 5, "ns ", 12) ; I
        #2      $display("x %t x", $realtime) ;
        #0.2    $display("x %t x", $realtime) ;
        #0.367  $display("x %t x", $realtime) ;
        #0.0004 $display("x %t x", $realtime) ;
    end
endmodule