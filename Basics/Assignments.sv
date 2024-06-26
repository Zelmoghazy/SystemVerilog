/* 
 * Non-Blocking
 *    - Used only inside an always or initial block.
 *    - All these statements are executed in parallel.
 *      So every LHS will take the value of the RHS at the moment of entering the block.
 *    - LHS should always be a reg or a vector of reg.  
 *    - RHS can be of type reg or wire .
 *
 * Blocking
 *    - Used only inside an always or initial block.
 *    - The statements are executed in sequence, one after the other
 *    - LHS should always be a reg or a vector of reg.
 *    - RHS can be of type reg or wire .
 * 
 * Continuous
 *    - Signals of type wire require continuous assignment of a value.
 *    - Used when you connect gates together.
 *    - LHS should always be a wire or a vector of wires (It can never be reg).
 *    - RHS can be of type reg or wire. 
 *    - The assignment is always active.
 *      Whenever any operand on the RHS changes in value, LHS will be updated with the new value.
 *    - wires with multiple drivers bits with different values take the value x
 *
 *
 */

module test;
    int a;
    int b;
    int c;
    int d;
    int e;
    int f;

    assign f = a;
    
    initial begin
        a <= 5;
        b <= 23;
        c <= 10;
        d <= 0;

        #10;

        d <= a + b;
        e <= d + c;

        #10;

        d = a + b;
        e = d + c;

        #30
        d = 0;
    end

    initial begin
        $dumpfile("test.vcd");
        $dumpvars;
    end
endmodule