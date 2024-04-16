
/* Union of several types */
/* 
    To use unions you must add the argument –lca (Limited Customer Availability)
    to the command line of the compiler. 
*/
module union () ;
    typedef union {
        int i ;
        real f; 
    }num_u;

    num_u un;

    initial begin
        un.f= 25.432 ; // set value in floating point format
        $display(un) ;
    end
endmodule