module decade_counter (output logic [3:0] Q,
                       input  logic [3:0] P,
                       input logic Load, Enable, MR, CLK);
    always @(MR) begin
        // asynchronous reset signal MR (Master Reset).
        if (MR)
            Q <= 4'b0000;
    end

    always @(posedge CLK) begin
        if(!MR)
            if(Load)
                Q <= P;
            else if (Enable)
                Q <= (Q+1) % 10;
    end
endmodule                