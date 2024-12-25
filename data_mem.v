module data_mem
#(
    parameter DW = 32,
    parameter AW = 1024
)
(
    input wire reset,
    input wire RW,// 0: read, 1: write

    input wire [31:0] addr,
    input wire [31:0] data_i,

    output reg [31:0] data_o
);
    reg [DW-1:0] rom [0:AW-1];

    always @(*) begin
        if (reset) begin
            data_o <= 0;
        end
        else if (RW) begin
            rom[addr] <= data_i;
            data_o <= 0;
        end
        else begin
            data_o <= rom[addr];
        end
    end
endmodule