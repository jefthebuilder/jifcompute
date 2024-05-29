module SHIFTERRIGHT(
    input [31:0] A,
    input [31:0] B,
    output [31:0] C,
);
    wire [31:0] A1,A2;
    not(A1,A);
    assign A2 = A1 >> B;
    not(C,A2);
endmodule : SHIFTERRIGHT
module SHIFTERLEFT(
    input [31:0] A,
    input [31:0] B,
    output [31:0] C,
);
    wire [31:0] A1,A2;
    not(A1,A);
    assign A2 = A1 << B;
    not(C,A2);
endmodule : SHIFTERLEFT
module SUBTRACT32(
    input [31:0] A,
    input [31:0] B,
    output [31:0] C,
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
endmodule : SUBTRACT32
module half_adder(x,y,s,c);
    input x,y;
    output s,c;
    assign s=x^y;
    assign c=x&y;
endmodule // half adder

// fpga4student.com: FPGA projects, Verilog projects, VHDL projects
// Verilog project: Verilog code for N-bit Adder
// Verilog code for full adder
module full_adder(x,y,c_in,s,c_out);
    input x,y,c_in;
    output s,c_out;
    assign s = (x^y) ^ c_in;
    assign c_out = (y&c_in)| (x&y) | (x&c_in);
endmodule;

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
endmodule : ADDER32


module ALU (
    input clk,
    input [31:0] A,
    input [31:0] B,
    input [4:0] instr,
    output [31:0] C,
    output flag,
);
  case(instr)
      0: ADDER32 f(A,B,C);
      1: SUBTRACT32 f(A,B,C);
      2: SHIFTERLEFT f(A,B,C);
      3: SHIFTERRIGHT f(A,B,C);
  endcase
endmodule : ALU


 // full_adder


