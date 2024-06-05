module transceiver(
    input clock,
    input [7:0] data,
    input reset,
    input inbit,
    output done,
    output [7:0] dataout,
    output outbit,
);
    reg [3:0] index;
    reg [7:0] data2;
    always@(negedge clock)
        begin

                case (index)
                    0: begin
                        assign outbit = data[0];
                        data2[0] = inbit;
                        assign index = 1;
                    end
                    1: begin
                        assign outbit = data[1];
                        data2[1] = inbit;
                        assign index = 2;
                    end
                    2: begin
                        assign outbit = data[2];
                        data2[2] = inbit;
                        assign index = 3;
                    end
                    3: begin
                        assign outbit = data[3];
                        data2[3] = inbit;
                        assign index = 4;
                    end
                    4: begin
                        assign outbit = data[0];
                        data2[4] = inbit;
                        assign index = 5;
                    end
                    5: begin
                        assign outbit = data[0];
                        data2[5] = inbit;
                        assign index = 6;
                    end
                    6: begin
                        assign outbit = data[0];
                        data2[6] = inbit;
                        assign index = 7;
                    end
                    7: begin
                        assign outbit = data[0];
                        data2[7] = inbit;
                        assign done = 1;
                        assign index = 0;
                    end

                endcase

        end


endmodule : transceiver