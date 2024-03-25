/*
    Verilog Language has two primary data types:
      - Nets: represents structural connections between components.
      _ Registers: represent variables used to store data.
    Every signal has a data type associated with it:
      - Implicit declaration is always a net of type wire and is one bit wide.
    
    Wire data type is used in the continuous assignments or ports list.
    It is treated as a wire So it cannot hold a value.
    It can be driven and read. Wires are used for connecting different modules.

    Reg is a date storage element in Verilog.
    It’s not an actual hardware register but it can store values.
    Registers retain their value until next assignment statement.

    Port Connection Rules :
    -----------------------
    1- Inputs : internally must always be type net, externally the inputs can be connected to variable reg or net type.
    2- Outputs : internally can be type net or reg, externally the outputs must be connected to a variable net type.
    3- Inouts : internally or externally must always be type net, can only be connected to a variable net type.

    Possible type states:
        - 0: variable/net is at 0 volts
        - 1: variable/net is at some value > 0.7 volts
        - x: or X: variable/net has either 0/1 - we just don't know
        - z or Z: net has high impedance - may be the wire is not connected and is floating.

    * Uninitialized 2-state signals are set to 0, while 4-state signals are set to x.
        - 2-state type can take only the 2 values; 1 or 0.
*/

module state_data_type();
    bit b;              // 2-state, single-bit, always unsigned
    bit [31:0] b32;     // 2-state, 32-bit unsigned integer
    byte b8;            // 2-state, 8-bit signed integer
    shortint s;         // 2-state, 16-bit signed integer
    int i;              // 2-state, 32-bit signed integer
    int unsigned ui;    // 2-state, 32-bit unsigned integer
    longint l;          // 2-state, 64 -bit signed integer
    integer i4;         // 4-state, 32-bit signed integer
    time t;             // 4-state, 64-bit unsigned integer
    real r;             // 2-state, double precision floating point

    initial begin
        #20;

        b   <= 1;
        b32 <= 32'hA5BFx1z7;
        b8  <= -30;
        s   <= 80000;
        i   <= -5;
        ui  <= 40;
        l   <= 655168;
        i4  <= 32'bxxxx1000zzzz1010;
        t   <= 64'hABCDEF5234123897;
        r   <= 345.987 ;

        #20;

        b   <= 0;
        b32 <= 32'hABF54387;
        b8  <= 40;
        s   <= 15;
        i   <= 24;
        ui  <= 0;
        l   <= 656169;
        i4  <= 32'hCxAz;
        t   <= 500;
        r   <= 45324.5437 ;

        #50;

        b<=1;
    end

    initial begin
        $dumpfile("test.vcd");
        $dumpvars;
    end
endmodule