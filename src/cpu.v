
`include "../src/alu.v"
module cpu(
    input [31:0] data,
    output reg [31:0] datao,
    output reg [31:0] address,
    output reg rw,
    input clock,
    input reset
);
    reg [31:0] a,b,c,d,e,f,g,h;
    reg fa,fb,fc,fd,fe,ff,fg,fh;
    reg addrchange;
    reg [2:0] state;
    reg [31:0] addr;
    reg [31:0] instr;
    reg [31:0] rega;
    reg [31:0] regb;
    reg [31:0] regc;
    reg [15:0] value;
    reg flag1;
    reg flag2;
    reg flag3;
    reg highlow;
    reg [31:0]temp_address;
    reg [31:0] naddr;
    wire temp2;
    wire writinginstr;
    wire tempinstr = instr[8:5];
    wire tempinstr1 = instr[11:8];
    wire tempinstr2 = instr[8:5];
    wire tempinstr3 = instr[11:8];
    wire tempinstr4 = instr[14:11];
    always @* begin
        
    case (tempinstr)
                            0: assign rega = a;
                            1: assign rega = b;
                            2: assign  rega = c;
                            3: assign rega = d;
                            4: assign rega = e;
                            5: assign rega = f;
                            6: assign rega = g;
                            7: assign rega = h;
                        endcase
    
    case (tempinstr1)
                            0: assign regb = a;
                            1: assign regb = b;
                            2: assign regb = c;
                            3: assign regb = d;
                            4: assign regb = e;
                            5: assign regb = f;
                            6: assign regb = g;
                            7: assign regb = h;
                        endcase
    
    case (tempinstr2)
                            0: assign flag1 = fa;
                            1: assign flag1 = fb;
                            2: assign flag1 = fc;
                            3: assign flag1 = fd;
                            4: assign flag1 = fe;
                            5: assign flag1 = ff;
                            6: assign flag1 = fg;
                            7: assign flag1 = fh;
                        endcase
                        
    case (tempinstr3)
                            0: assign flag2 = fa;
                            1: assign flag2 = fb;
                            2: assign flag2 = fc;
                            3: assign flag2 = fd;
                            4: assign flag2 = fe;
                            5: assign flag2 = ff;
                            6: assign flag2 = fg;
                            7: assign flag2 = fh;
                        endcase
                        assign value = instr[30:15];
                        assign highlow = instr[15:14];
    
    case (tempinstr4)
    
                            0: assign fa = flag3;
                            1: assign fb = flag3;
                            2: assign fc = flag3;
                            3: assign fd = flag3;
                            4: assign fe = flag3;
                            5: assign ff = flag3;
                            6: assign fg = flag3;
                            7: assign fh = flag3;
                        endcase
                        case (tempinstr4)
                            0: assign fa = flag3;
                            1: assign fb = flag3;
                            2: assign fc = flag3;
                            3: assign fd = flag3;
                            4: assign fe = flag3;
                            5: assign ff = flag3;
                            6: assign fg = flag3;
                            7: assign fh = flag3;
                        endcase

    end
    
    
    always @(posedge reset)
    begin
        {a,b,c,d,e,f,g,h} = 0;
        {fa,fb,fc,fd,fe,ff,fg,fh} = 0;
        {addr,instr} = 0;

        state = 0;
        addrchange = 0;
    end
    ADDER32 adder1(addr,1,temp_address);
    ALU alu1(clock,rega,regb,h,value,highlow,flag1,flag2,flag3,instr[6:0],regc,addrchange,naddr);
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

                        
                        temp_address = addr;
                        temp2 = ~addrchange;
                        addr = (temp2 & temp_address) | naddr;
                        writinginstr = instr[6:0] == 7;
                        address = (h & writinginstr);
                        rw = writinginstr;
                        datao = rega;
                        
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
