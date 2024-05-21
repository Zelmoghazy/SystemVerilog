/*
    -   A constraint is just a set of relational expressions that must be true for the chosen
        value of the variables.

    -   constraint expression is grouped using curly braces:{} 

    -   Inside the constraint, we use {}, rather than begin … end

    -   The randomize () function assigns random values to any variable in the class that
        has been labeled as rand or randc, and also makes sure that all active constraints
        are obeyed.
    
    -   Randomization can fail if your code has conflicting constraints
        it is a good practice to put it in an assertion, to detect any conflicting constraints
    
    -   Constraint block can only contain expressions you cannot make an assignment inside it.

    -   You can use $ as a shortcut for the minimum and maximum values for a range.

    -   System Verilog constraints are bidirectional, which means that the constraints on
        all random variables are solved concurrently. Adding or removing a constraint on
        any one variable affects the value chosen for all variables that are related directly
        or indirectly.
    -   At run-time. you can use the built-in constraint_mode() routine to turn constraints on and off.
 */

class Stim;
    const bit [31:0] CONGEST_ADDR = 42;
    typedef enum {READ, WRITE, CONTROL} stim_e;

    randc stim_e kind;
    rand bit [31: 0] len, src, dst;
    randc bit congestion_test;

    // Constraint
    constraint c_stim{
        // there can be a maximum of only one relational operator <, <=, = =, >=, or > in an expression
        len < 1000;
        len > 0;
        // you can use an if statement to change the constraints according to some conditions.
        if(congestion_test){
            dst inside {[CONGEST_ADDR+50:CONGEST_ADDR+100]};
            src == CONGEST_ADDR;
        }else
            src inside {0, [2:10], [100:107], [500:$]};
    }
endclass

program test;
    Stim s;
    initial begin
        s = new();
        for (int i = 1; i <= 5; i++) begin
            assert (s.randomize())
                else $fatal("Conflicting constraints");
            $display(s);
        end
    end
endprogram


/*
    Weighted Distribution 
    - The dist operator allows you to create weighted distributions so that 
      some values are chosen more often than others.
    - The dist operator takes a list of values and weights,
      separated by the “:=” or the “:/” operator.
    - The weights are not percentages and do not have to add up to 100.
    - The := operator specifies that the weight is the same 
      for every specified value in the range.
    - The :/ operator specifies that the weight is to be 
      equally divided between all the values of the range.
    - SystemVerilog supports two implication operators, “->” and 
      “if-else” in constraint definition

*/
class weighted;
    rand int src, dst;

    // constraint
    constraint c_dist {
        src dist {0:=40, [1:3]:=60};
        // [Total = 40+60+60+60 = 220]
        dst dist {0:/40, [1:3]:/60};
        // dst 0 -> weight 40/100
        // dst 1 = dst 2 = dst 3 -> weight = 60/3 = 20
    }
endclass

program test;
    weighted s;
    initial begin
        s = new();
        for (int i = 1; i<=10; i++) begin
            assert (s.randomize())
                else $fatal(0,"Problem");
            $display(s);
        end
    end
endprogram

/* Variable Distribution Weights */

class BusOp;
    typedef enum {BYTE, WORD, LWRD} length_e;
    enum {READ, WRITE} op;
    rand length_e len;

    // weights for dist constraint
    // longword lengths are chosen more often, as w_lwrd has the largest value.
    bit [31:0] w_byte=1, w_word=3, w_lwrd=5;

    constraint c_len{
    // choose a random length using variable weights
        len dist {
            BYTE := w_byte,
            WORD := w_word,
            LWRD := w_lwrd;
        }
    }
    // conditional constraint (you can also use implication operator (->))
    constraint c_len_rw {
        if(op == READ){
            len inside {[BYTE:LWRD]}
        }else
            len == LWRD;
    }
endclass


program test;

    BusOp s;
    initial begin
        s = new();
        for(int j=1; j<=10) begin
            $display(" ");
            for (int i =1; i<=10; i++) begin
                assert(s.randomize())
                    else $fatal(0,"Problem");
                $write(s.op.name, ": ");
                $write(s.len.name,", ");
            end
        end
    end
endprogram


/* Bidirectional Constraints */

class random;
    rand logic [15 :0] r, s, t;
    // constraint blocks are declarative code, all active at the same time.
    // The SystemVerilog solver looks at all four constraints simultaneously.
    constraint c_bidir {
        r <  t ;  // less than t, so r can take any value from [0:28]
        s == r ;
        t <  30;  // can be any value in the range [0:29]
        s >  25;  // s is greater than 25 But at the same time s is equal to r, so it can only be (26,27,27)
    }
endclass

program test;
    random y;
    initial begin
        y = new();
        for (int i = 1; i <= 10; i ++) begin
            assert (y.randomize())
                else $fatal(0 , "Problem in constraints");
            $display("r = %0d, s = %0d, t = %0d", y.r, y.s, y.t);
        end 
    end
endprogram

/* Controlling Multiple Constraint Blocks */

class Packet;
    rand int length;
    constraint c_short {length inside {[1:32]};}
    constraint c_long  {length inside {[1000:1023]};}
endclass

program test;
    Packet p;
    initial begin
        p = new();

        // disable short constraint
        p.c_short.constraint_mode(0);

        assert(p.randomize());
        $display("Length = %0d", p.length);

        //Disable all constraints
        p.constraint_mode(0);
        // Enable short constraint
        p.c_short.consraint_mode(1);

        assert(p.randomize());
        $display("Length = %0d", p.length);
    end
endprogram

/*
    Constraining a Constraint 
        - SystemVerilog allows you to add an extra constraint using randomize () with.
        - inside the with{} statement, SystemVerilog uses the scope of the class.
*/
class Transaction;
    rand bit [31:0] addr, data;
    constraint c1 {addr inside{[0:100] , [1000:2000]};}
endclass

program test;
    Transaction t;
    initial begin
        t = new();
        for (int i=1; i <= 10; i ++) begin
            // addr is 50-100, 1000-1500, data < 10
            assert (t.randomize() with {
                        addr >= 50; 
                        addr <= 1500;
                        data < 10;
                    });

            $display("Addr = %0d, Data= %0d:", t.addr, t.data) ;

            // force addr to a specific value, data> 10
            assert (t.randomize() with {
                        addr = 2000;
                        data > 10;
                        data < 100; 
                    });

            $display("Addr = %0d, Data= %0d:", t.addr, t.data) ;
            $display("----------------") ;
        end 
    end 
endprogram


/* Constraining Array and Queue Elements */

class good;
    rand int len[];
    constraint c_len{
        // constrain individual elements of an array 
        foreach (len[i])
            len[i] inside {[1:255]};
        len.sum < 1024;
        len.size() inside {[1:8]};
    }
endclass

program test;
    good a;

    initial begin
        a = new();
        for(int i = 1; i <= 10; i++) begin
            assert(a.randomize());
            $display("Sum = %0d, Size = %0d, Array = ", a.len, a.len.size,a.len);
        end
    end
endprogram