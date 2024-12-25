module id_ex (
    input wire clk,
    input wire reset,
    input  wire        pc_jump_en_i,

    input wire [31:0] pc_i,
    input wire [31:0] pc_next_i,

    input wire [31:0] r1_data_i,
    input wire [31:0] r2_data_i,

    input wire [31:0] imm_i,
    input wire [ 4:0] writebackaddr_i,

    //指令信号输入
    input wire [31:0] instr_i,

    output reg [31:0] pc_o,
    output reg [31:0] pc_next_o,

    output reg [31:0] r1_data_o,
    output reg [31:0] r2_data_o,

    //指令信号输出
    output reg [31:0] instr_o,

    output reg [31:0] imm_o,
    output reg [ 4:0] writebackaddr_o
);
    always @(posedge clk) begin
        if (reset||pc_jump_en_i) begin
            pc_o        <=  32'b0;
            pc_next_o   <=  32'b0;
            r1_data_o   <=  32'b0;
            r2_data_o   <=  32'b0;
            imm_o       <=  32'b0;
            writebackaddr_o <=  32'b0;
            instr_o     <=  32'b0;
        end
        else begin
            pc_o        <=  pc_i;
            pc_next_o   <=  pc_next_i;
            r1_data_o   <=  r1_data_i;
            r2_data_o   <=  r2_data_i;
            imm_o       <=  imm_i;
            writebackaddr_o <=  writebackaddr_i;
            instr_o     <=  instr_i;
        end
    end 

endmodule