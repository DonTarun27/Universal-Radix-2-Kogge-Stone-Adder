`timescale 1ns / 1ps
module ksa_16bit
    (input [15:0] A, B,
     input Ci,
     output [15:0] S,
     output Co);

    wire [15:0] G, P, G1, P1, G2, P2, G3, P3, G4, P4, Cf;
    genvar p, q, r, s, t, u, v;

    generate
        for(p=0; p<16; p=p+1)                //PG Block
        begin
            assign P[p] = A[p]^B[p];
            assign G[p] = A[p]&B[p];
        end
        
        for(q=0; q<16; q=q+1)                //FCO Block Stage 1
        begin
            if(q>0)
            begin
                assign P1[q] = P[q]&P[q-1];
                assign G1[q] = G[q]|(P[q]&G[q-1]);
            end
            else
            begin
                assign P1[q] = P[q];
                assign G1[q] = G[q];
            end
        end
        
        for(r=0; r<16; r=r+1)                //FCO Block Stage 2
        begin
            if(r>1)
            begin
                assign P2[r] = P1[r]&P1[r-2];
                assign G2[r] = G1[r]|(P1[r]&G1[r-2]);
            end
            else
            begin
                assign P2[r] = P1[r];
                assign G2[r] = G1[r];
            end
        end
        
        for(s=0; s<16; s=s+1)                //FCO Block Stage 3
        begin
            if(s>3)
            begin
                assign P3[s] = P2[s]&P2[s-4];
                assign G3[s] = G2[s]|(P2[s]&G2[s-4]);
            end
            else
            begin
                assign P3[s] = P2[s];
                assign G3[s] = G2[s];
            end
        end
        
        for(t=0; t<16; t=t+1)                //FCO Block Stage 4
        begin
            if(t>7)
            begin
                assign P4[t] = P3[t]&P3[t-8];
                assign G4[t] = G3[t]|(P3[t]&G3[t-8]);
            end
            else
            begin
                assign P4[t] = P3[t];
                assign G4[t] = G3[t];
            end
        end
        
        for(u=0; u<16; u=u+1)                //PPC Block
        begin
            assign Cf[u] = G4[u]|(P4[u]&Ci);
        end
        
        for(v=0; v<16; v=v+1)                //Sum Block
        begin
            if(v>0) assign S[v] = P[v]^Cf[v-1];
            else assign S[v] = P[v]^Ci;
        end
    endgenerate
    
    assign Co = Cf[15];               //Carry out
endmodule
