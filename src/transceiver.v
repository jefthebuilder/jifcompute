module transceiver(
    input clock,
    input [7:0] data,
    input reset,
    input inbit,
    output reg done,
    output [7:0] dataout,
    output reg outbit,
);
    reg [3:0] index;
    reg [7:0] data2;
    assign dataout = data2;
    always@(negedge clock)
        begin
              if ( reset) begin
              done <= 0;
              index <= 0;
              if ( ~done) begin

                case (index)
                    0: begin
                        outbit <= data[0];
                        data2[0] <= inbit;
                        index <= 1;
                    end
                    1: begin
                        outbit <= data[1];
                        data2[1] <= inbit;
                        index <= 2;
                    end
                    2: begin
                        outbit <= data[2];
                        data2[2] <= inbit;
                        index <= 3;
                    end
                    3: begin
                        outbit <= data[3];
                        data2[3] <= inbit;
                        index <= 4;
                    end
                    4: begin
                        outbit <= data[0];
                        data2[4] <= inbit;
                        index <= 5;
                    end
                    5: begin
                        outbit <= data[0];
                        data2[5] <= inbit;
                        index <= 6;
                    end
                    6: begin
                        outbit <= data[0];
                        data2[6] <= inbit;
                        index <= 7;
                    end
                    7: begin
                        outbit <= data[0];
                        data2[7] <= inbit;
                        done <= 1;
                        index <= 0;
                    end
               
                endcase
             end
        end


endmodule : transceiver