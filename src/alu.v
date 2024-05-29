module SHIFTERRIGHT(
    input [31:0] A,
    input [31:0] B,
    output [31:0] C
);
    wire [31:0] A1,A2;
    not(A1,A);
    assign A2 = A1 >> B;
    not(C,A2);
endmodule
module SHIFTERLEFT(
    input [31:0] A,
    input [31:0] B,
    output [31:0] C
);
    wire [31:0] A1,A2;
    not(A1,A);
    assign A2 = A1 << B;
    not(C,A2);
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
    xor(HIGH,invhigh,value);
    wire [31:0] temp;
    SHIFTERLEFT f(value,HIGH,temp);
    wire [31:0] temp2;
    wire [31:0] temp3;

    and(temp2[31:15],temp[31:15],highlow);
    and(temp2[15:0],A[15:0],highlow);
    and(temp3[31:15],A[31:15],invhigh);
    and(temp3[15:0],temp[15:0],invhigh);
    or(C,temp2,temp3);





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
    ADDER32 f(A,B,C1);
    wire [31:0] C2;
    SUBTRACT32 f(A,B,C2);
    wire [31:0] C3;
    SHIFTERLEFT f(A,B,C);
    wire [31:0] C4;
    SHIFTERRIGHT f(A,B,C4);
    wire [31:0] C5;
    LOAD f(A,value,highlow,C5);

    always@(posedge clock)
            begin
              case(instr)

                    0: assign C = C1;
                    1: assign C = C2;
                    2: assign C = C3;
                    3: assign C = C4;
                    4: assign C = A;
                    5: assign C = C5;
                    6: assign C = C5;
                    7: assign C = A;
                    8: assign F3 = A == B;
                    9: assign F3 = A < B;
                    10: assign F3 = A > B;
                    11: assign F3 = ~F1;
                    12: assign F3 = F1 & F2;
                    13: assign F3 = F1;
                    14: begin
                        assign naddr = reg8;
                        assign addrch = 1;
                    end
                    15: begin

                        naddr = F1 & reg8;
                        assign addrch = F1;

                    end
                    endcase
          end





endmodule



 // full_adder


