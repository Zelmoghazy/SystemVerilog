/* 

    function mem_mode return_type function_name (direction_of_arg arg_data_type arg_name, ... );
        begin
            // code
            function_name = returned_value;  // if you want to return value at the end of function execution

            return returned_value;           // immediately end function execution and return value

        end
    endfunction

    - mem_mode: static or automatic (default : static)
    - return_type: type+length, can't be "wire", can be "void" if you dont want to return (default: logic)
    - function_name : variable naming rules
    - direction of arg: input, output, inout
    - arg_data_type: type+length, cant be "wire" (default: logic)
    - arg_name: variable naming rules

    * Example :

        function static int sum (input int x, input int y);
            begin 
                automatic int result;
                result = x+y;

                sum =  result;
            end
        endfunction

    -   An argument can have only one direction: input, output, inout, or ref. 
        If you don’t specify a direction for the first argument, it is implicitly ‘input’.
        The implicit directions for the arguments that follow use the previous arguments direction.

    -   inputs are copied by value upon entry to the task/function.
    -   outputs are copied on return.
    -   inout are copied on entry and return.
    -   ref arguments are never copied. They are direct references to the actual argument variable.    

    -   Functions have only input arguments, and the function returns a value, 
        and the value must be used, as in an assignment statement. 
        Sometimes the function is void, i.e. it returns no value.

    - A function cannot have a :
        - delay, #100
        - a blocking statement such as @(posedge clock) or wait (ready),
        - call a task.

    In SystemVerilog, if you want to call a function and ignore its return value, cast
    the result to void, as follows:
            - void' ($fscanf (file, "%d", i));
 */

module functions_1();
    /* 
        In System Verilog, you can specify that an argument is passed by reference,
        rather than copying its value

        Using the const modifier. As a result, the contents of the array
        cannot be modified. If you try to change the contents.
        the compiler prints an error.
     */
    function void print_checksum(const ref bit [31 :0] a []) ;
        // a is a dynamic array of bit [31:0]
        bit [31 :0] checksum = 0;
        for (int i=0; i<a.size() ; i++)
            checksum ^= a[i]; // XOR of the array elements
        $display("The array checksum is %0d" , checksum) ;
    endfunction

    initial begin
        bit [31 :0] w[] ={21, 17, 7};
        print_checksum(w) ;
    end
endmodule

/* Note that the default type for the first argument is a single-bit input 
   Argument type is sticky with respect to the previous argument.
        - task sticky(int a, b); The two arguments are input integers
        - task sticky(ref int array [50] , int a, b); a is ref int and b is ref int
*/

module functions_2 () ;
    function void print_checksum(ref bit [31 :0] a [] ,
                                 input bit [31 :0] low = 0 ,  // default argument value
                                 input int high = -1) ;

        bit [31 :0] checksum;
        checksum = 0;

        if (high == -1 || high >= a.size())
            high = a.size()-1;

        for (int i = low; i<=high; i++)
            checksum += a[i] ;

        $display ("The array checksum is %0d", checksum);
    endfunction

    initial begin
        bit [31 :0] w[] = {21, 17, 7, 50, 10};

        print_checksum (w);
        print_checksum (w,2,4);     // checksum a[2:4]
        print_checksum (w,1);
        print_checksum (w,,2);
        //print_checksum();         // compiler error as a has not default value
    end
endmodule

/* Returning an array from a function */

module functions_3 () ;
    typedef int fixed_array5[5];  // define a type
    fixed_array5 f5;              // declare a variable
    
    function fixed_array5 init (int start) ; // consumes memory -> copy
        foreach (init [i])
            init[i] = i + start;
    endfunction

    initial begin
        /*  
            the function init creates an array, which is copied into the array f5.
            If the array was large, this could be a large performance problem.
         */
        f5 = init(5); // two memory spaces are consumed
        foreach(f5[i])
            $display("f5[%0d] = %0d" , i, f5[i]) ;
    end
endmodule

/*  
    Here init takes a reference to the array and populate it
 */
module test_2();
    function void init (ref int f[5], input int start) ;
        foreach(f[i])
            f[i] = i + start;
    endfunction

    int fa[5] ; // only one memory space is consumed

    initial begin
        init (fa,5);
        foreach(fa[i])
            $display(" fa [%0d] = %0d", i, fa[i]) ;
    end
endmodule