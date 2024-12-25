`include "defines.v"

module mux (
    input wire clk,
    input wire reset,

    input wire [31:0] pc_i,
    input wire [31:0] wbdata_past2_i,//from WB stage
    input wire [31:0] wbdata_past1_i,//from MEM stage

    input wire [31:0] r1_data_i,
    input wire [31:0] r2_data_i,
    input wire [31:0] imm_i,

    input wire [31:0] instr_i,

    output wire [31:0] op1_o,
    output wire [31:0] op2_o,
    output wire [31:0] data_o,

    output wire [31:0] rs1_o,
    output wire [31:0] rs2_o
    //output wire [ 6:0] opcode_o
);
    //wire [6:0] funct7_a;
    //wire [2:0] funct3_a;
    wire [4:0] rs1_a;
    wire [4:0] rs2_a;
    wire [4:0] rd_a;
    wire [6:0] opcode_a; 

    assign opcode_a  =  instr_i[6:0];
    //assign funct3_a  =  instr_i[14:12];
    //assign funct7_a  =  instr_i[31:25];
    assign rs1_a     =  instr_i[19:15];
    assign rs2_a     =  instr_i[24:20];
    assign rd_a      =  instr_i[11:7];
    
    assign rs1_o     =  rs1_a;
    assign rs2_o     =  rs2_a;
    //assign opcode_o  =  opcode_a;

    //reg [4:0] rs1_b;
    //reg [4:0] rs2_b;
    reg [4:0] rd_b;

    //reg [4:0] rs1_c;
    //reg [4:0] rs2_c;
    reg [4:0] rd_c;

    always @(posedge clk) begin
        if (reset) begin
            rd_b <= 0;
            rd_c <= 0;
        end
        else begin
            rd_b <= rd_a;
            rd_c <= rd_b;
        end
    end
    
    wire [31:0] mux3_1_o;
    wire [31:0] mux3_2_o;

    wire [31:0] mux2_1_o;
    wire [31:0] mux2_2_o;

    assign op1_o = mux2_1_o;
    assign op2_o = mux2_2_o;
    assign data_o = mux3_2_o;

    assign mux3_1_o = (rs1_a == rd_b)? wbdata_past1_i:((rs1_a == rd_c)? wbdata_past2_i:r1_data_i);//优先使用新值
    assign mux3_2_o = (rs2_a == rd_b)? wbdata_past1_i:((rs2_a == rd_c)? wbdata_past2_i:r2_data_i);//优先使用新值

    assign mux2_1_o = ((opcode_a == `INST_TYPE_B)||(opcode_a == `INST_AUIPC)||
                       (opcode_a == `INST_JAL)||(opcode_a == `INST_JALR))? pc_i:mux3_1_o;//使用pc作为跳转

    assign mux2_2_o = ((opcode_a == `INST_TYPE_S)||(opcode_a == `INST_TYPE_I)||
                       (opcode_a == `INST_TYPE_B)||(opcode_a == `INST_JAL)||
                       (opcode_a == `INST_JALR)||(opcode_a == `INST_LUI)||
                       (opcode_a == `INST_AUIPC)||(opcode_a ==`INST_TYPE_L))? imm_i:mux3_2_o;

endmodule