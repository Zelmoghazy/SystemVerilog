//  Reduction Methods

/* 
    A basic array reduction method takes an array and reduces it to a single value
        - SystemVerilog's rules for handling the width of operations. 
          By default, if you add the values of a single-bit array, the result is a single bit.
        - Other array reduction methods are product, and, or, and xor.
 */

module reduction_1();
    bit on [10] ;                   // Array of single bits
    int total;

    initial begin

        // on[i] is a single bit either 1 or 0
        foreach (on[i])
            on[i] = i;             // on[i] gets 0 or 1

        // Print the single-bit sum
        $display ("on.sum= %0d", on.sum);   // on.sum 1

        // Compute with 32-bit signed arithimetic
        $display ("int sum=%0d", on.sum with(int'(item)));
    end
endmodule

module reduction_2 () ;
    int count, total, d[] = '{9,1,8,3,4,4};

    initial begin

        count = d.sum with (int'(item > 7));
        $display(count) ;
    
        total = d.sum with ((item > 7) * item) ;
        $display(total) ;
    
        count = d.sum with (int'(item < 8));
        $display(count) ;
    
        total = d.sum with (item < 8 ? item : 0) ;
        $display(total ) ;
    
        count = d.sum with (int' (item == 4)) ;
        $display(count) ;
    end
endmodule


// Locator Methods

/* 

    - The array locator methods find data in an unpacked array.
    - These methods always return a queue.
*/

module locator_1();
    int f  [6] = '{1,6,2,6,8,6};  // Fixed array
    int d  []  = '{2,4,6,8,10};   // dynamic array
    int q  [$] =  {1,3,5,7};
    int tq [$];

    initial begin
        tq = q.min;
        $display(tq);

        tq = d.max;
        $display(tq);

        tq = f.unique;
        $display(tq);
    end
endmodule


/* 
    - The with expression tells SystemVerilog how to perform the search
    - In a with clause, the name item is called the iterator argument 
      and represents a single element of the array.
    - You can specify your own name by putting it in the argument list of the array method.
                tq = d.find_first(x) with (x>4);
    - The array locator methods that return an index, such as find_index,
      return a queue of type int, not integer.
    - Your code may not compile if you use the wrong queue type with these statements.
        - int : 2-state SystemVerilog data type, 32 bit signed integer
        - integer : 4-state Verilog data type, 32 bit signed integer


 */

module locator_2();
    initial begin
        int d[] = '{9,1,8,3,4,4};
        int tq[$];

        foreach(d[i])
            if(d[i] > 3)
                tq.push_back(d[i]);
        $display(tq);

        tq.delete();

        // equivalent to
        tq = d.find with (item > 3);
        $display(tq);


        tq = d.find_index with (item > 3);          // {0,2,4,5}
        $display(tq);

        tq = d.find_first with (item > 99);         // {}
        $display(tq);

        tq = d.find_first_index with (item == 8);   // {2}
        $display(tq);

        tq = d.find_last with (item == 4);          // {4}
        $display(tq);

        tq = d.find_last_index with (item == 4);    // {5}
        $display(tq);
    end
endmodule


// Sorting & Ordering
/* 
    - Notice that these methods change the original array,
      unlike the array locator methods which create a queue to hold the results.
*/
module sorting_ordering () ;
    initial begin
        int d[] = '{9,1,8,3,4,4};
        $display( "Original Array: ", d) ;

        d.reverse();
        $display( "Reversed Array: ", d) ;

        d.sort();
        $display( "Sorted Array: ", d) ;

        d.rsort();
        $display( "Reverse Sorted Array: ", d) ;

        d.shuffle();
        $display( "Shuffled Array: ", d) ;
    end
endmodule

// Building a scoreboard
module arrays () ;
    typedef struct{
        bit [7:0] addr;
        bit [7:0] pr;
        bit [15:0] data;
    } Packet; // user defined type

    Packet scb[$] ; //Scoreboard is defined as a queue of packets .


    /* looks up an address in the scoreboard. */
    function void check_address ([7:0] address);
        int intq[$] ; //a queue to receive results of locator methods
        intq = scb.find_index() with (item.addr == address) ;
        case (intq.size())
            0 : $display("Addr %0d not found in scoreboards ", address);
            1 : scb.delete(intq[0]) ; // delete the found record from the scoreboard
            default : $display( "ERROR: Multiple hits for addr %0d " , address );
        endcase
    endfunction

    initial begin //fill the scoreboard
        scb.push_front('{100, 2, 365});
        scb.push_front('{95, 1, 425});
        scb.push_front('{54, 0, 177});

        $display(scb);

        check_address (101);
        check_address (95);
        $display(scb) ;
    end
endmodule