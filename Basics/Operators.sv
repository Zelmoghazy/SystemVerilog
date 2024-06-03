/* 
    Operator Precedence
    -------------------
        1- Unary, Multiply, Divide, Modulus
        2- Add, Subtract, Shift.
        3- Relation, Equality
        4- Reduction
        5- Logic
        6- Conditional

 */

// Relational Operators
module relational;
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] x;

    initial begin
        a = 45;
        b = 9;

        $display("Result for %0d >= %0d: %b",a,b,a >= b) ;

        a = 8'b00001z01;
        b = 45;
        $display ("Result for %0d <= %0d: %0d", a ,b, a <= b);

        a = 9;
        b = 8;
        $display ("Result for %0d > %0d: %0d",a ,b, a > b);

        a = 22;
        b = 22;
        $display ("Result for %0d < %0d: %0d", a , b, a < b) ;

        $display("Result for %0d < %0d: %0d", x, a, x < a);

        /* Note: If a value is x or z, then the result of that test is false */
        if(x<a)
            $display("path 1");
        else
            $display("path 2");
    end
endmodule

// Arithmetic Operators
module arith;
    reg[7:0] a;
    reg[7:0] b;

    int c;
    int d;

    initial begin
        a = 45;
        b = 6;

        $display ("Result for %0d + %0d: %0d", a, b, a + b);

        $display ("Result for %0d - %0d: %0d", a,b, a - b);

        $display ("Result for %0d * %0d: %0d", a, b, a * b) ;

        $display ("Result for %0d / %0d: %0d", a, b, a / b) ;

        $display ("Result for %0d %% %0d: %0d", a, b, a % b) ;

        $display ("Result for %0d ** 3: %0d" , b, b ** 3) ;

        /* Register data types are used as unsigned values */
        a = -31;
        b =   4;
        $display ("Result for %0d %% %0d: %0d", a, b, a % b);

        a =   4;
        b = -31;
        $display ("Result for %0d %% %0d: %0d", a, b, a % b);

        c = -31;
        d =   4;
        $display ("Result for %0d %% %0d: %0d", c, d, c % d);

        c =   4;
        d = -31;
        $display ("Result for %0d %% %0d: %0d", c, d, c % d);

        c =   -4;
        d =  -31;
        $display ("Result for %0d %% %0d: %0d", c, d, c % d);

        /* If any operand bit value is the unknown value x, or z then the entire result value is x */
        a = 8'b00001111;
        b = 8'b01z00000;
        $display ("Result for %b + %b : %b", a, b, a + b) ;

        a = 5;
        b = 14;
        $display ("Result for %0d - %0d: %b" , a, b, a - b) ;
    end
endmodule

// Equality Operators
module equality;
    reg [7:0] a;
    reg [7:0] b;

    initial begin
        a='b11x0;
        b='b1100;
        /* exact comparison, including x and z (result 1 or 0) */
        $display ("Result for %0b === %0b: %0d", a,b, a === b);

        a='b11x0;
        b='b1100;
        /* a equal to b, result may be x if either operand contains an x or a z (result 1, 0, or x) */
        $display ("Result for %0b == %0b : %0d", a,b, a == b);

        a='b111100;
        b='b1100;
        $display("Result for %0b == %0b: %0d", a ,b, a == b);

        a='b001100;
        b='b1100;
        $display ("Result for %0b == %0b : %0d", a,b, a == b);

        a='b11x0 ;
        b='b11x0 ;
        $display ("Result for %0b === %0b: %0d", a,b, a === b);

        a='b11z0;
        b='b11x0;
        $display ("Result for %0b === %0b: %0d", a ,b, a === b);

        a='b11x0 ;
        b='b11x0 ;
        $display ("Result for %0b == %0b: %0d", a ,b, a == b);

    end
endmodule


// Logical Operators 
module logical;
    reg [7:0] a;
    reg [7:0] b;

    initial begin

        a='b1110;
        b='b1100;
        // if result != 0 -> 1
        $display("Result for %0b && %0b: %0d", a, b, a && b) ;

        a='b1110;
        b='b0000;
        $display("Result for %0b && %4b: %0d", a, b, a && b) ;

        a='b11x0;
        b='b1100;
        $display("Result for %0b && %0b: %0d", a, b, a && b) ;

        a='b00x0;
        b='b1110;
        // cannot be determined 'b00x0 -> x
        $display("Result for %4b && %0b: %0d", a, b, a && b) ;

        a='b00z0;
        b='b1110;
        $display("Result for %4b && %0b: %0d", a ,b, a && b) ;

        a='b11z0;
        b='b1100;
        $display("Result for %4b && %0b: %0d", a ,b, a && b) ;

        a='b0011;
        b='b1100;
        $display("Result for %4b || %0b: %0d", a, b, a || b) ;

        /* logic negation (converts non zero value to 0 and vice versa) */
        a='b1100;
        $display("Result for ! %4b: %0d", a, !a) ;

        a='b0000;
        $display("Result for ! %4b: %0d", a, !a) ;

        a='b1x00 ;
        $display("Result for ! %4b: %0d", a, !a) ;

        a='bxxxx ;
        $display("Result for ! %4b: %0d", a, !a) ;
    end
