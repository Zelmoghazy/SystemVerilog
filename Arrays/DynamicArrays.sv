/*
    - A dynamic array is declared with empty word square brackets [ ] 
      This means that you do not specify the array size in advance; instead, you give it at run-time.

    - The array is initially empty, and so you must call the new[ ] constructor to allocate space
*/

module dyn_arrays ();
    // Declare dynamic arrays
    int dyn [];
    int d2  [];

    int da1 [];
    int da2 [];

    initial begin
        dyn = new [5];       // Allocate 5 elements

        foreach (dyn[j])     
            dyn[j] = j;      // Initialize elements

        d2 = dyn;            // copy dynamic array
        d2[0] = 5;

        $display(dyn,d2);

        dyn = new[20](dyn);  // Allocate 20 elements and copy
        $display(dyn);

        dyn = new[40];       // Allocate 40 elements, old values are lost
        $display(dyn);
        $display("Size = %0d",$size(dyn)); // The $size function returns the size of an array.

        dyn.delete();        // Delete all elements
        $display(dyn);

        /* Append dynamic arrays to each other */
        da1 = new[10];
        foreach (da1[j])     
            da1[j] = j;      // Initialize elements

        da2 = new[10];
        foreach (da2[j])     
            da2[j] = 10+j;      // Initialize elements
        
        $display(da1.size());

        da1 = {da1,da2};

        $display(da1.size());

        $display(da1);

    end
endmodule


module dyn_arrays ();
    int dyn[][];

    initial begin
        dyn = new[2];

        foreach(dyn[i])
            dyn[i] = new[3];

        dyn = '{'{1,12,15},'{3,7,14}};

        foreach(dyn[i])
            $display(dyn[i]);
    end

endmodule