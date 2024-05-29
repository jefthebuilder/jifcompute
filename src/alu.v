module SHIFTERRIGHT(
    input [31:0] A,
    input [31:0] B,
    output [31:0] C
);
    wire [31:0] A1,A2;
    assign A1 = ~A;
    assign A2 = A1 >> B;
    assign C = ~A2;
endmodule
module SHIFTERLEFT(
    input [31:0] A,
    input [31:0] B,
    output [31:0] C
);
    wire [31:0] A1,A2;

    assign A1 = ~A;
    assign A2 = A1 << B;

    assign C = ~A2;
endmodule
module SUBTRACT32(
    input [31:0] A,
    input [31:0] B,
    output [31:0] C
);
    parameter N=32;
    wire [31:0] b2;
    genvar i;
    generate
        for(i=0;i<N;i=i+1)
        begin: generate_subtract
            not(b2[i],B[i]);
        end
    endgenerate
    ADDER32 f(A,B,C);
endmodule
module half_adder(x,y,s,c);
    input x,y;
    output s,c;
    assign s=x^y;
    assign c=x&y;
endmodule // half adder


module full_adder(x,y,c_in,s,c_out);
    input x,y,c_in;
    output s,c_out;
    assign s = (x^y) ^ c_in;
    assign c_out = (y&c_in)| (x&y) | (x&c_in);
endmodule

module ADDER32(input1,input2,answer);
    parameter N=32;
    input [N-1:0] input1,input2;
    output [N-1:0] answer;
    wire  carry_out;
    wire [N-1:0] carry;
    genvar i;
    generate
        for(i=0;i<N;i=i+1)
            begin: generate_N_bit_Adder
                if(i==0)
                    half_adder f(input1[0],input2[0],answer[0],carry[0]);
                    else
                    full_adder f(input1[i],input2[i],carry[i-1],answer[i],carry[i]);
            end
        assign carry_out = carry[N-1];
    endgenerate
endmodule

module LOAD(
    input [31:0] A,
    input [15:0] value,
    input highlow,
    output [31:0] C
);
    wire [15:0] HIGH;
    wire invhigh;
    not(invhigh,highlow);

    assign HIGH = {32{invhigh}} ^ value;
    wire [31:0] temp;
    SHIFTERLEFT shifty(value,{HIGH,{32-16{1'b0}}},temp);
    wire [31:0] temp2;
    wire [31:0] temp3;

    assign temp2[31:15] = temp[31:15]&{32{highlow}};
    assign temp2[15:0]=A[15:0]&{32{highlow}};
    assign temp3[31:15]=A[31:15]&{32{invhigh}};
    assign temp3[15:0]=temp[15:0]&{32{invhigh}};

    assign C = temp2 | temp3;




endmodule
module ALU (
    input clock,
    input [31:0] A,
    input [31:0] B,
    input [31:0] reg8,
    input [15:0] value,
    input highlow,
    input F1,
    input F2,
    output F3,
    input [6:0] instr,
    output [31:0] C,
    output flag,
    output addrch,
    output [31:0] naddr
);
    wire [31:0] C1;
    ADDER32 addermaster(A,B,C1);
    wire [31:0] C2;
    SUBTRACT32 aftrekker4(A,B,C2);
    wire [31:0] C3;
    SHIFTERLEFT shifterlinks(A,B,C);
    wire [31:0] C4;
    SHIFTERRIGHT shifterrecht(A,B,C4);
    wire [31:0] C5;
    LOAD truck(A,value,highlow,C5);

    always@(posedge clock)
            begin
                assign C = (instr == 0) ? C1 :
                           (instr == 1) ? C2 :
                           (instr == 2) ? C3 :
                           (instr == 3) ? C4 :
                           (instr == 4) ? A :
                           (instr == 5) ? C5 :
                           (instr == 6) ? C5 :
                           (instr == 7) ? A : 8'b0;
                assign F3 = (instr == 8) ? (A == B) :
                            (instr == 9) ? (A < B) :
                            (instr == 10) ? (A > B) :
                            (instr == 11) ? ~F1 :
                            (instr == 12) ? (F1 & F2) :
                            (instr == 13) ? F1 : 1'b0;

                assign naddr = (instr == 14) ? reg8 :
                               (instr == 15) ? (F1 & reg8) : 8'b0;

                assign addrch = (instr == 14) ? 1'b1 :
                                (instr == 15) ? F1 : 1'b0;

          end





endmodule



 // full_adder


