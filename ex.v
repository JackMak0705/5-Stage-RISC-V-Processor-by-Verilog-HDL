/************************************************************/
/*                                                          */
/*  This is a test file for RISC-V processor design.        */
/*  It is a program for EX stage of the processor.          */
/*                                                          */
/************************************************************/

module ex (
    input wire clk,
    input wire reset,

    input wire [31:0] pc_i,
    input wire [31:0] pc_next_i,

    input wire [31:0] r1_data_i,
    input wire[31:0] r2_data_i,

    input wire [31:0] instr_i,

    input wire [31:0] imm_i,

    input wire [4:0] wbaddr_now_i,//writebackaddr

    input wire [31:0] wbdata_past2_i,//from wb stage
    input wire [31:0] wbdata_past1_i,//from men stage

    output wire [31:0] alu_o,
    output wire [31:0] pc_next_o,
    output wire [31:0] data_o,
    output wire [ 4:0] wbaddr_now_o,

    output wire [31:0] instr_o,

    output wire jump_en_o 

);

    wire [31:0] op1;
    wire [31:0] op2;
    //wire [31:0] data_ex_o;

    wire [31:0] rs1_mux_to_branch;
    wire [31:0] rs2_mux_to_branch;
    wire [ 6:0] opcode_mux_to_branch;

    mux mux_inst(
        .clk            (        clk         ),
        .reset          (        reset       ),

        .pc_i           (        pc_i        ),
        .wbdata_past1_i (    wbdata_past1_i  ),
        .wbdata_past2_i (    wbdata_past2_i  ),

        .r1_data_i      (        r1_data_i   ),
        .r2_data_i      (        r2_data_i   ),
        .imm_i          (        imm_i       ),

        .instr_i        (        instr_i     ),

        .op1_o          (        op1         ),
        .op2_o          (        op2         ),
        .data_o         (        data_o      ),

        .rs1_o          (  rs1_mux_to_branch ),
        .rs2_o          (  rs2_mux_to_branch )
        //.opcode_o       (opcode_mux_to_branch)//无效
    );

    //wire [1:0] sel;

    branch branch_inst(
        .rs1_i          (  rs1_mux_to_branch ),
        .rs2_i          (  rs2_mux_to_branch ),
        //.opcode_i       (opcode_mux_to_branch),
        .instr          (        instr_i     ),

        //.sel            (        sel         )
        .jump_en        (       jump_en_o    )
    );

    alu alu_inst(
        .reset          (        reset       ),
        
        .op1_i          (        op1         ),
        .op2_i          (        op2         ),
        .instr          (        instr_i     ),
        .pc_i           (        pc_i        ),

        //.sel            (        sel         ),

        .res_o          (        alu_o       )
    );

    assign pc_next_o = pc_next_i;
    assign wbaddr_now_o = wbaddr_now_i;
    assign instr_o = instr_i;

endmodule