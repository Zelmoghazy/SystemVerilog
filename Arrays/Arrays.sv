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
        $display("2: descend : ", descend) ;

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
        bit [31 :0] src [5];
        bit [31 :0] dst [5];

        /* The SystemVerilog function $size returns the size of the array. */
        for (int i = 0; i < $size(src); i++)
            src[i] = i;

        /* The index variable is automatically declared for you and is local to the loop. */
        foreach(dst[j]) // j is automatically declared
            dst[j] = src[j] * 2;
        
        foreach (src [j])
            $display("src[%0d]= %b = %0d    dst[%0d] = %b = %0d",j,src[j],src[j],j,dst[j],dst[j]);
    end
endmodule

module arrays_4();
    initial begin
        int two_d[3][5];
        foreach (two_d[i,j])
            two_d[i][j] = 10*i+j;
        foreach (two_d[i]) begin
            $write ("%2d:",i);
            foreach (two_d[,j]) 
                $write ("%3d",two_d[i][j]);
            $display
        end
    end
endmodule
