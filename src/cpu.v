module register(clock, r_enable, clear, data_in, data_out);

input             clock;
input             r_enable;
input             clear;
input      [31:0] data_in;
output reg [31:0] data_out;

always @(posedge clock)
begin
    if(r_enable)
        data_out <= data_in;
    if (clear)
        data_out <= 0;
end

endmodule
module registeraddr(clock, r_enable, clear, data_in, data_out);

input             clock;
input             r_enable;
input             clear;
input      [31:0] data_in;
output reg [31:0] data_out;

always @(posedge clock)
begin
    if(r_enable)
        data_out <= data_in;
    if (clear)
        data_out <= 0;
end

endmodule


module counter(clock, r_enable, clear, data_in, data_out);

input             clock;
input             r_enable;
input             clear;
input      [4:0] data_in;
output reg [4:0] data_out;

always @(posedge clock)
begin
    if(r_enable)
        data_out <= data_in;
    if (clear)
        data_out <= 0;
end

endmodule

module State(clock, r_enable, clear, data_in, data_out);

input             clock;
input             r_enable;
input             clear;
input    [2:0]         data_in;
output reg   [2:0]     data_out;

always @(posedge clock)
begin
    if(r_enable)
        data_out <= data_in;
    if (clear)
        data_out <= 0;
end


endmodule

module flag(clock, r_enable, clear, data_in, data_out);

input             clock;
input             r_enable;
input             clear;
input             data_in;
output reg        data_out;

always @(clock)
begin
    if(r_enable)
        data_out <= data_in;
    if (clear)
        data_out <= 0;
end

endmodule

