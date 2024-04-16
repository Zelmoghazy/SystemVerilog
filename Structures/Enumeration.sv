module enum_1();
    // Create data type for values 0, 1, 2
    typedef enum {
        INIT,
        DECODE,
        IDLE
    }fsmstate_e;

    fsmstate_e pstate, nstate; // declare typed variables

    initial begin

        $display(pstate);
        /*
            You can get the string representation of an enumerated variable
            with the built-in function name(). 
         */
        $display(pstate.name);

        case (pstate)
            IDLE: nstate = INIT;    // data assignment
            INIT: nstate = DECODE;
            default: nstate = IDLE ;
        endcase

        $display("Next state is %s", nstate.name) ; // Display symbolic state name
    end
endmodule

/* 
    SystemVerilog provides several functions for stepping through enumerated types.
        - first(): returns the first member of the enumeration.
        - last(): returns the last member of the enumeration.
        - next(): returns the next element of the enumeration.
        - next (N): returns the Nth next element.
        - prev (): returns the previous element of the enumeration.
        - prev (N): returns the Nth previous element.
    The functions next and prev wrap around when they reach the beginning or end of the enumeration.

 */

module enum_2();
    typedef enum {
        RED,
        BLUE=3,
        GREEN
    }color_e;

    color_e color;
    initial begin
        color = color.first;
        do begin
            $display("Color = %0d/%s",color,color.name);
            color = color.next;
        end
        while(color != color.first); //Done at wrap-around
    end
endmodule