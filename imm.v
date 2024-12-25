`include "defines.v"

module imm (
    input  wire  [31:0] instr,
    output reg   [31:0] imm_out
);

wire [6:0] opcode;
assign opcode = instr[6:0];

always @(*) begin
    case (opcode)
        `INST_TYPE_I: begin
            imm_out = {{21{instr[31]}}, instr[31:20]};//符号位扩展
        end
        `INST_TYPE_S: begin
            imm_out = {21'b0, instr[31:25], instr[11:7]};
        end
        `INST_TYPE_B: begin
            imm_out = {{19{instr[31]}},instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};//符号位扩展
        end
        `INST_LUI: begin
            imm_out = {12'b0, instr[31:12]};
        end
        `INST_AUIPC: begin
            imm_out = { 12'b0,instr[31:12]};
        end
        `INST_JAL: begin
            imm_out = {11'b0, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
        end
        `INST_JALR: begin
            imm_out = {11'b0, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
        end        
        default: begin
            imm_out = 32'b0;
        end
    endcase
end

    
endmodule