
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

                        assign rega = (instr[8:5] == 4'b0000) ? a :
                                      (instr[8:5] == 4'b0001) ? b :
                                      (instr[8:5] == 4'b0010) ? c :
                                      (instr[8:5] == 4'b0011) ? d :
                                      (instr[8:5] == 4'b0100) ? e :
                                      (instr[8:5] == 4'b0101) ? f :
                                      (instr[8:5] == 4'b0110) ? g :
                                      (instr[8:5] == 4'b0111) ? h : 8'b0;

                        // Assign regb based on instr[11:8]
                        assign regb = (instr[11:8] == 4'b0000) ? a :
                                      (instr[11:8] == 4'b0001) ? b :
                                      (instr[11:8] == 4'b0010) ? c :
                                      (instr[11:8] == 4'b0011) ? d :
                                      (instr[11:8] == 4'b0100) ? e :
                                      (instr[11:8] == 4'b0101) ? f :
                                      (instr[11:8] == 4'b0110) ? g :
                                      (instr[11:8] == 4'b0111) ? h : 8'b0;

                        // Assign flag1 based on instr[8:5]
                        assign flag1 = (instr[8:5] == 4'b0000) ? fa :
                                       (instr[8:5] == 4'b0001) ? fb :
                                       (instr[8:5] == 4'b0010) ? fc :
                                       (instr[8:5] == 4'b0011) ? fd :
                                       (instr[8:5] == 4'b0100) ? fe :
                                       (instr[8:5] == 4'b0101) ? ff :
                                       (instr[8:5] == 4'b0110) ? fg :
                                       (instr[8:5] == 4'b0111) ? fh : 1'b0;

                        // Assign flag2 based on instr[11:8]
                        assign flag2 = (instr[11:8] == 4'b0000) ? fa :
                                       (instr[11:8] == 4'b0001) ? fb :
                                       (instr[11:8] == 4'b0010) ? fc :
                                       (instr[11:8] == 4'b0011) ? fd :
                                       (instr[11:8] == 4'b0100) ? fe :
                                       (instr[11:8] == 4'b0101) ? ff :
                                       (instr[11:8] == 4'b0110) ? fg :
                                       (instr[11:8] == 4'b0111) ? fh : 1'b0;


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
                            0:  a = regc;
                            1:  b = regc;
                            2:  c = regc;
                            3:  d = regc;
                            4:  e = regc;
                            5:  f = regc;
                            6:  g = regc;
                            7:  h = regc;
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