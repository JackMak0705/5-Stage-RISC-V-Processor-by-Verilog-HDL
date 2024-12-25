module pcreg (
    input  wire        clk,
    input  wire        reset,
    //input  wire        enable,//可拓展为使能信号
    //input  wire [31:0] pc_in,
    input  wire [31:0] pc_jump,//跳转地址
    input  wire        pc_jump_en,//跳转使能
    
    output reg  [31:0] pc_out
);

    always @(posedge clk) begin
        if(reset)           pc_out <= 0;
        //else if(pc_jump_en) pc_out <= pc_jump;
        else                pc_out <= pc_out + 4;
    end

    always @(*) begin
        if(pc_jump_en) pc_out <= pc_jump;
    end
    
endmodule