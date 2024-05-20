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