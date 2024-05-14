
// define a class called widget with two members
class widget;
    int id;
    bit to_remove;
endclass

module top;
    widget q[$];  // declare a queue of class widget object type.
    initial begin
        widget w; // declare an object of type widget
        int num = $urandom_range(20,40); // generate a random int between (20 - 40)
        for(int i = 0; i<num; i++) begin
            w = new;
            w.id = i;
            w.to_remove = $urandom_range(0,1);  // generate either 1 or 0 randomly
            q.push_back(w);
            $display("Widget id: %2d, to_remove: %b",q[$].id,q[$].to_remove);
        end

        // remove entries from q that have “to_remove = 1”.
        for (int i = 0; i<q.size; i++) begin
            if(q[i].to_remove == 1) begin
                q.delete(i);
                i--;
            end
        end            

        // to check that no entry in q has “to_remove = 1”.

        int flag = 0;

        foreach(q[i]) begin
            if(q[i].to_remove == 1) begin
                $display("widget has entries with to_removed");
                flag = 1;
                break;
            end
        end

        if(flag == 1)
            $display("widget has entries to be removed");
        else
            $display("widget has no entries to be removed")

    end
endmodule