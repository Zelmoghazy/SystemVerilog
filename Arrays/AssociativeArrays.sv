/* 
    - associative arrays allow any data type to be used as the index.
    - good solution when you want to access few location on a very large address space
    - Associative arrays dont have any storage allocated until it is used.
*/

module associative_1();
    // associative array is declared with a data type in square brackets
    int scoreboard[string];
    // * indicates the array has unspecified index, can be anything
    int a_array1[*] ;
    int expected_output;

    initial begin
        scoreboard["alu"]     = 10 ;
        scoreboard["ecu"]     = 50 ;
        scoreboard["storage"] = 100;
        scoreboard["cpu"]     = 150;

        $display("number of elements of associative array = %d",scoreboard.num());
        $display("number of elements of associative array = %d",scoreboard.size());

        expected_output = scoreboard["cpu"];
        $display(expected_output);

        // iterating through the associative array alphabetically
        foreach(scoreboard[key]) begin    
            $display("Key: %s, Value: %d",key,scoreboard[key]);
        end
    end
endmodule

module associative_2();
    initial begin
        bit[39:0] assoc[int];
        int idx = 1;

        // Initialize widely scattered values
        repeat(20) begin
            assoc[idx] = idx*3;
            idx = idx << 1;      // idx = idx * 2
        end

        // Step through associative array elements using foreach
        foreach(assoc[i])
            $display("assoc[%0d] = %0d", i, assoc[i]);

        // Step through associative array elements using functions
        if(assoc.first(idx)) begin // if array is not empty
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


module associative_3();
    int switch[string]; // Associative array searchable by a string
    int low, high;

    initial begin
        int i, myfile;
        string s;

        myfile = $fopen("switch.txt","r");  // open file in reading mode

        while(!$feof(myfile)) begin         // as long as I didnt reach end of file
            $fscanf(myfile,"%d %s",i,s);    // Read line by line
            switch[s] = i;                  // fill the associative array
        end

        $fclose(myfile);                    // close the file after finishing

        low = switch["min_address"];

        // If you try to read an element that has not been written
        // SystemVerilog returns the default value for the array type
        if(switch.exists("max_address"))   // check if it exists first before searching
            high = switch["max_address"];
        else
            high = 1000;
        
        // print file contents
        foreach(switch[j])
            $display("switch[%s] = %0d", j, switch[j]);
    end
endmodule