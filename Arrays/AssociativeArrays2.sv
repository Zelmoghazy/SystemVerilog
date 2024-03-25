module arrays();
    initial begin
        bit[39:0] assoc[int];
        int idx = 1;

        // Initialize widely scattered values
        repeat(20) begin
            assoc[idx] = idx*3;
            idx = idx << 1; // idx = idx * 2
        end

        // Step through array elements using foreach
        foreach(assoc[i])
            $display("assoc[%0d] = %0d", i, assoc[i]);

        // Step through array elements using functions
        if(assoc.first(idx))begin // if array is not empty
            do
                $display("assoc[%0d] = %0d", idx, assoc[idx]);
            while(assoc.next(idx)); // if there is a next element
        end

        // find and delete the first element
        $display("The array before deletion has %0d elements", assoc.num);

        assoc.first(idx);    // get first element key in idx
        assoc.delete(idx);   // delete first element

        $display("The array now has %0d elements",assoc.num);
    end
endmodule
    