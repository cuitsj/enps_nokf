`timescale  1ns / 1ns   

module tb_rx_process;   

// rx_process Parameters
parameter PERIOD  = 10; 


// rx_process Inputs    
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   rxprocess_en                         = 0 ;
reg   [7:0]  uart_data                     = 0 ;

// rx_process Outputs
wire  [7:0]  IR0                           ;
wire  [7:0]  IR1                           ;
wire  [7:0]  IR6                           ;
wire  [7:0]  IR7                           ;
wire  rxprocess_done                       ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

rx_process  u_rx_process (
    .clk                     ( clk                   ),
    .rst_n                   ( rst_n                 ),
    .rxprocess_en            ( rxprocess_en          ),
    .uart_data               ( uart_data       [7:0] ),

    .IR0                     ( IR0             [7:0] ),
    .IR1                     ( IR1             [7:0] ),
    .IR6                     ( IR6             [7:0] ),
    .IR7                     ( IR7             [7:0] ),
    .rxprocess_done          ( rxprocess_done        )
);

initial
begin
	#(PERIOD*50) 	rxprocess_en = 1;
			uart_data = 8'hFF;
	#(PERIOD*1) 	rxprocess_en = 0;
			uart_data = 8'h00;
	#(PERIOD*50) 	rxprocess_en = 1;
			uart_data = 8'h50;
	#(PERIOD*1) 	rxprocess_en = 0;
			uart_data = 8'h00;
	#(PERIOD*50) 	rxprocess_en = 1;
			uart_data = 8'h32;
	#(PERIOD*1) 	rxprocess_en = 0;
			uart_data = 8'h00;
	#(PERIOD*50) 	rxprocess_en = 1;
			uart_data = 8'h00;
	#(PERIOD*1) rxprocess_en = 0;
			uart_data = 8'h00;
	#(PERIOD*50) 	rxprocess_en = 1;
			uart_data = 8'h1E;
	#(PERIOD*1) rxprocess_en = 0;
			uart_data = 8'h00;
    $stop;
end

endmodule
