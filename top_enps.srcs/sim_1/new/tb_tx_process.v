`timescale  1ns / 1ns

module tb_tx_process;

// tx_process Parameters
parameter PERIOD  = 10;


// tx_process Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   txprocess_en                         = 0 ;
reg   tx_done                              = 0 ;
reg   [15:0]  leftspeed                    = 0 ;
reg   [15:0]  rightspeed                   = 0 ;

// tx_process Outputs
wire  [7:0]  tx_data                       ;
wire  tx_flag                              ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

tx_process  u_tx_process (
    .clk                     ( clk                  ),
    .rst_n                   ( rst_n                ),
    .txprocess_en            ( txprocess_en         ),
    .tx_done                 ( tx_done              ),
    .leftspeed               ( leftspeed     [15:0] ),
    .rightspeed              ( rightspeed    [15:0] ),

    .tx_data                 ( tx_data       [7:0]  ),
    .tx_flag                 ( tx_flag              )
);

initial
begin
	//接收到数据
	#(PERIOD*3) txprocess_en = 1;
			tx_done = 1;
	leftspeed = 16'hFF38;
	rightspeed = 16'h04B0;
	#(PERIOD*1) txprocess_en = 0;
	leftspeed = 16'h0000;
	rightspeed = 16'h0000;
	#(PERIOD*1) tx_done = 0;


	//发完第一个8位数
	#(PERIOD*10) txprocess_en = 0;
			tx_done = 1;
	leftspeed = 16'h0000;
	rightspeed = 16'h0000;
	#(PERIOD*2) tx_done = 0;

	//发完第二个8位数
	#(PERIOD*10) txprocess_en = 0;
			tx_done = 1;
	leftspeed = 16'h0000;
	rightspeed = 16'h0000;
	#(PERIOD*2) tx_done = 0;

	//发完第三个8位数
	#(PERIOD*10) txprocess_en = 0;
			tx_done = 1;
	leftspeed = 16'h0000;
	rightspeed = 16'h0000;
	#(PERIOD*2) tx_done = 0;

	//发完第四个8位数
	#(PERIOD*10) txprocess_en = 0;
			tx_done = 1;
	leftspeed = 16'h0000;
	rightspeed = 16'h0000;
	#(PERIOD*2) tx_done = 0;

	//没有数据发
	#(PERIOD*10) txprocess_en = 0;
			tx_done = 1;
	leftspeed = 16'h0000;
	rightspeed = 16'h0000;
	#(PERIOD*2) tx_done = 1;

	//有数据发
	#(PERIOD*3) txprocess_en = 1;
			tx_done = 1;
	leftspeed = 16'hABCD;
	rightspeed = 16'hEF12;
	#(PERIOD*1) txprocess_en = 0;
	leftspeed = 16'h0000;
	rightspeed = 16'h0000;
	#(PERIOD*1) tx_done = 0;

	#(PERIOD*10) txprocess_en = 0;
			tx_done = 1;
	leftspeed = 16'h0000;
	rightspeed = 16'h0000;
	#(PERIOD*2) tx_done = 0;
	
    $stop;
end

endmodule
