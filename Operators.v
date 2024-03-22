// Relational Operators
module relational;
    reg [7:0] a;
    reg [7:0] b;

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
    end
endmodule

// Arithmetic 0perators
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
    reg [7: 0] a;
    reg [7 :0] b;

    initial begin
        a='b11x0;
        b='b1100;
        $display ("Result for %0b === %0b: %0d", a,b, a === b);

        a='b11x0;
        b='b1100;
        $display ("Result for %0b == %0b : %0d", a,b, a == b);

        a='b111100;
        b='b1100;
        $display("Result for %0b == %0b: %0d", a ,b, a == b);

        a='b001100 ;
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
    reg [7 : 0] a;
    reg [7 : 0] b;

    initial begin

        a='b1110;
        b='b1100;
        $display("Result for %0b && %0b: %0d", a, b, a && b) ;

        a='b11x0;
        b='b1100;
        $display("Result for %0b && %0b: %0d", a, b, a && b) ;

        a='b00x0;
        b='b1110;
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

        a='b1100;
        $display("Result for ! %4b: %0d", a, !a) ;

        a='b0000;
        $display("Result for ! %4b: %0d", a, ! a) ;

        a='b1x00 ;
        $display("Result for ! %4b: %0d", a, !a) ;

        a='bxxxx ;
        $display("Result for ! %4b: %Cd", a, !a) ;
    end
endmodule

// Bit-Wise Operators
module bitwise;

    reg [3:0] a;
    reg [3:0] b;

    initial begin

        a='b1110;
        b='b1100;
        $display("Result for %0b & %0b: %4b", a ,b ,a & b) ;


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
        $display("Result for & %8b: %0b" , a, &a);

        a='b11101x11;  
        $display("Result for & %8b: %0b", a, &a);

        a='b11111x11; 
        $display("Result for & %8b: %0b", a, &a);

        a='b11111011;   
        $display("Result for ^ %8b: %0b", a, ^a );

        a='b11001010;   
        $display ("Result for ^ %8b: %0b", a, ^a);

        a='b11001010;   
        $display ( "Result for | %8b: %0b", a, |a) ;

    end
endmodule



module shift;

    reg [7 :0] data;
    int i;

    initial begin
        data = 8'b0000101;
        $display("Original data = %8b", data);

        for (i = 0; i < 9 ; i += 1 ) begin
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

module concat;
    reg a;
    reg b;
    reg [2: 0] c;
    reg [1: 0] short_result ;
    reg [7: 0] result ;

    initial begin
        a = 1;
        b = 0;
        c = 3'b110;

        short_result = {a ,b};
        result = {b, a, c[1 :0], 3'b001, c[2]};

        $display("a = %b, b = %b, c = %b", a , b, c);

        $display("{a,b} = %b" , short_result) ;
        $display("{b, a, c[1:0], 3'b001, c[2]} = %b", result);
        $display("{3{c}} = %b", {3{c}}) ;
        $display("{b,{3{c,a}}} = %b", {b,{3{c ,a}}}) ;
    end
endmodule







