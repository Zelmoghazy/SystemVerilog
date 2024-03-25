module arrays();
    int j = 1,
    q2[$] = {3,4},
    q[$]  = {0,2,5};

    initial begin
        q = {q[0], j, q[1:$]};     // $ : to the end -> {0,1,2,5}

        q = {q[0:2], q2, q[3:$]};  // {0,1,2,3,4,5}

        q = {q[0], q[2:$]};        // {0,2,3,4,5}

        q = {6,q};          // equivalent to push front ->   {6,0,2,3,4,5}

        j = q[$];           // Last element of queue -> j = 5
        
        q = q[0:$-1];       // equivalent to pop_back ->  {6,0,2,3,4}

        q = {q,8};          // equivalent to push_back -> {6,0,2,3,4,8}

        j = q[0];           // First element of queue -> j = 6

        q = q[1:$];         // equivalent to pop_front -> {0,2,3,4,8}

        q = {}              // Delete entire queue
    end
endmodule