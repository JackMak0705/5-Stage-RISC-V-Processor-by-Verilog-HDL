module wb (
    input wire reset,

    input wire [31:0] data_men_i,
    input wire [31:0] data_i,
    input wire [31:0] pc_next_i,
    input wire [ 4:0] wbaddr_i,
    input wire [31:0] instr_i,

    output reg [31:0] wbdata_o,
    output reg [ 4:0] wbaddr_o,
    output reg wb_en

);

    wire [6:0] opcode;

    assign opcode  =  instr_i[6:0];

    //assign wbdata_o = (opcode == `INST_TYPE_L) ? data_men_i :
    //                  (((opcode == `INST_LUI )|| (opcode == `INST_AUIPC)) ? pc_next_i : data_i);
    //assign wbaddr_o = wbaddr_i;
    //assign wb_en = ((opcode == `INST_TYPE_I)||(opcode == `INST_TYPE_R_M)||
    //              (opcode == `INST_TYPE_L)||(opcode == `INST_JAL)||
    //              (opcode == `INST_JALR)||(opcode == `INST_LUI)||
    //              (opcode == `INST_AUIPC)) ? 1'b1 : 1'b0;

    always @ (*) begin
        if (reset) begin
            wbdata_o <= 0;
            wbaddr_o <= 0;
            wb_en    <= 0;
        end
        else begin
            wbdata_o <= (opcode == `INST_TYPE_L) ? data_men_i :
                      (((opcode == `INST_JAL )|| (opcode == `INST_JALR)) ? pc_next_i : data_i);
            wbaddr_o <= wbaddr_i;
            wb_en    <= ((opcode == `INST_TYPE_I)||(opcode == `INST_TYPE_R_M)||
                          (opcode == `INST_TYPE_L)||(opcode == `INST_JAL)||
                          (opcode == `INST_JALR)||(opcode == `INST_LUI)||
                          (opcode == `INST_AUIPC)) ? 1'b1 : 1'b0;
        end
    end

endmodule