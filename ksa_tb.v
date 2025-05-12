`timescale 1ns / 1ps
module ksa_tst;
    reg [15:0] A, B;
    reg Ci;
    wire [15:0] S;
    wire Co;
  ksa_16bit k1(A, B, Ci, Co, S);		//ksa_nbit #(16) k1(A, B, Ci, Co, S);
    initial
    begin A = 16'hFFFF; B = 16'h0001; Ci = 1'b1;
        #10 B = 16'h0019;
        #10 A = 16'h0019; Ci = 1'b0;
        #10 A = 16'hFFFF; B = 16'h0007; Ci = 1'b1;
        #10 B = 16'h0001; Ci = 1'b0;
    end
    initial #60 $finish;
endmodule
