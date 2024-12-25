`include "defines.v"

module top_if_id (
    input  wire        clk,
    input  wire        rst,

    output wire [31:0] pc_o_ex,
    output wire [31:0] pc_next_o_ex,
    output wire [31:0] r1_data_o_ex,
    output wire [31:0] r2_data_o_ex,
    output wire [31:0] imm_o_ex,
    output wire [ 4:0] writebackaddr_o_ex,
    output wire [31:0] instr_o_ex
    
);
//IF
    wire [31:0] instr_if;
    wire [31:0] pc_if;

    ifetch ifetch_inst (
        .clk        (   clk         ),
        .reset      (   rst         ),
        .instr      (   instr_if    ),
        .pc_out     (   pc_if       )
    );

//IF/ID

    wire [31:0] instr_id;
    wire [31:0] pc_i_id;
    wire [31:0] pc_next_i_id;
    
    if_id if_id_inst (
        .clk        (   clk         ),
        .reset      (   rst         ),
        .pc_i       (   pc_if       ),
        .instr_i    (   instr_if    ),
        .instr_o    (   instr_id    ),
        .pc_o       (   pc_i_id     ),
        .pc_next_o  (   pc_next_i_id)
    );

//ID

    wire [31:0] pc_o_id;
    wire [31:0] pc_next_o_id;
    wire [31:0] r1_data_o_id;
    wire [31:0] r2_data_o_id;
    wire [31:0] imm_o_id;
    wire [ 4:0] writebackaddr_o_id;
    wire [31:0] instr_o_id;

    id id_inst(
        .clk                (   clk         ),
        .reset              (   rst         ),

        .instr_i            (   instr_id    ),
        .pc_i               (   pc_i_id     ),
        .pc_next_i          (   pc_next_i_id),

        .w_addr             (   ),
        .w_data             (   ),
        
        .pc_o               (   pc_o_id     ),
        .pc_next_o          (   pc_next_o_id),

        .r1_data_o          (   r1_data_o_id),
        .r2_data_o          (   r2_data_o_id),

        .instr_o            (   instr_o_id  ),
        
        .imm_o              (   imm_o_id    ),
        .writebackaddr_o    (   writebackaddr_o_id)
    );

//ID/EX
    //wire [31:0] pc_o_ex;
    //wire [31:0] pc_next_o_ex;
    //wire [31:0] r1_data_o_ex;
    //wire [31:0] r2_data_o_ex;
    //wire [31:0] instr_o_ex;
    //wire [31:0] imm_o_ex;
    //wire [ 4:0] writebackaddr_o_ex;

    id_ex id_ex_inst (
        .clk                (   clk         ),
        .reset              (   rst         ),

        .pc_i               (   pc_o_id     ),
        .pc_next_i          (   pc_next_o_id),

        .r1_data_i          (   r1_data_o_id),
        .r2_data_i          (   r2_data_o_id),
        
        .imm_i              (   imm_o_id    ),
        .writebackaddr_i    (   writebackaddr_o_id),

        .instr_i            (   instr_o_id  ),

        .pc_o               (   pc_o_ex     ),
        .pc_next_o          (   pc_next_o_ex),

        .r1_data_o          (   r1_data_o_ex),  
        .r2_data_o          (   r2_data_o_ex),

        .instr_o            (   instr_o_ex  ),
        
        .imm_o              (   imm_o_ex    ),
        .writebackaddr_o    (   writebackaddr_o_ex)
    );


endmodule