module cpu(
    input [31:0] data,
    output [31:0] datao,
    output [31:0] address,
    output rw,
    input clk,
    input clock, // register clock for resetting
    input reset
);
    wire [31:0] a,b,c,d,e,f,g,h;
    wire [31:0] ao,bo,co,do1,eo,fo,go,ho;
    wire wa,wb,wc,wd,we,wf,wg,wh;
    wire fa,fb,fc,fd,fe,ff,fg,fh;
    wire fao,fbo,fco,fdo,feo,ffo,fgo,fho;
    wire fwa,fwb,fwc,fwd,fwe,fwf,fwg,fwh;
    register reg_a(clock,wa,reset,a,ao);
    register reg_b(clock,wb,reset,b,bo);
    register reg_c(clock,wc,reset,c,co);
    register reg_d(clock,wd,reset,d,do1);
    register reg_e(clock,we,reset,e,eo);
    register reg_f(clock,wf,reset,f,fo);
    register reg_g(clock,wg,reset,g,go);
    register reg_h(clock,wh,reset,h,ho);
    flag flag_a(clock,fwa,reset,fa,fao);
    flag flag_b(clock,fwb,reset,fb,fbo);
    flag flag_c(clock,fwc,reset,fc,fco);
    flag flag_d(clock,fwd,reset,fd,fdo);
    flag flag_e(clock,fwe,reset,fe,feo);
    flag flag_f(clock,fwf,reset,ff,ffo);
    flag flag_g(clock,fwg,reset,fg,fgo);
    flag flag_h(clock,fwh,reset,fh,fho);
    reg addrchange;
    wire [2:0] state;
    wire [2:0] stato;
    wire wstate;
    State stat(clock,wstate,reset,state,stato);
    wire [31:0] addr;
    wire [31:0] addro;
    wire waddr;
    registeraddr reg_addr(clock,waddr,reset,addr,addro);
    wire [31:0] instr;
    wire [31:0] instro;
    wire winstr;
    register reg_instr(~clock,winstr,reset,instr,instro);
    wire [31:0] rega;
    wire [31:0] regb;
    wire [31:0] regc;
    wire [15:0] value;
    wire flag1;
    wire flag2;
    wire flag3;
    wire highlow;
    wire [31:0] temp_address;
    
    reg [31:0] naddr;
    wire temp2;
    wire writinginstr;
    wire [2:0] tempinstr = instro[8:6];
    wire [2:0] tempinstr1 = instro[11:9];
    wire [2:0] tempinstr2 = instro[8:6];
    wire [2:0] tempinstr3 = instro[11:9];
    wire [2:0] tempinstr4 = instro[14:12];
    assign highlow = instro[15:15];
    assign value = instro[31:16];

    assign instr = data;
    assign winstr = stato == 0;
    assign writinginstr = (instro[5:0] == 7);

    ADDER32 adder1(addro,1,temp_address);
    ALU alu1(clk,rega,regb,regb,value,highlow,flag1,flag2,flag3,instro[5:0],regc,addrchange,naddr);

        // Assign rega based on tempinstr
    assign rega = (tempinstr == 0) ? ao :
                  (tempinstr == 1) ? bo :
                  (tempinstr == 2) ? co :
                  (tempinstr == 3) ? do1 :
                  (tempinstr == 4) ? eo :
                  (tempinstr == 5) ? fo :
                  (tempinstr == 6) ? go :
                  ho;

    // Assign regb based on tempinstr1
    assign regb = (tempinstr1 == 0) ? ao :
                  (tempinstr1 == 1) ? bo :
                  (tempinstr1 == 2) ? co :
                  (tempinstr1 == 3) ? do1 :
                  (tempinstr1 == 4) ? eo :
                  (tempinstr1 == 5) ? fo :
                  (tempinstr1 == 6) ? go :
                  ho;

    // Assign flag1 based on tempinstr2
    assign flag1 = (tempinstr2 == 0) ? fao :
                   (tempinstr2 == 1) ? fbo :
                   (tempinstr2 == 2) ? fco :
                   (tempinstr2 == 3) ? fdo :
                   (tempinstr2 == 4) ? feo :
                   (tempinstr2 == 5) ? ffo :
                   (tempinstr2 == 6) ? fgo :
                   fho;

    // Assign flag2 based on tempinstr3
    assign flag2 = (tempinstr3 == 0) ? fao :
                   (tempinstr3 == 1) ? fbo :
                   (tempinstr3 == 2) ? fco :
                   (tempinstr3 == 3) ? fdo :
                   (tempinstr3 == 4) ? feo :
                   (tempinstr3 == 5) ? ffo :
                   (tempinstr3 == 6) ? fgo :
                   fho;
       
    assign a = regc;
    assign wa =  {1{tempinstr4 == 0}};
    assign b = ( regc ) ;
    assign wb =  {1{tempinstr4 == 1}};
    assign c = ( regc ) ;
    assign wc =  {1{tempinstr4 == 2}};
    assign d = ( regc );
    assign wd =  {1{tempinstr4 == 3}};
    assign e = ( regc );
    assign we =  {1{tempinstr4 == 4}};
    assign f = ( regc);
    assign wf =  {1{tempinstr4 == 5}};
    assign g = ( regc) ;
    assign wg =  {1{tempinstr4 == 6}};
    assign h = ( regc );
    assign wh =  {1{tempinstr4 == 7}};
    assign fa = ( flag3);
    assign fwa =  {1{tempinstr4 == 0}};
    assign fb = ( flag3);
    assign fwb =  {1{tempinstr4 == 1}};
    assign fc = ( flag3);
    assign fwc =  {1{tempinstr4 == 2}};
    assign fd = ( flag3 );
    assign fwd =  {1{tempinstr4 == 3}};
    assign fe = ( flag3);
    assign fwe =  {1{tempinstr4 == 4}};
    assign ff = ( flag3);
    assign fwf =  {1{tempinstr4 == 5}};
    assign fg = ( flag3);
    assign fwg =  {1{tempinstr4 == 6}};
    assign fh = ( flag3);
    assign fwh =  {1{tempinstr4 == 7}};
    // state 0
  wire [31:0] state1 = {32{stato == 1}};
   wire [31:0] tempaddr = ((addro & {32{stato == 0}}) | ( & naddr));
  // assign address = ((tempaddr == 0) & addro) | ((tempaddr != 0) & tempaddr);
wire taddr = naddr != 0 & stato == 1;
 assign address = ({32{taddr}} & naddr) | ({32{~taddr}} & addro);
   //assign address= addro;
   assign rw = (stato == 0) | ((stato != 0) & writinginstr);
    assign state = ((({3{stato == 0}} & 1) | ({3{stato == 1}} & 2) ) | ({3{stato == 2}} & 0));
     assign wstate = clk;
    // state 1 removed temp change
     
     assign temp2 = ~addrchange;
    assign addr = ((({32{temp2}} & temp_address) | {32{~temp2}} & naddr));
    assign waddr = {1{stato == 2}};

    

     assign datao = instro;
    
    
    
    


endmodule
