module enps(
	input                       clk,            //ϵͳʱ��
	input                       rst_n,          //��λ�źţ��͵�ƽ��Ч
	input                       enps_en,     //�˲���ʹ���źţ��ߵ�ƽ��Ч
	input [15:0]    IR0,  //
    input [15:0]    IR1,  //
    input [15:0]    IR2,  //
    input [15:0]    IR5,  //
    input [15:0]    IR6,  //
    input [15:0]    IR7,  //
    input           launch_flag,
    
    output reg signed [15:0]         leftspeed,
    output reg signed [15:0]         rightspeed,
	output reg                  enps_done   //һ���˲���ɺ���1
);

reg e_1_1;    //Ĥ1��ø����
reg e_1_2;
reg f;  //����
reg m11_done;//Ĥ1��һ��ֵ���ɺ���ִ����ϱ�־
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

//��һ�ģ���������
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
    else if (m11_done == 1 && m12_done == 1 && m21_done == 1 && m22_done == 1) begin//ENPS���
        enps_flag <= 0;
        IR0_BUFF <= 0;
        IR1_BUFF <= 0;
        IR2_BUFF <= 0;
        IR5_BUFF <= 0;
        IR6_BUFF <= 0;
        IR7_BUFF <= 0;
        enps_done <= 1;
    end
    else begin  //ENPS������
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

/**********************Ĥ1********************************/
//���ɷֹ���1
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
        else if (m11_done == 1 && m12_done == 1 && m21_done == 1 && m22_done == 1) begin//������Ĥ�еĹ���ִ����
            m11_done <= 0;
            leftspeed_m1 <= 0; //ִ����ɣ�׼����һ�ּ���
        end
        else begin //�ȴ��ڼ䱣��
            leftspeed_m1 <= leftspeed_m1;
            m11_done <= m11_done;
        end
    end
end
//���ɷ������2
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


/**********************Ĥ2********************************/
//���ɷ������1
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

//���ɷ������2
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

/**********************���********************************/

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
