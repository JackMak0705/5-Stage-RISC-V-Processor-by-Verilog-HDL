module mem (
    input wire reset,

    input wire [31:0] pc_next_i,
    input wire [31:0] alu_i,
    input wire [31:0] data_i,
    input wire [ 4:0] wbaddr_i,

    input wire [31:0] instr_i,  

    output wire [31:0] data_mem_o,
    output wire [31:0] data_back_o,
    output wire [31:0] data_o,
    output wire [31:0] pc_next_o,
    output wire [ 4:0] wbaddr_o,
    output wire [31:0] instr_o
);

    wire [6:0] opcode;
    wire [2:0] funct3;

    assign opcode  =  instr_i[6:0];
    assign funct3  =  instr_i[14:12];

    wire RW;

    assign RW = (opcode == `INST_TYPE_S) ? 1'b1 : 1'b0;

    reg [31:0] data_mem_i;

    always @(*) begin
        if(reset) begin
            data_mem_i = 32'h00000000;
        end else begin
            case (funct3)
                `INST_SB: begin
                    data_mem_i = {24'b0,data_i[7:0]};
                end
                `INST_SH: begin
                    data_mem_i = {16'b0,data_i[15:0]};
                end
                `INST_SW: begin
                    data_mem_i = data_i;
                end
                default: begin
                    data_mem_i = 32'h00000000;
                end
            endcase
        end

    end

    data_mem data_mem_inst (
        .RW         (   RW     ),
        .reset      (   reset  ),
        
        .addr       (   alu_i  ),
        .data_i     (data_mem_i),

        .data_o     (data_mem_o)
    );

    assign data_back_o = alu_i;
    assign data_o      = alu_i;
    assign pc_next_o   = pc_next_i;
    assign wbaddr_o    = wbaddr_i;
    assign instr_o     = instr_i;

endmodule