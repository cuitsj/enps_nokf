module enps(
	input                       clk,            //系统时钟
	input                       rst_n,          //复位信号，低电平有效
	input                       enps_en,     //滤波器使能信号，高电平有效
	input [15:0]    IR0,  //
    input [15:0]    IR1,  //
    input [15:0]    IR2,  //
    input [15:0]    IR5,  //
    input [15:0]    IR6,  //
    input [15:0]    IR7,  //
    input           launch_flag,
    
    output reg signed [15:0]         leftspeed,
    output reg signed [15:0]         rightspeed,
	output reg                  enps_done   //一次滤波完成后置1
);

reg e_1_1;    //膜1的酶变量
reg e_1_2;
reg f;  //变量
reg m11_done;//膜1第一个值生成函数执行完毕标志
reg m12_done;
reg m21_done;
reg m22_done;

reg signed [15:0] leftspeed_m1;
reg signed [15:0] leftspeed_m2;

reg signed [15:0] rightspeed_m1;
reg signed [15:0] rightspeed_m2;

reg enps_flag;
reg [15:0] IR0_BUFF;
reg [15:0] IR1_BUFF;
reg [15:0] IR2_BUFF;
reg [15:0] IR5_BUFF;
reg [15:0] IR6_BUFF;
reg [15:0] IR7_BUFF;

//打一拍，缓存数据
always @(posedge clk) begin
    if (!rst_n||!launch_flag) begin
        enps_flag <= 0;
        IR0_BUFF <= 0;
        IR1_BUFF <= 0;
        IR2_BUFF <= 0;
        IR5_BUFF <= 0;
        IR6_BUFF <= 0;
        IR7_BUFF <= 0;
        enps_done <= 1'b0;
    end
    else if (enps_en) begin
        enps_flag <= 1;
        IR0_BUFF <= IR0;
        IR1_BUFF <= IR1;
        IR2_BUFF <= IR2;
        IR5_BUFF <= IR5;
        IR6_BUFF <= IR6;
        IR7_BUFF <= IR7;
        enps_done <= 0;
    end
    else if (m11_done == 1 && m12_done == 1 && m21_done == 1 && m22_done == 1) begin//ENPS完成
        enps_flag <= 0;
        IR0_BUFF <= 0;
        IR1_BUFF <= 0;
        IR2_BUFF <= 0;
        IR5_BUFF <= 0;
        IR6_BUFF <= 0;
        IR7_BUFF <= 0;
        enps_done <= 1;
    end
    else begin  //ENPS过程中
        enps_flag <= enps_flag;
        IR0_BUFF <= IR0_BUFF;
        IR1_BUFF <= IR1_BUFF;
        IR2_BUFF <= IR2_BUFF;
        IR5_BUFF <= IR5_BUFF;
        IR6_BUFF <= IR6_BUFF;
        IR7_BUFF <= IR7_BUFF;
        enps_done <= 0;
    end 
end

/**********************膜1********************************/
//生成分规则1
always @(posedge clk) begin
    if(!rst_n||!launch_flag) begin
        leftspeed_m1    <= 16'd0;
        e_1_1 <= 1;
        f <= 0;
        m11_done <=0;
    end
    else if (enps_flag) begin
        if ((e_1_1 > f || e_1_1 > leftspeed)&&m11_done == 0)begin
            leftspeed_m1 <= f+16'd550+0*leftspeed;
            m11_done <=1;
        end
        else if (m11_done == 1 && m12_done == 1 && m21_done == 1 && m22_done == 1) begin//等所有膜中的规则执行完
            m11_done <= 0;
            leftspeed_m1 <= 0; //执行完成，准备下一轮计算
        end
        else begin //等待期间保持
            leftspeed_m1 <= leftspeed_m1;
            m11_done <= m11_done;
        end
    end
end
//生成分配规则2
always @(posedge clk) begin
    if(!rst_n||!launch_flag) begin
        rightspeed_m1    <= 16'd0;
        m12_done <=0;
    end
    else if (enps_flag) begin
        if ((e_1_1 > f || e_1_1 > rightspeed)&&m12_done == 0)begin
            rightspeed_m1 <= f+16'd550+0*rightspeed;
            m12_done <=1;
        end
        else if (m11_done == 1 && m12_done == 1 && m21_done == 1 && m22_done == 1) begin
            m12_done <= 0;
            rightspeed_m1 <= 0;
        end
        else begin
            rightspeed_m1 <= rightspeed_m1;
            m12_done <= m12_done;
        end
    end
end

/*********************************************************/


/**********************膜2********************************/
//生成分配规则1
always @(posedge clk) begin
    if(!rst_n||!launch_flag) begin
        leftspeed_m2    <= 16'd0;
        e_1_2 <= 1;
        m21_done <=0;
    end
    else if (enps_flag) begin
        if ((e_1_2 > f || e_1_2 > IR0_BUFF || e_1_2 > IR1_BUFF || e_1_2 > IR6_BUFF || e_1_2 > IR7_BUFF)&&m21_done == 0)begin
            leftspeed_m2 <= f+IR0_BUFF*16'd8+IR1_BUFF*16'd4+IR2_BUFF*16'd2;
            m21_done <=1;
        end
        else if (m11_done == 1 && m12_done == 1 && m21_done == 1 && m22_done == 1) begin
            m21_done <= 0;
            leftspeed_m2 <= 0;
        end
        else begin
            leftspeed_m2 <= leftspeed_m2;
            m21_done <= m21_done;
        end
    end
end

//生成分配规则2
always @(posedge clk) begin
    if(!rst_n||!launch_flag) begin
        rightspeed_m2    <= 16'd0;
        m22_done <=0;
    end
    else if (enps_flag) begin
        if ((e_1_2 > f || e_1_2 > IR0_BUFF || e_1_2 > IR1_BUFF || e_1_2 > IR6_BUFF || e_1_2 > IR7_BUFF)&&m22_done == 0)begin
            rightspeed_m2 <= f+IR7_BUFF*16'd8+IR6_BUFF*16'd4+IR5_BUFF*16'd2;
            m22_done <=1;
        end
        else if (m11_done == 1 && m12_done == 1 && m21_done == 1 && m22_done == 1) begin
            m22_done <= 0;
            rightspeed_m2 <= 0;
        end
        else begin
            rightspeed_m2 <= rightspeed_m2;
            m22_done <= m22_done;
        end
    end
end

/*********************************************************/

/**********************输出********************************/

always @(posedge clk) begin
    if(!rst_n||!launch_flag) begin
        leftspeed <= 16'd0;
        rightspeed <= 0;
    end
    else if (enps_flag) begin
        if (m11_done == 1 && m12_done == 1 && m21_done == 1 && m22_done == 1)begin
            leftspeed <= leftspeed_m1-leftspeed_m2;
            rightspeed <= rightspeed_m1-rightspeed_m2;
        end
        else begin
            leftspeed <= 0;
            rightspeed <= 0;
        end
    end
    else begin
        leftspeed <= 0;
        rightspeed <= 0;
    end
end

endmodule
