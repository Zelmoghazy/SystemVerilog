// int x[$]        -> Queue
// int x[5]        -> fixed array
// int x[]         -> dynamic array
// int x[string]   -> associative array

/* 
    - A queue is declared with square brackets containing a dollar sign: [$]. 
    - Queue literals only have curly braces, and are missing the initial apostrophe of array literals.
*/
module queue_1();
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


/* 
    - If you put a $ on the left side of a range, such as [$:2], the $ stands for the minimum value.
    - If you put $ on the right side, as in [1:$], stands for the maximum value.
*/
module queue_2();
    int j     = 1;
    int q2[$] = {3,4};
    int q[$]  = {0,2,5};

    initial begin

        q = {q[0], j, q[1:$]};     // $ : to the end -> {0,1,2,5}

        q = {q[0:2], q2, q[3:$]};  // {0,1,2,3,4,5}

        q = {q[0], q[2:$]};        // {0,2,3,4,5}

        q = {6,q};                 // equivalent to push front ->   {6,0,2,3,4,5}

        j = q[$];                  // Last element of queue -> j = 5
        
        q = q[0:$-1];              // equivalent to pop_back ->  {6,0,2,3,4}

        q = {q,8};                 // equivalent to push_back -> {6,0,2,3,4,8}

        j = q[0];                  // First element of queue -> j = 6

        q = q[1:$];                // equivalent to pop_front -> {0,2,3,4,8}

        q = {}                     // Delete entire queue
    end
endmodule

module queue_3();
    int array[8] = '{5, 10, 7, 4, 3, 5, 7, 8};
    int queue[$];
    initial begin
        queue = array.unique;   // '{5, 10, 7, 4, 3, 8}
        $display(queue);
    end
endmodule

module queue_4;
  // Declare a parameter for the maximum number of elements
  parameter MAX_ELEMENTS = 256;

  initial begin
    // adding an upper bound to the queue
    // Addition of new element beyond the upper bound of the queue shall be ignored.
    int my_queue[$:MAX_ELEMENTS];

    int i;
    for (i = 0; i < MAX_ELEMENTS; i++) begin
      my_queue.push_back($random);
    end
    // Display the queue contents
    $display("Queue contents:");
    foreach (my_queue[i]) begin
      $display("%d", my_queue[i]);
    end
  end
endmodule

module queue_5();
    int c[$], b[$], a[$] = '{6,9,23,63,2,6,1,1,2,7};

    initial begin
        int i;
        $display(a);
        b = a.unique();
        while(b.size() != 0) begin
            i = $urandom_range(0,b.size()-1);
            c.push_front(b[i]);
            b.delete(i);
        end
        $display(c);
    end
endmodule
