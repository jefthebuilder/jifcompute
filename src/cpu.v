
`include "../src/alu.v"
module cpu(
    inout data,
    output address,
    output rw,
    input clock,
    input reset
);
    reg [31:0] a,b,c,d,e,f,g,h;
    reg fa,fb,fc,fd,fe,ff,fg,fh;
    reg addrchange;
    reg [2:0] state;
    reg [31:0] addr;
    reg [31:0] instr;
    wire [31:0] rega;
    wire [31:0] regb;
    wire [31:0] regc;
    wire [15:0] value;
    wire flag1;
    wire flag2;
    wire flag3;
    wire highlow;
    wire [31:0]temp_address;
    wire [31:0] naddr;
    wire temp2;
    wire writinginstr;
    always @(posedge reset)
    begin
        {a,b,c,d,e,f,g,h} = 0;
        {fa,fb,fc,fd,fe,ff,fg,fh} = 0;
        {addr,instr} = 0;

        state = 0;
        addrchange = 0;
    end
    ADDER32 adder1(addr,{32{~addrchange}},temp_address);
    ALU alu1(clock,rega,regb,h,value,highlow,flag1,flag2,flag3,instr[6:0],regc,flag3,addrchange,naddr);
    always@(posedge clock)
        begin



                case (state)
                    0: begin
                        address = addr;
                        rw = 0;
                        instr = data;
                        state = 1;
                    end
                    1: begin
                        // regA

                        case (instr[8:5])
                            0: rega = a;
                            1:  rega = b;
                            2:  rega = c;
                            3:  rega = d;
                            4:  rega = e;
                            5:  rega = f;
                            6:  rega = g;
                            7:  rega = h;
                        endcase
                        case (instr[11:8])
                            0:  regb = a;
                            1:  regb = b;
                            2:  regb = c;
                            3:  regb = d;
                            4:  regb = e;
                            5:  regb = f;
                            6:  regb = g;
                            7:  regb = h;
                        endcase
                        case (instr[8:5])
                            0:  flag1 = fa;
                            1:  flag1 = fb;
                            2:  flag1 = fc;
                            3:  flag1 = fd;
                            4:  flag1 = fe;
                            5:  flag1 = ff;
                            6:  flag1 = fg;
                            7:  flag1 = fh;
                        endcase
                        case (instr[11:8])
                            0:  flag2 = fa;
                            1:  flag2 = fb;
                            2:  flag2 = fc;
                            3:  flag2 = fd;
                            4:  flag2 = fe;
                            5:  flag2 = ff;
                            6:  flag2 = fg;
                            7:  flag2 = fh;
                        endcase
                        assign value = instr[30:15];
                        assign highlow = instr[15:14];

                        assign temp_address = addr;
                        assign temp2 = ~addrchange;
                        addr = (temp2 & temp_address) | naddr;
                        assign writinginstr = instr[6:0] == 7;
                        address = (h & writinginstr);
                        rw = writinginstr;
                        data = rega;
                        case (instr[14:11])
                            0:  fa = flag3;
                            1:  fb = flag3;
                            2:  fc = flag3;
                            3:  fd = flag3;
                            4:  fe = flag3;
                            5:  ff = flag3;
                            6:  fg = flag3;
                            7:  fh = flag3;
                        endcase
                        case (instr[14:11])
                            0:  fa = flag3;
                            1:  fb = flag3;
                            2:  fc = flag3;
                            3:  fd = flag3;
                            4:  fe = flag3;
                            5:  ff = flag3;
                            6:  fg = flag3;
                            7:  fh = flag3;
                        endcase

                    end
                    2:
                        begin

                            addrchange = 0;
                            addr = temp_address;
                            state = 0;
                        end
                endcase
        end


endmodule