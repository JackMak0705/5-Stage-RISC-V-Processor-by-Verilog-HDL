`include "defines.v"

module testbench_if_id;

reg clkstim, rststim;
wire [31:0] pc_o_exwatch,pc_next_o_exwatch,r1_data_o_exwatch,r2_data_o_exwatch,
            imm_o_exwatch;
wire [31:0] instr_o_exwatch;
wire [ 4:0] writebackaddr_o_exwatch;


top_if_id top_if_id_inst(
   .clk                 (        clkstim        ),
   .rst                 (        rststim        ),

   .pc_o_ex             (     pc_o_exwatch      ),
   .pc_next_o_ex        (    pc_next_o_exwatch  ),  

   .r1_data_o_ex        (    r1_data_o_exwatch  ),
   .r2_data_o_ex        (    r2_data_o_exwatch  ),

   .instr_o_ex          (    instr_o_exwatch    ),
   
   .imm_o_ex            (    imm_o_exwatch      ),
   .writebackaddr_o_ex  (writebackaddr_o_exwatch)
);

always #5 clkstim = ~clkstim;

initial begin
    #0 rststim = 1'b1; 
    #5 clkstim = 1'b0;
    #10 rststim = 1'b0;
    #1000 $finish;
end


endmodule