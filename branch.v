`include "defines.v"

module branch (
    input wire [31:0] rs1_i,
    input wire [31:0] rs2_i,
    //input wire [ 6:0] opcode_i,
    input wire [31:0] instr,

    //output reg [1:0] sel
    output reg jump_en
);
/*
    always @(*) begin
        if (opcode_i == `INST_TYPE_B) begin
            if (rs1_i == rs2_i) sel = 2'h0;
            else if (rs1_i != rs2_i) sel = 2'h1;
            else if (rs1_i  < rs2_i) sel = 2'h2;
            else if (rs1_i  >= rs2_i) sel = 2'h3;
        end
        else sel = 2'hz;
    end*/
    wire [ 6:0] opcode;
    wire [ 3:0] funct3;

    assign opcode = instr[ 6:0];
    assign funct3 = instr[14:12];

    always @(*) begin
        if (opcode == `INST_TYPE_B) begin
            if (funct3 == `INST_BEQ) begin
                if (rs1_i == rs2_i) jump_en = 1'b1;
                else jump_en = 1'b0;
            end
            else if (funct3 == `INST_BNE) begin
                if (rs1_i != rs2_i) jump_en = 1'b1;
                else jump_en = 1'b0;
            end
            else if (funct3 == `INST_BLT) begin
                if (rs1_i  < rs2_i) jump_en = 1'b1;
                else jump_en = 1'b0;
            end
            else if (funct3 == `INST_BGE) begin
                if (rs1_i  >= rs2_i) jump_en = 1'b1;
                else jump_en = 1'b0;
            end
            else if (funct3 == `INST_BLTU) begin
                if ($signed(rs1_i) < $signed(rs2_i)) jump_en = 1'b1;
                else jump_en = 1'b0;
            end
            else if (funct3 == `INST_BGEU) begin
                if ($unsigned(rs1_i) >= $unsigned(rs2_i)) jump_en = 1'b1;
                else jump_en = 1'b0;
            end
            else jump_en = 1'b0;
        end

        else jump_en = 1'b0;
    end
endmodule