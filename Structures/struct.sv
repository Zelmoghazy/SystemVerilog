/*
    In System verilog you can create a structure using the struct statement
    similar to what is available in C.
 */

module struct_1() ;
    initial begin

        typedef struct {
            int a;
            byte b;
            shortint c;
            int d; 
        } my_struct_s;

        my_struct_s st = ' {32'haaaa_aaaad, // truncation happens
                            8'hbb ,
                            16'hcccc,
                            32'hdddd_dddd};

        $display ("str = %x %x %x %x " , st.a, st.b, st.c, st.d) ;
        end
endmodule

/* Packed Structures */
/* 
    SystemVerilog allows you more control on how bits are laid out in memory by
    using packed structures. A packed structure is stored as a contiguous set of 
    bits with no unused space. Packed structures are used when the underlying bits
    represent a numerical value, or when you are trying to reduce memory usage.
 */
module struct_2 () ;
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

