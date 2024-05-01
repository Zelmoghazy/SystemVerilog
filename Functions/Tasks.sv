/* 
    Tasks may have input and output arguments. The task itself does not return a
    value, but the value of its arguments may change.

    The most important difference is that a task can consume time, whereas a
    function cannot.

    Hint: If you have a SystemVerilog task that does not consume time, you
    should make it a void function, which is a function that does not return a
    value. Now it can be called from any task or function.
 */

module tasks();

    /* 
        In Systemverilog, using begin and end for tasks and functions is optional.
        Tasks have endtask, and functions have endfunction.

        The task / endtask and function / endfunction keywords are enough 
        to define the routine boundaries.
     */
    task multiple_lines;
        $display("First Line");
        $display("Second Line");
    endtask : multiple_lines;

    initial begin
        multiple_lines;
    end

endmodule



module task_2 () ;
    /*  The direction and type default to "input logic“. */
    task mytask(output reg [31 :0] x,input  reg [31 :0] y);
        x = y<<2 ;
    endtask

    initial begin
        int b, a = 12;
        mytask(b, a) ; 
        $display (a) ;
        $display (b) ;  // output argument -> gets changed inside task.
    end
endmodule

module tasks_3() ;
    task many(input int a=1 , b=2 , c=3 , d=4) ;
        $display( "%0d %0d %0d %0d" , a, b, c, d) ;
    endtask

    initial begin
        many(6, 7, 8, 9);
        many();
        /*  you can specify a subset by specifying the name of the argument */
        many (.c(5));
        many (,6,.d(8));
    end
endmodule

module task_4 () ;
    task load_array(int len, ref int array[]) ;
        /* The task needs to return early because of error checking. */
        if (len <= 0) begin
            $display ("Bad len!");
            return;
        end
        // Rest of task code
        for (int i=0; i<len; i++) begin
            array[i] = i*i;
            $display("array [%0d] = %0d",i, array[i]);
        end
    endtask

    initial begin
        int a[];
        a = new[5];
        load_array(0, a) ;
        $display("------------") ;
        load_array(5, a);
    end
endmodule