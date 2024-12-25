`include "defines.v"

module ifetch(
    input clk,
    input reset,
    //input  wire [31:0] pc,
    input wire [31:0] pc_jump_i,
    input wire        pc_jump_en_i,
    output wire  [31:0] instr,
    output wire  [31:0] pc_out
);

    wire [31:0] pc_now;
    //wire [31:0] instr;

    assign pc_out = pc_now;

    pcreg pcreg_inst (
        .clk        (   clk         ),
        .reset      (   reset       ),
        .pc_jump    (   pc_jump_i   ),
        .pc_jump_en ( pc_jump_en_i  ),

        .pc_out     (   pc_now      )
    );

    rom rom_inst (
        .addr   (pc_now ),
        .data   (instr  )
    );


endmodule