endmodule

// Bit-Wise Operators
module bitwise;

    reg [3:0] a;
    reg [3:0] b;

    initial begin

        a='b1110;
        b='b1100;
        $display("Result for %0b & %0b: %4b", a, b, a & b) ;


        a='b11x0;
        b='b1100;
        $display("Result for %0b & %0b: %4b", a ,b,a & b) ;

        a='b00x0;
        b='b1110 ;
        $display("Result for %4b & %0b: %4b", a ,b ,a & b) ;

        a='b00z0;
        b='b1110;
        $display("Result for %4b & %0b: %4b", a ,b ,a & b) ;


        a='b11z0;
        b='b1100;
        $display("Result for %4b | %0b: %4b", a ,b,a | b) ;

        a='b0011;
        b='b1100;
        $display("Result for %4b | %0b: %4b" , a ,b ,a | b) ;

    end 
endmodule


// Reduction Operators
module reduction;

    reg [7 :0] a;

    initial begin

        a='b11101111;
        // reduce all bits using and function
        $display("Result for & %8b: %0b" , a, &a);

        a='b11101x11;  
        $display("Result for & %8b: %0b", a, &a);

        a='b11111x11; 
        $display("Result for & %8b: %0b", a, &a);

        a='b11111011;   
        $display("Result for ^ %8b: %0b", a, ^a);

        a='b11001010;   
        $display ("Result for ^ %8b: %0b", a, ^a);

        a='b11001010;   
        $display ( "Result for | %8b: %0b", a, |a) ;

    end
endmodule



module shift;

    reg [7:0] data;
    int i;

    initial begin
        data = 8'b0000101;
        $display("Original data = %8b", data);

        for (i = 0; i < 9; i += 1 ) begin
            $display ("data << %0d = %8b", i, data << i );
        end

        data = 8'b11000000;
        $display ("original data= %8b", data) ;

        for (i = 0; i < 9; i += 1  ) begin
            $display ("data >> %0d = %8b", i, data >> i) ;
        end 
    end
endmodule


// Concatenation Operators
/*
    - Unsized constant numbers are not allowed in concatenations
    - Nested concatenations are possible: 
        {b, {3{c, d}}} -> equivalent to {b, c, d, c, d, c, d}
*/
module concat;
    reg a;
    reg b;
    reg [2:0] c;
    reg [1:0] short_result ;
    reg [7:0] result ;

    initial begin
        a = 1;
        b = 0;
        c = 3'b110;

        $display("a = %b, b = %b, c = %b", a, b, c);

        short_result = {a,b};
        $display("{a,b} = %b" , short_result);

        result = {b, a, c[1:0], 3'b001, c[2]};
        $display("{b, a, c[1:0], 3'b001, c[2]} = %b", result);

        $display("{3{c}} = %b", {3{c}});

        $display("{b,{3{c,a}}} = %b", {b,{3{c ,a}}});
    end
endmodule





// Conditional Operator
module Conditional_Operator (
    input logic [7:0] input_a,
    input logic [7:0] input_b,
    input logic condition,
    output logic [7:0] output
);

    // Using conditional operator to select between input_a and input_b based on condition
    assign output = condition ? input_a : input_b;

endmodule



// Streaming Operators

/*
    The streaming operators perform packing of bit-stream 
    into a sequence of bits in a user specified order
        - “>>” causes blocks of data to be streamed in left-to-right order
        - “<<” causes blocks of data to be streamed in right-to-left order
    - The slice_size determines the size of each block, measured in bits.
         If a slice_size is not specified, the default is 1.
    - Left-to-right streaming using >> shall cause the slice_size to be ignored and no re-ordering performed.
*/

module streaming_1() ;
    initial begin
        byte a = 8'h8C;
        byte b = 8'h00;
        byte c = 8'hA4;
        byte d = 8'hFF;

        int value = {>>{a, b, c, d}} ; // pack

        $display("%x",value); //8c00a4ff
    end
endmodule


module streaming_2() ;
    initial begin
        bit [7:0] array [4] = '{8'h8c, 7'h00, 8'hA4, 8'hFF} ;
        $display(array);

        int value = {<<8{array}} ;
        $display("%x",value) ;

        /* Reverse the nibbles << 4 */
        value = {<<4{array}} ;
        $display("%x",value) ;

        /* Reverse bits of an array << */
        value = {<<{array}} ;
        $display("%x",value) ;
    end
endmodule
