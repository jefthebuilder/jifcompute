/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_jefloverockets_cpuhandler (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output reg [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output reg [7:0] uio_out,  // IOs: Output path
    output reg [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  wire cpuclock;
  wire rw;
  wire rst;
  not(rst,rst_n);
  wire [4:0] count;

  
  wire [31:0] data;
  wire [31:0] dataio;

   wire [7:0] data1o;
   wire [7:0] data2o;
   wire [7:0] data3o;
   wire [7:0] data4o;
   wire wdata1;
   wire  wdata2;
   wire  wdata3;
   wire  wdata4;
   register8 reg_data1(clk,wdata1,rst,dataio,data1o);
   register8 reg_data2(clk,wdata2,rst,dataio,data2o);
   register8 reg_data3(clk,wdata3,rst,dataio,data3o);
   register8 reg_data4(clk,wdata4,rst,dataio,data4o);
  assign data = {data4o,data3o,data2o,data1o};
  assign dataio = uio_in;
  assign wdata1 = tcount == 6;
  assign wdata2 = tcount == 7;
  assign wdata3 = tcount == 8;
  assign wdata4 = tcount == 9;
  wire [31:0] dataout;
  reg [31:0] addr;
  assign uio_oe = {8{~rw}};
  assign cpuclock = count == 0;
  cpu cpf(data,dataout,addr,rw,cpuclock,rst);
  reg [4:0] tcount;

  counter regcount(clk,1'sb1,rst,tcount,count);
  
  assign tcount = {5{(count < 9)}} & count + 1;
  
  always@(negedge clk)
          begin

               case( count)

                  4'sb0001: begin
                      uo_out <= addr[7:0];
                      uio_out <= dataout[7:0];
                     
                  end
                  4'sb0010: begin
                      uo_out <= addr[15:8];
                      uio_out <= dataout[15:8];
                     
                  end
                  4'sb0011: begin
                   uo_out <= addr[23:16];
                   uio_out <= dataout[23:16];
                  
                  end
                  4'sb0100: begin
                   uo_out <= addr[31:24];
                   uio_out <= dataout[23:16];

                   end
                  4'sb0101: begin
                   uo_out[0] <= ~rw;
                   uio_out <= 0;

                  end
                  4'sb0110: begin

                  uio_out <= data2o;
                  end
                  4'sb0111: begin

                    uio_out <= data3o;
                  
                  end
                  4'sb1000: begin

                    uio_out <= data4o;
                  
                  end
                  4'sb0000: begin
                    uio_out <= data1o;

                  end

               endcase

          end



  // List all unused inputs to prevent warnings
  wire _unused = &{ena, 1'b0,ui_in};

endmodule
