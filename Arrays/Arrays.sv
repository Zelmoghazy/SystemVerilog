/*
    If your code accidently tries to read from an out-of-bounds address,
    SystemVerilog will return the default value for the array element type:
        - That just means that an array of 4-state types, such as logic, will return X’s.
        - whereas an array of 2-state types, such as int or bit, will return 0.
 */


module arrays_1 ();
/* 
    Verilog requires that the low and high array limits must be given in the declaration.
    Since almost all arrays use a low index of 0, SystemVerilog lets you use the shortcut
    of just giving the array size, which is similar to C’s style. 
*/
    int lo_hi [0:15] ; // 16 ints [0] .. [15]
    int c_style [16] ; // 16 ints [0] .. [15]

    int array2 [0:7][0:3]; // Verbose declaration
    int array3 [8][4];     // Compact declaration

    reg[3:0] array4[4];   // Array of 4 registers each is 4-bits

    initial begin
        lo_hi  [3]    = 234 ; // Set one array element
        array2 [7][3] = 1;    // Set last array element
    end
endmodule

module arrays_2 () ;
/*
    You can initialize an array using an array literal,
    which is an apostrophe followed by the values in curly braces. '{} 
*/ 
    int ascend  [4] = '{0,1,2,3}; // Initialize 4 elements
    int descend [5] ;           

    initial begin
        $display("1: ascend  : ", ascend) ;
        $display("2: descend : ", descend) ;  // default value = zeroes -> int is 2-state

        descend = '{4,3,2,1,0};   // Set 5 elements
        $display("3: descend : ", descend) ;

        descend [0:2] = '{5, 6, 7}; // Set first 3 elements {5,6,7,1,0}
        $display("4: descend : ", descend) ;

        ascend  = '{4{8}} ;         // Four values of 8 {8,8,8,8}
        descend = '{default :-1};   // specify a default value {-1, -1, -1, -1, -1}
        $display("5: ascend  : ", ascend) ;
        $display("6: descend : ", descend) ;
    end
endmodule

module arrays_3 () ;
    initial begin
        bit [31:0] src [5];
        bit [31:0] dst [5];

        /* The SystemVerilog function $size returns the size of the array. */
        for (int i = 0; i < $size(src); i++)
            src[i] = i;

        /* The index variable is automatically declared for you and is local to the loop. */
        foreach(dst[j]) // j is automatically declared
            dst[j] = src[j] * 2;
        
        foreach(src [j])
            $display("src[%0d]= %b = %0d    dst[%0d] = %b = %0d",j,src[j],src[j],j,dst[j],dst[j]);
    end
endmodule

/* 
    foreach for a two-dimensional array, it must be written as follows:
         array_name[i,j], not array_name[i][j]

    In the normal use of the multi-dimensional array, each index must be
    written in a separate pair of square brackets. i.e. array_name[i][j].
*/
module arrays_4();
    initial begin
        int two_d[3][5];            // 3 rows and 5 columns

        // initialize 2d array with default elements
        two_d = '{'{default:1},'{default:2},'{default:3}};

        foreach (two_d[i]) begin    // Step through the rows
            $write ("%2d:",i);      // write in a buffer
            foreach (two_d[,j])     // Step through the columns
                $write("%3d",two_d[i][j]);
            $display;
        end

        // initialize 2d array
        foreach (two_d[i,j])
            two_d[i][j] = 10*i+j;

        foreach (two_d[i]) begin    // Step through the rows
            $write ("%2d:",i);      // write in a buffer
            foreach (two_d[,j])     // Step through the columns
                $write("%3d",two_d[i][j]);
            $display;
        end
    end
endmodule

/* 
    You can perform aggregate compare and copy of arrays without loops. 
    (An aggregate operation works on the entire array as opposed to working 
    on just an individual element.)
        - Comparisons are limited to just equality and inequality.
        - You cannot perform aggregate arithmetic operations such as addition on arrays.

*/
module arrays_5 ();
    initial begin
        bit [31:0] src [5] = '{0, 1, 2, 3, 4};
        bit [31:0] dst [5] = '{5, 4, 3, 2, 1};

        // Aggregate compare the two arrays
        if (src==dst)
            $display("src = dst");
        else
            $display("src != dst");
        
        // Aggregate copy all src values to dst
        dst = src;
        $display ("src %s dst" , (src == dst) ? "==" : "!=") ;

        // Change just one element
        src [0] = 5;
        $display ("src %s dst" , (src == dst) ? "==" : "!=") ;

        // Use array slice to compare elements 1-4
        $display("src [1:4] %s dst [1:4]", (src [1 :4] == dst [1 :4]) ? "==" : "!=") ;
    end
endmodule

module arrays_6 ();
    initial begin
        bit [31 :0] src [5] = '{5{5}};

        foreach (src[j])
            $displayb("src[%0d] = %b",j,src[j]);  // display in binary format.
        
        // prints the first array element (binary 101), its lowest bit (1), and the next two higher bits (binary 10).
        $displayb(src[0],,src[0][0],,src[0][2:1]); // two comas “, ,”  to leave a blank space
        
    end

endmodule

module arrays_7;
  bit [12:0] dt_bit[4];
  
  initial begin
    dt_bit = '{12'h012,12'h345,12'h678,12'h9AB};
    
    for(int i = 0; i < $size(dt_bit); i++)
    /* print out first 4-bits only */
      $display("%x",dt_bit[i][3:0]);
    
    foreach(dt_bit[i])
      $display("%x",dt_bit[i][3:0]);
    
  end
endmodule