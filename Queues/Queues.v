// int x[$]        -> Queue
// int x[5]        -> fixed array
// int x[]         -> dynamic array
// int x[string]   -> associative array


module arrays();
    int j = 9;
    int q1[$] = {6,7,5}; // Note that queues dont need '

    initial begin
      $display ("Initial: ",q1);

      q1.insert(1,j);
      $display("After inserting at index 1 : ", q1); // {6,9,7,5}

      q1.delete(2);
      $display("After deleting element at index 2 : ", q1); // {6,9,5}

      q1.push_front(12);
      $display("After pushing at front : ", q1); // {12,6,9,5}

      j = q1.pop_back;
      $display("J: ", j); // 5
      $display("After pop from the back : ", q1); //{12,6,9}

      q1.push_back(8);  // {12,6,9,8}
      $display("After pushing at the back : ", q1);

      j = q1.pop_front; // {6,9,8}
      $display("J: ", j);
      $display("After pop from the front : ", q1);

      q1.delete();
      $display("After deleting the queue : ", q1);
    end
endmodule
