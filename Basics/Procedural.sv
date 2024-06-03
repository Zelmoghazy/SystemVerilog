/* 
    If you have a label on a begin or fork statement, you can put the same label
    on the matching end or join statement. This makes it easier to match the start
    and finish of a block.
 */

module test();
    initial begin : example
        integer array[10], sum, j;
        for (int i = 0 ; i <10 ;i++) 
            array[i] = i;
            
        sum = array[9];
        j=8;
        do 
            sum += array[j];
        while(j--);
        $display("Sum = %4d",sum);
            
    end:example
endmodule


/* 
    If you are in a loop, but want to skip over the rest of the statements and do
    the next iteration, use continue.
    
    If you want to leave the loop immediately, use break.
 */

module test () ;
    initial begin
        bit [127:0] cmd;
        int file, c;

        file = $fopen("command.txt", "r");
        while (!$feof (file)) begin
            $fscanf(file, "%s", cmd) ;
            case (cmd)
                "" : continue;
                "done" : break;
            endcase
            $display("%s" , cmd);
        end
        $fclose (file)
    end
endmodule