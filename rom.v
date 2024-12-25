module rom 
#(
    parameter DATAWIDTH = 32,
    parameter ROMDEPTH = 1024
)
(
    input  wire [DATAWIDTH-1:0] addr,
    output reg  [DATAWIDTH-1:0] data
);
    reg [DATAWIDTH-1:0] rom [0:ROMDEPTH-1];

    initial begin
    $readmemh("test_data_input.txt", rom);
    end
    
    always @(*) begin
            data <= rom[addr>>2];//模拟rics-v 8bit*4时的rom 32bit数据
    end

endmodule