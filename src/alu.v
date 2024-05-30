module gate(
    input [31:0] A,
    input [31:0] B,
    input gateA
    output [31:0] out);
    wire [31:0] A1;
    wire [31:0] B1;
    assign A1 = A & {32{gateA}};
    assign B1 = B & {32{~gateA}};
    assign out = A1 | B1;
endmodule
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
    inout F3,
    input [6:0] instr,
    inout [31:0] C,
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
    wire g;
    gate gate1(C1,C,g);
    wire g1;
    gate gate2(C2,C,g1);
    wire g2;
    gate gate3(C3,C,g2);
    wire g3;
    gate gate4(C4,C,g3);
    wire g4;
    gate gate5(A,C,g4);
    wire g5;
    gate gate6(C5,C,g5);
    always@(posedge clock)
            begin
              
              case(instr)

                    0: assign g = 1;
                    1: assign g1 = 1;
                    2: assign g2 = 1;
                    3: assign g3 = 1;
                    4: assign g4 = 1;
                    5: assign g4 = 1;
                    6: assign g5 = 1;
                    7: assign g4 = 1;
                    8:  F3 = A == B;
                    9:  F3 = A < B;
                    10:  F3 = A > B;
                    11:  F3 = ~F1;
                    12:  F3 = F1 & F2;
                    13:  F3 = F1;
                    14: begin
                         naddr = reg8;
                         addrch = 1;
                    end
                    15: begin

                        naddr = F1 & reg8;
                         addrch = F1;

                    end
                    endcase
          end





endmodule



 // full_adder


