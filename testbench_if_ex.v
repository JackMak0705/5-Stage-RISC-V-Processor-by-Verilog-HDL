`include "defines.v"

module testbench_if_ex;

reg clkstim, rststim;
wire [31:0] pc_next_i_memwatch,alu_i_memwatch,data_i_memwatch,instr_i_memwatch;
wire [ 4:0] wbaddr_now_i_memwatch;


top_if_ex top_if_ex_inst(
   .clk                 (        clkstim        ),
   .rst                 (        rststim        ),

   .pc_next_i_mem       (   pc_next_i_memwatch  ),
   .alu_i_mem           (   alu_i_memwatch      ),
   .data_i_mem          (   data_i_memwatch     ),
   .wbaddr_now_i_mem    (   wbaddr_now_i_memwatch),
   .instr_i_mem         (   instr_i_memwatch    )
);

always #5 clkstim = ~clkstim;

initial begin
    #0 rststim = 1'b1; 
    #5 clkstim = 1'b0;
    #10 rststim = 1'b0;
    #1000 $finish;
end


endmodule