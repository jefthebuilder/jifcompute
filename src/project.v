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

  
  reg [31:0] data;
  reg [31:0] dataout;
  reg [31:0] addr;
  assign uio_oe = {8{~rw}};
  assign cpuclock = count > 0;
  cpu cpf(data,dataout,addr,rw,cpuclock,rst);
  reg [4:0] tcount;

  counter regcount(clk,1'sb1,rst,tcount,count);
  
  assign tcount = {5{(count < 8)}} & count + 1;
  
  always@(posedge clk)
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
                  data[7:0] <= uio_in;
                  uio_out <= 0;
                  end
                  4'sb0111: begin
                  data[15:8] <= uio_in;
                    uio_out <= 0;
                  
                  end
                  4'sb1000: begin
                  data[23:16] <= uio_in;
                    uio_out <= 0;
                  
                  end
                  4'sb1001: begin
                  data[31:24] <= uio_in;
                  uio_out <= 0;
                  end

               endcase

          end



  // List all unused inputs to prevent warnings
  wire _unused = &{ena, 1'b0,ui_in};

endmodule
