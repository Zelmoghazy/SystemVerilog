module struct_1 () ;
    typedef struct {
        bit [7:0] r;
        bit [7:0] g;
        bit [7:0] b;
    } pixel_s;

    pixel_s my_pixel;        // stored in 3 long words

    typedef struct packed {
        bit [7:0] r;
        bit [7:0] g;
        bit [7:0] b;
    } pixel_p_s;

    pixel_p_s my_pixel_p;   // stored in 3 bytes
    
endmodule
