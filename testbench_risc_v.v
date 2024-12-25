`include "defines.v"

module testbench_risc_v;

reg clkstim, rststim;

top_risc_v top_risc_v_inst(
   .clk                 (        clkstim        ),
   .rst                 (        rststim        )
);

always #5 clkstim = ~clkstim;

initial begin
    #0 rststim = 1'b1; 
    #5 clkstim = 1'b0;
    #10 rststim = 1'b0;
    #10000 $stop;
end


endmodule