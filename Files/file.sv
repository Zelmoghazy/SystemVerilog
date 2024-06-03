module tb; 
    initial begin
        // integer to hold file descriptor
        int fd;
        // open file with read permission
        fd = $fopen("./file.txt","r");
        if(fd) 
            $display("File was opened successfully : %0d", fd);
        else
            $display("File was not opened successfully : %0d", fd);

        // open file with write permission, overwrite if it exists
        fd = $fopen("./file.txt","w");
        if(fd)
            $display("File was opened successfully : %0d", fd);
        else
            $display("File was not opened successfully : %0d", fd);

        // open file with write permission, append if it exists
        fd = $fopen("./file.txt","a");
        if(fd)
            $display("File was opened successfully : %0d",fd);
        else
            $display("File was not opened successfully : %0d",fd);

        // close the file
        $fclose(fd);
    end
endmodule

module FileReader;

  // Define file handles
  int fd_read, fd_write;

  // Open file for reading
  initial begin
    fd_read = $fopen("data.txt", "r");
    if (fd_read == 0) begin
      $display("Error opening file for reading");
      $finish;
    end
  end

  // Open file for writing
  initial begin
    fd_write = $fopen("output.txt", "w");
    if (fd_write == 0) begin
      $display("Error opening file for writing");
      $finish;
    end
  end

  // Read data from file and write to another file
  initial begin
    int variable1, variable2;
    // returns one if end of file is reached
    while (!$feof(fd_read)) begin
      // Read two integers from file
      int num_vars = $fscanf(fd_read, "%d %d", variable1, variable2);
      
      // Check if fscanf read both variables successfully
      if (num_vars == 2) begin
        // Display the read variables
        $display("Read variables: %d, %d", variable1, variable2);
        
        // Write the read variables to another file
        $fdisplay(fd_write, "Read variables: %d, %d", variable1, variable2);
      end
    end
  end

  // Close file handles
  initial begin
    $fclose(fd_read);
    $fclose(fd_write);
  end

endmodule

