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
  wire [5:0] count;


  wire [63:0] data;
  wire [7:0] dataio;

   reg [7:0] data1;
   reg [7:0] data2;
   reg [7:0] data3;
   reg [7:0] data4;
    
    reg [7:0] data5;
    reg [7:0] data6;
    reg [7:0] data7;
    reg [7:0] data8;


    assign data = {data1,data2,data3,data4,data5,data6,data7,data8};
  assign dataio = uio_in;

  wire [63:0] dataout;
  wire [63:0] addr;
  assign uio_oe = {8{~rw}};
  assign cpuclock = count != 0;
  cpu cpf(data,dataout,addr,rw,cpuclock,cpuclock,rst);
    reg [5:0] tcount;

  counter regcount(clk,1'sb1,rst,tcount,count);
  
    assign tcount = {6{(count <= 16)}} & count + 1;

  always@(negedge clk)
          begin

               case( count)

                  1: begin
                      uo_out <= addr[7:0];
                      uio_out <= dataout[7:0];
                     
                  end
                  2: begin
                      uo_out <= addr[15:8];
                      uio_out <= dataout[15:8];
                     
                  end
                  3: begin
                   uo_out <= addr[23:16];
                   uio_out <= dataout[23:16];
                  
                  end
                  4: begin
                   uo_out <= addr[31:24];
                   uio_out <= dataout[31:24];

                   end
                   
                  5: begin
                      uo_out <= addr[39:32];
                      uio_out <= dataout[39:32];
                     
                  end
                  6: begin
                      uo_out <= addr[47:40];
                      uio_out <= dataout[47:40];
                     
                  end
                  7: begin
                      uo_out <= addr[55:48];
                      uio_out <= dataout[55:48];
                  
                  end
                  8: begin
                      uo_out <= addr[63:56];
                      uio_out <= dataout[63:56];

                   end
                  9: begin
                   uo_out[0] <= ~rw;
                   uio_out <= 0;

                  end
                  10: begin
                    data1 <= uio_in;
                    uo_out <= 0;
                    uio_out <= 0;
                    //uio_out <= dataout[7:0];
                  end
                  11: begin
                    data2 <= uio_in;
uo_out <= 0;
                    uio_out <= 0;
                    //uio_out <= dataout[15:8];
                  
                  end
                  12: begin
                    data3 <= uio_in;
uo_out <= 0;
                    uio_out <= 0;
                     //uio_out <= dataout[15:8];
                  
                  end
                  13: begin
                    data4 <= uio_in;
                    uo_out <= 0;
                                        uio_out <= 0;
                    //uio_out <= dataout[23:16];

                  end
                   
                  14: begin
                    data5 <= uio_in;
                    uo_out <= 0;
                    uio_out <= 0;
                    //uio_out <= dataout[7:0];
                  end
                  15: begin
                    data6 <= uio_in;
uo_out <= 0;
                    uio_out <= 0;
                    //uio_out <= dataout[15:8];
                  
                  end
                  16: begin
                    data7 <= uio_in;
uo_out <= 0;
                    uio_out <= 0;
                     //uio_out <= dataout[15:8];
                  
                  end
                  17: begin
                    data8 <= uio_in;
                    uo_out <= 0;
                                        uio_out <= 0;
                    //uio_out <= dataout[23:16];

                  end
                  default: begin
                  uo_out <= 0;
                  uio_out <= 0;
                  end

               endcase

          end



  // List all unused inputs to prevent warnings
  wire _unused = &{ena, 1'b0,ui_in};

endmodule
