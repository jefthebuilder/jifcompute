/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none
`include "../src/cpu.v"
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
  count = 0;
  data = 0;
  addr = 0;
  end
  cpu cpf(data,addr,data,uio_oe,clk,rst);
  always@(posedge clk)
          begin
               assign uo_out = (count == 3'b000) ? addr[7:0] :
                                (count == 3'b001) ? addr[15:8] :
                                (count == 3'b010) ? addr[23:16] :
                                (count == 3'b011) ? addr[31:24] :
                                8'b0;

                assign uio_out = (count == 3'b000) ? data[7:0] :
                                 (count == 3'b001) ? data[15:8] :
                                 (count == 3'b010) ? data[23:16] :
                                 (count == 3'b011) ? data[31:24] :
                                 8'b0;

                // Continuous assignment for data based on count
                assign data = (count == 3'b100) ? {uio_in[7:0], data[23:8]} :
                                  (count == 3'b101) ? {uio_in[15:8], data[23:16], data[7:0]} :
                                  (count == 3'b110) ? {uio_in[23:16], data[23:24], data[15:0]} :
                                  (count == 3'b111) ? {uio_in[31:24], data[23:8]} :
                                  data;

                // Continuous assignment for next_count
                assign count = (count == 3'b000) ? 3'b001 :
                                    (count == 3'b001) ? 3'b010 :
                                    (count == 3'b010) ? 3'b011 :
                                    (count == 3'b011) ? 3'b100 :
                                    (count == 3'b100) ? 3'b101 :
                                    (count == 3'b101) ? 3'b110 :
                                    (count == 3'b110) ? 3'b111 :
                                    (count == 3'b111) ? 3'b000 :
                                    3'b000;


          end



  // List all unused inputs to prevent warnings
  wire _unused = &{ena, 1'b0};

endmodule
