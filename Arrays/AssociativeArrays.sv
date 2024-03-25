module arrays();
    int scoreboard[string];
    int expected_output;

    initial begin
        scoreboard["alu"]     = 10 ;
        scoreboard["ecu"]     = 50 ;
        scoreboard["storage"] = 100;
        scoreboard["cpu"]     = 150;

        expected_output = scoreboard["cpu"];
        $display(expected_output);

        // iterating through the associative array alphabetically
        foreach(scoreboard[key]) begin    
            $display("Key: %s, Value: %d",key,scoreboard[key]);
        end
    end
endmodule