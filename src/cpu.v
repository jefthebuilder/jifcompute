
`include "../src/alu.v"
module cpu(
    input [31:0] data,
    output [31:0] datao,
    output [31:0] address,
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
    reg [31:0]temp_address;
    
    reg [31:0] naddr;
    wire temp2;
    wire [6:0] writinginstr;
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
    
    
    always @* begin
        assign {fa,fb,fc,fd,fe,ff,fg,fh} = ({8{~reset}} & {fa,fb,fc,fd,fe,ff,fg,fh});
    assign {a,b,c,d,e,f,g,h} = ({256{~reset}} & {a,b,c,d,e,f,g,h});
    // state 0
    assign addr = ({32{~reset}} & addr);
    assign data = ({32{~reset}} & addr);
    assign instr = ({32{~reset}} & instr);
    assign state = ({2{~reset}} & state);
    assign addrchange = (~reset & addrchange);
    ADDER32 adder1(addr,1,temp_address);
     ALU alu1(clock,rega,regb,h,value,highlow,flag1,flag2,flag3,instr[6:0],regc,addrchange,naddr);
     assign address = ((addr & {32{state == 0 & clock}}) | (h & writinginstr)) & {32{clock}};
     assign rw = (~(~(state == 0 ) | ~writinginstr)) & ( clock);
     assign state = ((({2{state == 0}} & 1) | ({2{state == 1}} & 2) ) | ({2{state == 2}} & 0)) & {3{clock}};
    // state 1
     assign temp_address = addr & {32{(clock)}};
     assign temp2 = ~addrchange & (clock);
     assign addr = (((temp2 & temp_address) | naddr) | temp_address & {32{state == 2}}) & {32{ clock}};
     assign writinginstr = (instr[6:0] == 7) & clock;
    
    
     assign datao = rega & & {32{clock}} & {32{state == 1}};
    end
    
    
    


endmodule
