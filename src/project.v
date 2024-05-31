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
  wire wcount;
  
  reg [31:0] data;
  reg [31:0] dataout;
  reg [31:0] addr;
  assign uio_oe = {8{rw}};
  assign cpuclock = count == 0;
  cpu cpf(data,dataout,addr,rw,cpuclock,rst);
  wire [4:0] tcount <= count == 0 & 1 | count == 1 & 2 | count == 3 & 4 | count == 4 & 5 | count == 6 & 7 | count == 7 & 8 | count == 8 & 0;
  wcount <= posedge clock;
  register regcount(clk,wcount,rst,tcount,count);
  always@(posedge clk)
          begin
               case( count)
                  0: begin

                  
                  end
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
                  data[7:0] <= uio_in;
                  
                  end
                  6: begin
                  data[15:8] <= uio_in;

                  
                  end
                  7: begin
                  data[23:16] <= uio_in;

                  
                  end
                  8: begin
                  data[31:24] <= uio_in;
                  count <= 0;
                  end
                  
               endcase


          end



  // List all unused inputs to prevent warnings
  wire _unused = &{ena, 1'b0,ui_in};

endmodule
