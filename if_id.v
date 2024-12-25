`include "defines.v"

module if_id (
    input  wire        clk,
    input  wire        reset,
    input  wire        pc_jump_en_i,

    input  wire [31:0] pc_i,
    //input  wire [31:0] pc_next_i,
    input  wire [31:0] instr_i,

    output reg  [31:0] pc_o,
    output reg  [31:0] pc_next_o,
    output reg  [31:0] instr_o
);
    always @(posedge clk) begin
        if(reset||pc_jump_en_i) begin
            pc_o        <=  32'b0;
            pc_next_o   <=  32'b0;
            instr_o     <=  `INST_NOP;
        end
        else begin
            pc_o        <=  pc_i;
            pc_next_o   <=  pc_i + 4;
            instr_o     <=  instr_i;
        end        
    end
endmodule