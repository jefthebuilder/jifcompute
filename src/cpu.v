
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
    
        
    
    
    ADDER32 adder1(addr,1,temp_address);
    ALU alu1(clock,rega,regb,h,value,highlow,flag1,flag2,flag3,instr[6:0],regc,addrchange,naddr);
    always @* begin
        // Assign rega based on tempinstr
    assign rega = (tempinstr == 0) ? a :
                  (tempinstr == 1) ? b :
                  (tempinstr == 2) ? c :
                  (tempinstr == 3) ? d :
                  (tempinstr == 4) ? e :
                  (tempinstr == 5) ? f :
                  (tempinstr == 6) ? g :
                  h;

    // Assign regb based on tempinstr1
    assign regb = (tempinstr1 == 0) ? a :
                  (tempinstr1 == 1) ? b :
                  (tempinstr1 == 2) ? c :
                  (tempinstr1 == 3) ? d :
                  (tempinstr1 == 4) ? e :
                  (tempinstr1 == 5) ? f :
                  (tempinstr1 == 6) ? g :
                  h;

    // Assign flag1 based on tempinstr2
    assign flag1 = (tempinstr2 == 0) ? fa :
                   (tempinstr2 == 1) ? fb :
                   (tempinstr2 == 2) ? fc :
                   (tempinstr2 == 3) ? fd :
                   (tempinstr2 == 4) ? fe :
                   (tempinstr2 == 5) ? ff :
                   (tempinstr2 == 6) ? fg :
                   fh;

    // Assign flag2 based on tempinstr3
    assign flag2 = (tempinstr3 == 0) ? fa :
                   (tempinstr3 == 1) ? fb :
                   (tempinstr3 == 2) ? fc :
                   (tempinstr3 == 3) ? fd :
                   (tempinstr3 == 4) ? fe :
                   (tempinstr3 == 5) ? ff :
                   (tempinstr3 == 6) ? fg :
                   fh;
        assign {fa,fb,fc,fd,fe,ff,fg,fh} = ({8{~reset}} & {fa,fb,fc,fd,fe,ff,fg,fh});
    assign {a,b,c,d,e,f,g,h} = ({256{~reset}} & {a,b,c,d,e,f,g,h});
    assign a = ( regc & {32{tempinstr4 == 0}}) | ( a & ( ~{32{tempinstr4 == 0 & a == 0}}))
assign b = ( regc & {32{tempinstr4 == 1}}) | ( b & ( ~{32{tempinstr4 == 1}}));
assign c = ( regc & {32{tempinstr4 == 2}}) | ( c & ( ~{32{tempinstr4 == 2}}));
assign d = ( regc & {32{tempinstr4 == 3}}) | ( d & ( ~{32{tempinstr4 == 3}}));
assign e = ( regc & {32{tempinstr4 == 4}}) | ( e & ( ~{32{tempinstr4 == 4}}));
assign f = ( regc & {32{tempinstr4 == 5}}) | ( f & ( ~{32{tempinstr4 == 5}}));
assign g = ( regc & {32{tempinstr4 == 6}}) | ( g & ( ~{32{tempinstr4 == 6}}));
assign h = ( regc & {32{tempinstr4 == 7}}) | ( h & ( ~{32{tempinstr4 == 7}}));
assign fa = ( regc & {32{tempinstr4 == 0}}) | ( fa & ( ~{1{tempinstr4 == 1}}));
assign fb = ( regc & {32{tempinstr4 == 1}}) | ( fb & ( ~{1{tempinstr4 == 1}}));
assign fc = ( regc & {32{tempinstr4 == 2}}) | ( fc & ( ~{1{tempinstr4 == 2}}));
assign fd = ( regc & {32{tempinstr4 == 3}}) | ( fd & ( ~{1{tempinstr4 == 3}}));
assign fe = ( regc & {32{tempinstr4 == 4}}) | ( fe & ( ~{1{tempinstr4 == 4}}));
assign ff = ( regc & {32{tempinstr4 == 5}}) | ( ff & ( ~{1{tempinstr4 == 5}}));
assign fg = ( regc & {32{tempinstr4 == 6}}) | ( fg & ( ~{1{tempinstr4 == 6}}));
assign fh = ( regc & {1{tempinstr4 == 7}}) | ( fh & ( ~{1{tempinstr4 == 7}}));
    // state 0
    assign addr = ({32{~reset}} & addr);
    assign data = ({32{~reset}} & addr);
    assign instr = ({32{~reset}} & instr);
    assign state = ({2{~reset}} & state);
    assign addrchange = (~reset & addrchange);
   
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
