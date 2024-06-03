/* 
    Seed controls the numbers that $random returns.
    The seed must be a reg, integer or time variable.
    Everytime you run the code it will generate the
    same random numbers as long as the seed is the same.
    So a good practice is to make the seed equals the computer time.
 */

program test;
    int a;
    int seed=655 ;

    initial begin
        //Flat distribution, returning signed 32-bit random integer
        a = $random() ; $display("random a = %0d" ,a) ;

        //Flat distribution, returning unsigned 32-bit random
        a = $urandom() ; $display("urandom a = %0d" , a) ;

        // Flat distribution over a range (min, max)
        // Default of minval is zero so we can only pass maxval
        // If minval is greater than maxval function will swap them 
        a = $urandom_range(50, 100); $display( "urandom_range a = %0d", a);

        // Exponential decay (seed, mean)
        a = $dist_exponential(seed, 30); $display("exponential a = %0d", a);

        // Bell-shaped distribution (seed, mean, deviation)
        a = $dist_normal(seed, 30, 2); $display("normal a= %0d", a);

        // Bell-shaped distribution (seed, mean)
        a = $dist_poisson(seed, 30); $display("poisson a= %0d", a);

        // Flat-shaped distribution (seed, start, end)
        a = $dist_uniform(seed, 10, 50); $display("uniform a = %0d", a);
    end
endprogram