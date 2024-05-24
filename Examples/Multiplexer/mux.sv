module mux_2to1 (
    input wire a,b,s,
    output reg y
);
    always @(a or b or s) begin
        if (s==0)
            y = a;
        else
            y = b;
    end
endmodule

module Mul4to1 (
    In1,
    In2,
    In3,
    In4,
    Sel,
    Out
);
    input [31:0] In1,In2,In3,In4;   // four 32-bit inputs
    input [1:0] Sel;                // 2-bit selector signal
    output reg [31:0] Out;          // 32-bit output

    always @(In1,In2,In3,In4,Sel) begin
        case (Sel) 
            0: Out <= In1;
            1: Out <= In2;
            2: Out <= In3;
            default: Out <= In4;
        endcase    
    end
endmodule