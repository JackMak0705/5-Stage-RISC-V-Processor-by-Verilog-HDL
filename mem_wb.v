module mem_wb (
    input wire clk,
    input wire reset,

    input wire [31:0] data_men_i,
    input wire [31:0] data_i,
    input wire [31:0] pc_next_i,
    input wire [ 4:0] wbaddr_i,
    input wire [31:0] instr_i,

    output reg [31:0] data_mem_o,
    output reg [31:0] data_o,
    output reg [31:0] pc_next_o,
    output reg [ 4:0] wbaddr_o,
    output reg [31:0] instr_o
);
    always @(posedge clk) begin
        if (reset) begin
            data_mem_o <= 0;
            data_o <= 0;
            pc_next_o <= 0;
            wbaddr_o <= 0;
            instr_o <= 0;
        end
        else begin
            data_mem_o <= data_men_i;
            data_o <= data_i;
            pc_next_o <= pc_next_i;
            wbaddr_o <= wbaddr_i;
            instr_o <= instr_i;
        end
    end
endmodule