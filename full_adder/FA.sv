
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
    input cin;

    output sum;
    output cout;
);

    assign sum = a ^ b ^ cin;
    assign cout = (a&b) | (b&cin) | (cin&a);
    
endmodule

module adder_4bit(a,b,cin,sum,cout);
    input [3:0] a;
    input [3:0] b;
    input  cin;

    output [3:0] sum;
    output cout;

    wire [2:0]carry;

    full_adder_structural U0 (a[0], b[0], cin,      sum[0], carry[0]);
    full_adder_structural U1 (a[1], b[1], carry[0], sum[1], carry[1]);
    full_adder_structural U2 (a[2], b[2], carry[1], sum[2], carry[2]);
    full_adder_structural U3 (a[3], b[3], carry[2], sum[3], cout);
endmodule

module adder_8bit(a,b,cin,sum,cout);
    input [7:0] a;
    input [7:0] b;
    input cin;

    output [7:0] sum;
    output cout;

    wire carry;

    adder_4bit U0 (a[3:0], b[3:0], cin,   sum[3:0], carry);
    adder_4bit U1 (a[7:4], b[7:4], carry, sum[7:4], cout);

endmodule
