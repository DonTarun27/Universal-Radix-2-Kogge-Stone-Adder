`timescale 1ns / 1ps
module ksa_tst;
    reg [15:0] A, B;
    reg Ci;
    wire [15:0] S;
    wire Co;
    ksa_16bit k1(.A(A), .B(B), .Ci(Ci), .S(S), .Co(Co));     //ksa_nbit #(.N(16)) k1(.A(A), .B(B), .Ci(Ci), .S(S), .Co(Co));
    initial
    begin A = 16'hFFFF; B = 16'h0001; Ci = 1'b1;
        #10 B = 16'h0019;
        #10 A = 16'h0019; Ci = 1'b0;
        #10 A = 16'hFFFF; B = 16'h0007; Ci = 1'b1;
        #10 B = 16'h0001; Ci = 1'b0;
        #20 $finish;
    end
endmodule
