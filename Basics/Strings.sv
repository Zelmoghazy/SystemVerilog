/* 
    - The SystemVerilog string type holds variable-length strings.
    - An individual character is of type byte.
    -  The elements of a string of length N are numbered 0 to N-1.
    - There is no null character at the end of a string, and any attempt to use the character "\0" is ignored.
*/


module test () ;
    string s;

    initial begin

        s = "IEEE ";

        $display(s.getc(0)) ;    // Display: 73 ('I')
        $display(s.tolower()) ; // Display: ieee

        s.putc(s.len()-1, "-") ; // change ' ' -> '-'
        
        s = {s, "p1800"}; // "IEEE-P1800"
        
        $display(s.substr(2,5)) ; // Display: EE-P

        #20;

        /*
            The $psprintf() function returns a formatted temporary string that,
            can be passed directly to another routine.  
         */
        // Create temporary string, note format
        my_log ($psprintf( "%s %5d" , s, 42)) ;
    end

    task my_log (string message) ;
        // Print a message to a log
        $display( "@%0t: %s" , $time , message) ;
    endtask
endmodule