`include "defines.v"

module alu (
    input wire reset,

    input wire [31:0] op1_i,
    input wire [31:0] op2_i,
    input wire [31:0] instr,
    input wire [31:0] pc_i,

    input wire [1:0] sel,

    output reg [31:0] res_o
);
    
    wire [6:0] funct7;
    wire [2:0] funct3;
    wire [6:0] opcode;
    assign opcode  =  instr[6:0];
    assign funct3  =  instr[14:12];
    assign funct7  =  instr[31:25];

    always @(*) begin
        if(reset) begin
            res_o = 32'h0;
        end
        else begin
            case (opcode)
               `INST_TYPE_R_M: begin
                   case (funct3)
                       `INST_ADD_SUB_MUL: begin
                            if(funct7 ==7'h00) begin
                                res_o = op1_i + op2_i;
                            end
                            else if(funct7 ==7'h20) begin
                                res_o = op1_i - op2_i;
                            end
                            else if(funct7 ==7'h01) begin
                                res_o = op1_i * op2_i;
                            end
                       end
                       `INST_SLL_MULH:  begin
                            if(funct7 ==7'h00) begin
                                res_o = op1_i << op2_i;
                            end
                            else if(funct7 ==7'h01) begin
                                res_o = op1_i * op2_i >> 32;
                            end
                        end
                        `INST_SLT_MULHSU:  begin
                            if(funct7 ==7'h00) begin
                                res_o = (op1_i < op2_i) ? 32'h1 : 32'h0;
                            end
                            else if(funct7 ==7'h01) begin
                                res_o = $signed(op1_i) * $signed(op2_i) >> 32;//mulhsu
                            end
                        end
                        `INST_SLTU_MULHU: begin
                            if(funct7 ==7'h00) begin
                                res_o = (op1_i < op2_i) ? 32'h1 : 32'h0;
                            end
                            else if(funct7 ==7'h01) begin
                                res_o = $unsigned(op1_i) * $unsigned(op2_i) >> 32;//mulhu
                            end
                        end
                        `INST_XOR_DIV:  begin
                            if(funct7 ==7'h00) begin
                                res_o = op1_i ^ op2_i;
                            end
                            else if(funct7 ==7'h01) begin
                                res_o = op1_i / op2_i;
                            end
                        end
                        `INST_SRA_SRL_DIVU:  begin//shift right logical
                            if(funct7 ==7'h00) begin
                                res_o = op1_i >> op2_i;
                            end
                            else if(funct7 ==7'h01) begin
                                res_o = $signed(op1_i) / $signed(op2_i);
                            end
                        end
                        `INST_OR_REM:   begin
                            if(funct7 ==7'h00) begin
                                res_o = op1_i | op2_i;
                            end
                            else if(funct7 ==7'h01) begin
                                res_o = op1_i % op2_i;
                            end
                        end
                        `INST_AND_REMU:  begin
                            if(funct7 ==7'h00) begin
                                res_o = op1_i & op2_i;
                            end
                            else if(funct7 ==7'h01) begin
                                res_o = $signed(op1_i) % $signed(op2_i);
                            end
                        end
                        default: begin
                        
                        end
                    endcase
                end
               `INST_TYPE_I: begin
                   case (funct3)
                       `INST_ADDI: begin
                            res_o = op1_i + op2_i;
                       end
                       `INST_SLTI: begin
                            res_o = (op1_i < op2_i) ? 32'h1 : 32'h0;
                       end
                       `INST_SLTIU: begin
                            res_o = (op1_i < op2_i) ? 32'h1 : 32'h0;
                       end
                       `INST_XORI: begin
                            res_o = op1_i ^ op2_i;
                       end
                       `INST_ORI: begin
                            res_o = op1_i | op2_i;
                       end
                       `INST_ANDI: begin
                            res_o = op1_i & op2_i;
                       end
                       `INST_SLLI: begin
                            res_o = op1_i << op2_i;
                       end
                       `INST_SRLI: begin//后续和SRAI一起处理
                            res_o = op1_i >> op2_i;
                       end
                       `INST_SRAI: begin//
                            res_o = op1_i >> op2_i;
                       end
                       default: begin
                       end
                   endcase
               end
               `INST_TYPE_L: begin
               end
               `INST_TYPE_S: begin  
                   case (funct3)
                       `INST_SB: begin

                       end
                       `INST_SH: begin
                       end
                       `INST_SW: begin
                           res_o = op1_i + op2_i;
                       end
                       default: begin
                       end
                   endcase
               end
               `INST_TYPE_B: begin
                   res_o = op1_i + op2_i;//output pc_i + imm
               end
               `INST_JAL: begin
               end
               `INST_JALR: begin
               end
               `INST_LUI: begin
                   res_o = op2_i << 12;
               end
               `INST_AUIPC: begin
                   res_o = pc_i + (op2_i << 12);
               end
               default: begin
               end
        endcase
        end
    end 
endmodule