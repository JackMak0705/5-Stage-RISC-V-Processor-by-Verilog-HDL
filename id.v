`include "defines.v"

module id (
    input wire clk,
    input wire reset,

    input wire [31:0] instr_i,
    input wire [31:0] pc_i,
    input wire [31:0] pc_next_i,

    input wire [ 4:0] w_addr,//回写地址
    input wire [31:0] w_data,//回写数据
    input wire        wb_en,

    output wire [31:0] pc_o,
    output wire [31:0] pc_next_o,

    output wire [31:0] r1_data_o,
    output wire [31:0] r2_data_o,

    //指令信号输出
    output wire [31:0] instr_o,

    output wire [31:0] imm_o,
    output wire [ 4:0] writebackaddr_o

);
    wire [31:0] instr;

    assign instr = instr_i;
    assign instr_o = instr_i;
    assign pc_o = pc_i;
    assign pc_next_o = pc_next_i;

    wire [ 4:0] addr1;
    wire [ 4:0] addr2;
    wire [ 4:0] writebackaddr;

    assign writebackaddr_o = writebackaddr;

    RV32I_decode RV32I_decode_inst (
        .instr          (     instr   ),
        .addr1          (     addr1   ),
        .addr2          (     addr2   ),
        .writebackaddr  (writebackaddr)
    );

    wire [31:0] r1_data;
    wire [31:0] r2_data;

    assign r1_data_o = r1_data;
    assign r2_data_o = r2_data;

    risc_v_reg risc_v_reg_inst (
        .reset          (     reset   ),
        .r1_addr        (     addr1   ),
        .r2_addr        (     addr2   ),
        .w_addr         (     w_addr  ),
        .w_data         (     w_data  ),
        .r1_data        (     r1_data ),
        .r2_data        (     r2_data ),

        .w_en           (     wb_en   )
    );

    wire [31:0] imm;

    assign imm_o = imm;

    imm imm_inst (
        .instr          (     instr   ),
        .imm_out        (     imm   )
    );


endmodule