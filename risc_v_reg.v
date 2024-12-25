module risc_v_reg(
    input wire reset,

    input wire [ 4:0] r1_addr,
    input wire [ 4:0] r2_addr,
    input wire [ 4:0] w_addr,
    input wire [31:0] w_data,

    output reg [31:0] r1_data,
    output reg [31:0] r2_data,

    input wire w_en
);
    reg [31:0] regs [0:31];
    //integer i;

    initial begin
        $readmemh("risc_v_data.txt", regs);
    end

    always @ (*) begin
        //保证仿真
        /*if (reset) begin
            for(i=0; i<32; i=i+1) begin
                regs[i] <= 0;
            end
        end*/
        if (w_en && w_addr!= 0) begin//强制不能写X0
            regs[w_addr] <= w_data;
        end 
        if (w_en && w_addr == r1_addr) begin
            r1_data <= w_data;
            r2_data <= regs[r2_addr];
        end 
        else if (w_en && w_addr == r2_addr) begin
            r1_data <= regs[r1_addr];
            r2_data <= w_data;
        end 
        else begin
            r1_data <= regs[r1_addr];//存在数据冒险，r1_addr变化后读不出数据
            r2_data <= regs[r2_addr];
        end
    end
endmodule