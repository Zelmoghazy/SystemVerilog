module arrays();
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
