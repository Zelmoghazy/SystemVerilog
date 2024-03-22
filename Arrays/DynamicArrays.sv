module arrays ();
    int dyn [], d2 [];
    initial begin
        dyn = new [5];       // Allocate 5 elements
        foreach (dyn[j])  
            dyn [j] = j;
        d2 = dyn;            // copy dynamic array
        d2 [0] = 5;
        $display(dyn,d2);

        dyn = new[20](dyn);  // Allocate 20 elements and copy
        $display(dyn);

        dyn = new[40];       // Allocate 40 elements, old values are lost
        $display(dyn);
        $display("Size = %0d",$size(dyn));

        dyn.delete();        // Delete all elements
        $display(dyn);
    end
endmodule

