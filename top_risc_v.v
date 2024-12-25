`include "defines.v"

module top_risc_v (
    input  wire        clk,
    input  wire        rst
);
//IF
    wire [31:0] instr_if;
    wire [31:0] pc_if;
//IF/ID
    wire [31:0] instr_id;
    wire [31:0] pc_i_id;
    wire [31:0] pc_next_i_id;
//ID
    wire [31:0] pc_o_id;
    wire [31:0] pc_next_o_id;
    wire [31:0] r1_data_o_id;
    wire [31:0] r2_data_o_id;
    wire [31:0] imm_o_id;
    wire [ 4:0] writebackaddr_o_id;
    wire [31:0] instr_o_id;    
//ID/EX
    wire [31:0] pc_i_ex;
    wire [31:0] pc_next_i_ex;
    wire [31:0] r1_data_i_ex;
    wire [31:0] r2_data_i_ex;
    wire [31:0] instr_i_ex;
    wire [31:0] imm_i_ex;
    wire [ 4:0] writebackaddr_i_ex;
//EX
    wire [31:0] alu_o_ex;
    wire [31:0] pc_next_o_ex;
    wire [31:0] data_o_ex;
    wire [ 4:0] wbaddr_now_o_ex;
    wire [31:0] instr_o_ex;
    wire        jump_en_o_ex;
//EX/MEM
    wire [31:0]  pc_next_i_mem;
    wire [31:0]  alu_i_mem;
    wire [31:0]  data_i_mem;
    wire [ 4:0]  wbaddr_now_i_mem;
    wire [31:0]  instr_i_mem;        
//MEM
    wire [31:0]  data_mem_o_mem;
    wire [31:0]  data_back_o_mem;
    wire [31:0]  data_o_mem;
    wire [31:0]  pc_next_o_mem;
    wire [ 4:0]  wbaddr_o_mem;
    wire [31:0]  instr_o_mem;
//MEM/WB
    wire [31:0] data_mem_i_wb;
    wire [31:0] data_i_wb;
    wire [31:0] pc_next_i_wb;
    wire [ 4:0] wbaddr_i_wb;
    wire [31:0] instr_i_wb;
//WB
    wire [31:0] wbdata_o_wb;
    wire [ 4:0] wbaddr_o_wb;
    wire        wb_en;

    ifetch ifetch_inst (
        .clk          (   clk         ),
        .reset        (   rst         ),
        .pc_jump_i    (   alu_o_ex    ),
        .pc_jump_en_i (   jump_en_o_ex),
        .instr        (   instr_if    ),
        .pc_out       (   pc_if       )
    );


    
    if_id if_id_inst (
        .clk          (   clk         ),
        .reset        (   rst         ),
        .pc_jump_en_i (   jump_en_o_ex),
        .pc_i         (   pc_if       ),
        .instr_i      (   instr_if    ),
        .instr_o      (   instr_id    ),
        .pc_o         (   pc_i_id     ),
        .pc_next_o    (   pc_next_i_id)
    );

    id id_inst(
        .clk                (   clk         ),
        .reset              (   rst         ),

        .instr_i            (   instr_id    ),
        .pc_i               (   pc_i_id     ),
        .pc_next_i          (   pc_next_i_id),

        .w_addr             (   wbaddr_o_wb ),
        .w_data             (   wbdata_o_wb ),
        .wb_en              (   wb_en       ),

        .pc_o               (   pc_o_id     ),
        .pc_next_o          (   pc_next_o_id),

        .r1_data_o          (   r1_data_o_id),
        .r2_data_o          (   r2_data_o_id),

        .instr_o            (   instr_o_id  ),
        
        .imm_o              (   imm_o_id    ),
        .writebackaddr_o    (   writebackaddr_o_id)
    );

    id_ex id_ex_inst (
        .clk                (   clk         ),
        .reset              (   rst         ),
        .pc_jump_en_i       (   jump_en_o_ex),

        .pc_i               (   pc_o_id     ),
        .pc_next_i          (   pc_next_o_id),

        .r1_data_i          (   r1_data_o_id),
        .r2_data_i          (   r2_data_o_id),
        
        .imm_i              (   imm_o_id    ),
        .writebackaddr_i    (   writebackaddr_o_id),

        .instr_i            (   instr_o_id  ),

        .pc_o               (   pc_i_ex     ),
        .pc_next_o          (   pc_next_i_ex),

        .r1_data_o          (   r1_data_i_ex),  
        .r2_data_o          (   r2_data_i_ex),

        .instr_o            (   instr_i_ex  ),
        
        .imm_o              (   imm_i_ex    ),
        .writebackaddr_o    (   writebackaddr_i_ex)
    );

    ex ex_inst (
        .clk                (   clk         ),
        .reset              (   rst         ),

        .pc_i               (   pc_i_ex     ),
        .pc_next_i          (   pc_next_i_ex),

        .r1_data_i          (   r1_data_i_ex),
        .r2_data_i          (   r2_data_i_ex),

        .instr_i            (   instr_i_ex  ),
        
        .imm_i              (   imm_i_ex    ),

        .wbaddr_now_i       (writebackaddr_i_ex),

        .wbdata_past2_i     (   wbdata_o_wb ),
        .wbdata_past1_i     (data_back_o_mem),

        .alu_o              (   alu_o_ex    ),
        .pc_next_o          (   pc_next_o_ex),
        .data_o             (   data_o_ex   ),
        .wbaddr_now_o       (wbaddr_now_o_ex),
        .instr_o            (   instr_o_ex  ),
        .jump_en_o          (  jump_en_o_ex )
    );

    ex_mem ex_mem_inst (
        .clk                (   clk         ),
        .reset              (   rst         ),

        .pc_next_i          (   pc_next_o_ex),
        .alu_i              (   alu_o_ex    ),
        .data_i             (   data_o_ex   ),
        .wbaddr_now_i       (wbaddr_now_o_ex),
        .instr_i            (   instr_o_ex  ),

        .pc_next_o          (  pc_next_i_mem),
        .alu_o              (   alu_i_mem   ),
        .data_o             (   data_i_mem  ),
        .wbaddr_now_o       (wbaddr_now_i_mem),
        .instr_o            (   instr_i_mem  )
    );

    mem mem_inst (
        .reset              (    rst         ),

        .pc_next_i          (   pc_next_i_mem),
        .alu_i              (    alu_i_mem   ),
        .data_i             (    data_i_mem  ),
        .wbaddr_i           (wbaddr_now_i_mem),
        .instr_i            (   instr_i_mem  ),

        .data_mem_o         (  data_mem_o_mem),
        .data_back_o        ( data_back_o_mem),
        .data_o             (   data_o_mem   ),
        .pc_next_o          (   pc_next_o_mem),
        .wbaddr_o           (   wbaddr_o_mem ),
        .instr_o            (   instr_o_mem  )
    );

    mem_wb mem_wb_inst (
        .clk                (   clk         ),
        .reset              (   rst         ),

        .data_men_i         (  data_mem_o_mem),
        .data_i             (    data_o_mem  ),
        .pc_next_i          (   pc_next_o_mem),
        .wbaddr_i           (   wbaddr_o_mem ),
        .instr_i            (   instr_o_mem  ),

        .data_mem_o         (  data_mem_i_wb),
        .data_o             (    data_i_wb   ),
        .pc_next_o          (   pc_next_i_wb),
        .wbaddr_o           (   wbaddr_i_wb ),
        .instr_o            (   instr_i_wb   )
    );

    wb wb_inst (
        .reset              (    rst        ),
        
        .data_men_i         (  data_mem_i_wb),
        .data_i             (    data_i_wb  ),
        .pc_next_i          (   pc_next_i_wb),  
        .wbaddr_i           (   wbaddr_i_wb ),
        .instr_i            (   instr_i_wb  ),

        .wbdata_o           (  wbdata_o_wb  ),
        .wbaddr_o           (   wbaddr_o_wb ),
        .wb_en              (   wb_en       )
    );
endmodule