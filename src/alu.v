module gate(
    input [63:0] A,
    input [63:0] B,
    input gateA,
    output [63:0] out);
    wire [63:0] A1;
    wire [63:0] B2;
    assign A1 = A & {64{gateA}};
    assign B2 = B & {64{~gateA}};
    assign out = A1 | B2;
endmodule
module SHIFTERRIGHT(
    input [63:0] A,
    input [63:0] B,
    output [63:0] C
);
    wire [63:0] A1,A2;
    assign A1 = ~A;
    assign A2 = A1 >> B;
    assign C = ~A2;
endmodule
module SHIFTERLEFT(
    input [63:0] A,
    input [63:0] B,
    output [63:0] C
);
    wire [63:0] A1,A2;

    assign A1 = ~A;
    assign A2 = A1 << B;

    assign C = ~A2;
endmodule
module SUBTRACT64(
    input [63:0] A,
    input [63:0] B,
    output [63:0] C
);
    parameter N=64;
    wire [63:0] b2;
    genvar i;
    generate
        for(i=0;i<N;i=i+1)
        begin: generate_subtract
            not(b2[i],B[i]);
        end
    endgenerate
    ADDER64 f(A,B,C);
endmodule



module full_adder(x,y,c_in,s,c_out);
    input x,y,c_in;
    output s,c_out;
    assign s = (x^y) ^ c_in;
    assign c_out = (y&c_in)| (x&y) | (x&c_in);
endmodule

module ADDER64 (
    input  [63:0] a,     // First 64-bit input
    input  [63:0] b,     // Second 64-bit input
    output [63:0] sum    // 64-bit sum output
      // Carry-out bit
);
    wire carry;
    assign {carry, sum} = a + b; // Perform the addition and assign the result to sum and carry

endmodule

module LOAD(
    input [63:0] A,
    input [31:0] value,
    input highlow,
    output [63:0] C
);
    wire [63:0] HIGH;
    wire invhigh;
    not(invhigh,highlow);

    assign HIGH = {64{highlow}};
    


    assign C = {A[63:32],value} & ~HIGH | {value,A[31:0]} & HIGH ;




endmodule
module ALU (
    input clock,
    input [63:0] A,
    input [63:0] B,
    input [63:0] reg8,
    input [31:0] value,
    input highlow,
    input F1,
    input F2,
    inout F3,
    input [5:0] instr,
    output [63:0] C,
    output addrch,
    output [63:0] naddr
);
    wire [63:0] C1;
    ADDER64 addermaster(A,B,C1);
    wire [63:0] C2;
    SUBTRACT64 aftrekker4(A,B,C2);
    wire [63:0] C3;
    SHIFTERLEFT shifterlinks(A,B,C3);
    wire [63:0] C4;
    SHIFTERRIGHT shifterrecht(A,B,C4);
    wire [63:0] C5;
    LOAD truck(A,value,highlow,C5);
    wire g = instr == 0;
    wire [63:0] oc1;
    gate gate1(C1,0,g,oc1);
    wire g1 = instr == 1;
    wire [63:0] oc2;
    gate gate2(C2,0,g1,oc2);
    wire g2 = instr == 2;
    wire [63:0] oc3;
    gate gate3(C3,0,g2,oc3);
    wire g3 = instr == 3;
    wire [63:0] oc4;
    gate gate4(C4,0,g3,oc4);
    wire [63:0] oc5;
    wire g4 = (instr == 7 | instr == 4 | instr == 6);
    gate gate5(A,0,g4,oc5);
    wire [63:0] oc6;
    wire g5 = (instr == 5);
    gate gate6(C5,0,g5,oc6);
    wire [63:0] oc7 = (A/B) & {64{instr == 17}}; 
    wire [63:0] oc8 = (A*B) & {64{instr == 16}}; 
    wire [63:0] tempc = (((oc1 | oc2) | (oc3 | oc4)) | (oc5 | oc6)) | (oc7 | oc8);
    assign C = (tempc);
    wire F8 = (A == B) & (instr == 8);
    wire F9 = (A < B) & (instr == 9);
    wire F10 = (A > B) & (instr == 10);
    wire F11 = (~F1) & (instr == 11);
    wire F12 = (F1 & F2) & (instr == 12);
    wire F13 = (F1) & (instr == 13);
    assign naddr = (reg8 & ((({64{instr == 14}}) |{64{(instr == 15 & F1)}}) | {64{(instr == 6)}} | {64{(instr == 7)}}));
    assign addrch = (((instr == 14) | instr == 15) & F1);
        
    assign F3 = ((F8 | F9) | (F10 | F11)) | (F12 | F13);
                    
                                                      
                                                      
                                                      
    
    





endmodule



 // full_adder


