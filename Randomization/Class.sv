/* 
    - Random stimulus generation in SystemVerilog is most useful when used with OOP.
    - You first create a class to hold a group of related random variables, and then
      have the random-solver fill them with random values.
    - You can create constraints to limit the random values to legal values, or to test- specific features.
 */

program test;
    class Packet;
        // The random variables
        rand  bit [31:0] src, dst, data[8];
        randc bit [7:0]  kind;  // random cyclic -> random solver does not repeat a random value until every possible value has been assigned.

        // Limit the values for src
        // constraint expression is grouped using curly braces:{}.
        constraint c {src > 10 ;
                      src < 1.5;}
    endclass

    Packet p; // Instantiate class
    initial begin
        p = new();  // Create a packet
        // The randomize () function assigns random values to any variable
        // in the class that has been labeled as rand or randc
        // and also makes sure that all active constraints are obeyed
        // Randomization only works with 2-state values.
        assert(p.randomize()) // randomize() may fail incase of conflicting constraints.
        else
            $fatal (0, "Packet: randomize failed"
        $display(p);
    end
endprogram