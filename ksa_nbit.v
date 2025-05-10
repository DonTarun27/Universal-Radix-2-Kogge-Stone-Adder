`timescale 1ns / 1ps
module ksa_nbit
    #(parameter N = 16)
    (input [N-1:0] A, B,
     input Ci,
     output [N-1:0] S,
     output Co);

    wire [N-1:0] G [0:N/4];
    wire [N-1:0] P [0:N/4];
    wire [N-1:0] Cf;
    genvar p, q, r, s, t;

    generate
        for(p=0; p<N; p=p+1)                //PG Block
        begin
            assign P[0][p] = A[p]^B[p];
            assign G[0][p] = A[p]&B[p];
        end
        
        for(q=0; q<N/4; q=q+1)
        begin
            for(r=0; r<N; r=r+1)                //FCO Block
            begin
                if(r>(2**q)-1)
                begin
                    assign P[q+1][r] = P[q][r]&P[q][r-(2**q)];
                    assign G[q+1][r] = G[q][r]|(P[q][r]&G[q][r-(2**q)]);
                end
                else
                begin
                    assign P[q+1][r] = P[q][r];
                    assign G[q+1][r] = G[q][r];
                end
            end
        end
        
        for(s=0; s<N; s=s+1)                //PPC Block
        begin
            assign Cf[s] = G[N/4][s]|(P[N/4][s]&Ci);
        end
        
        for(t=0; t<N; t=t+1)                //Sum Block
        begin
            if(t>0) assign S[t] = P[0][t]^Cf[t-1];
            else assign S[t] = P[0][t]^Ci;
        end
    endgenerate

    assign Co = Cf[N-1];               //Carry out
endmodule
