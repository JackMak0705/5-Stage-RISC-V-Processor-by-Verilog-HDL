module ex_mem (
    input wire clk,
    input wire reset,

    input wire [31:0] pc_next_i,
    input wire [31:0] alu_i,
    input wire [31:0] data_i,
    input wire [ 4:0] wbaddr_now_i,
    input wire [31:0] instr_i,

    output reg [31:0] pc_next_o,
    output reg [31:0] alu_o,
    output reg [31:0] data_o,
    output reg [ 4:0] wbaddr_now_o,
    output reg [31:0] instr_o
);
    always @(posedge clk) begin
        if (reset) begin
            pc_next_o <= 0;
            alu_o <= 0;
            data_o <= 0;
            wbaddr_now_o <= 0;
            instr_o <= 0;
        end 
        else begin
            pc_next_o <= pc_next_i;
            alu_o <= alu_i;
            data_o <= data_i;
            wbaddr_now_o <= wbaddr_now_i;
            instr_o <= instr_i;
        end
    end
endmodule