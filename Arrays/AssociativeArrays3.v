module arrays();
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

        if(switch.exists("max_address"))   // check if it exists first before searching
            high = switch["max_address"];
        else
            high = 1000;
        
        // print file contents
        foreach(switch[j])
            $display("switch[%s] = %0d",j,switch[j]);
    end
endmodule