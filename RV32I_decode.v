/*************************************************************************************/
// RISC-V Instruction Set Decoder
//
// This module decodes the 32-bit RISC-V instruction into its various fields.
//
// Only the RV32I instruction type R,I,S,B,U,J is supported.
/**********************************************************************************/

`include "defines.v"

module RV32I_decode (
    input  wire [31:0] instr,

    output reg  [ 4:0] addr1,
    output reg  [ 4:0] addr2,

    output reg  [ 4:0] writebackaddr
    //output wire [31:0] imm
);
    wire [6:0] funct7;
    wire [2:0] funct3;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    wire [6:0] opcode;
    assign opcode  =  instr[6:0];
    assign funct3  =  instr[14:12];
    assign funct7  =  instr[31:25];
    assign rs1     =  instr[19:15];
    assign rs2     =  instr[24:20];
    assign rd      =  instr[11:7];

    always @(*) begin
        case (opcode)
            `INST_TYPE_R_M: begin// R-type instructions
                /*case (funct3)
                    `INST_ADD_SUB:  begin
                        if(funct7 == 7'h00) begin
                            // ADD
                            addr1 = rs1;
                            addr2 = rs2;
                            writebackaddr = rd;
                        end else if(funct7 == 7'h20) begin
                            // SUB
                            addr1 = rs1;
                            addr2 = rs2;
                            writebackaddr = rd;
                        end
                    end
                    `INST_SLL:  begin

                    end
                    `INST_SLT:  begin

                    end
                    `INST_SLTU: begin

                    end
                    `INST_XOR:  begin

                    end
                    `INST_SRL:  begin

                    end
                    `INST_SRA:  begin

                    end
                    `INST_OR:   begin

                    end
                    `INST_AND:  begin

                    end
                    default: begin

                    end
                endcase*/ 
                addr1 <= rs1;
                addr2 <= rs2;
                writebackaddr <= rd;   
            end
            `INST_TYPE_I: begin
                addr1 <= rs1;
                addr2 <= 5'b0;
                writebackaddr <= rd;
            end
            `INST_TYPE_L: begin
                
            end
            `INST_TYPE_S: begin
                addr1 <= rs1;
                addr2 <= rs2;
                writebackaddr <= 5'b0;
            end
            `INST_TYPE_B: begin
                addr1 <= rs1;
                addr2 <= rs2;
                writebackaddr <= 5'b0;
            end
            `INST_LUI: begin
                addr1 <= 5'b0;
                addr2 <= 5'b0;
                writebackaddr <= rd;
            end
            `INST_AUIPC: begin
                addr1 <= 5'b0;
                addr2 <= 5'b0;
                writebackaddr <= rd;
            end
            `INST_JAL: begin
                addr1 <= 5'b0;
                addr2 <= 5'b0;
                writebackaddr = rd;
            end
            `INST_AUIPC: begin
                addr1 <= 5'b0;
                addr2 <= 5'b0;
                writebackaddr <= rd;
           end
            default: begin/*
						rs1_addr_o = 5'b0;
						rs2_addr_o = 5'b0;
						op1_o 	   = 32'b0;
						op2_o      = 32'b0;
						rd_addr_o  = 5'b0;
						reg_wen    = 1'b0;			*/	
			end
        endcase
    end
    
endmodule