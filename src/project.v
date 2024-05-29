/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_jefloverockets_cpuhandler (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.

  wire rst;
  not(rst,rst_n);
  reg [4:0] count;
  reg [31:0] data;
  reg [31:0] addr;
  assign ui_in = 0;
  always @(posedge rst)
  begin
  assign count = 0;
  assign data = 0;
  assign addr = 0;
  end

  always@(posedge clk)
          begin
               case( count)
                  0: begin
                  cpu f(data,addr,uio_oe,clk,rst);
                  count = 1;
                  end
                  1: begin
                     assign uo_out = addr[7:0];
                     assign uio_out = data[7:0];
                     count = 2;
                  end
                  2: begin
                     assign uo_out = addr[15:7];
                     assign uio_out = data[15:7];
                     count = 3;
                  end
                  3: begin
                  assign uo_out = addr[23:15];
                  assign uio_out = data[23:15];
                  count = 4;
                  end
                  4: begin
                  assign uo_out = addr[31:23];
                  assign uio_out = data[31:23];
                  count = 5;
                  end
                  5: begin
                  data = uio_in[7:0];
                  count = 6;
                  end
                  6: begin
                  data = uio_in[15:7];

                  count = 7;
                  end
                  7: begin
                  data = uio_in[23:15];

                  count = 8;
                  end
                  8: begin
                  data = uio_in[31:23];
                  count = 0;
                  end

               endcase


          end



  // List all unused inputs to prevent warnings
  wire _unused = &{ena, 1'b0};

endmodule
