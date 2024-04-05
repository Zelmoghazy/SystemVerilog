
module full_adder_behavioural (
    input wire[3:0] a;
    input wire[3:0] b;
    input wire cin;

    output reg [3:0] sum;
    output reg cout;
);
    always @(a or b or cin) begin
        {cout,sum} = a + b + cin;
    end
endmodule

module full_adder_structural (
    input a;
    input b;
    input c;

    output sum;
    output cout;
);

    assign sum = a ^ b ^ c;
    assign cout = (a&b) | (b&c) | (c&a);
    
endmodule

module adder_4bit(a,b,sum,cout,cin);
    input [3:0] a;
    input [3:0] b;
    output cout;
    output [3:0] sum;

    wire [3:0]c;

    full_adder_structural U0 (a[0], b[0], c[0], sum[0], c[1]);
    full_adder_structural U1 (a[1], b[1], c[1], sum[1], c[2]);
    full_adder_structural U2 (a[2], b[2], c[2], sum[2], c[3]);
    full_adder_structural U3 (a[3], b[3], c[3], sum[3], cout);

    assign c[0] = cin;
    
endmodule

module adder_8bit(a,b,sum, cout,cin);
    input [7:0] a;
    input [7:0] b;
    output cout;
    output [7:0] sum;

    wire c1;
    wire c2;

    adder_4bit U0 (a[3:0], b[3:0],sum[3:0], c1,cin);
    adder_4bit U1 (a[7:4], b[7:4],sum[7:4], cout,c1);

endmodule
