//~ `New testbench
`timescale  1ns / 1ns

module tb_enps;

// enps Parameters
parameter PERIOD  = 10;


// enps Inputs
reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;
reg   enps_en                              = 0 ;
reg   [7:0]  IR0                           = 0 ;
reg   [7:0]  IR1                           = 0 ;
reg   [7:0]  IR6                           = 0 ;
reg   [7:0]  IR7                           = 0 ;

// enps Outputs
wire  [15:0]  leftspeed                    ;
wire  [15:0]  rightspeed                   ;
wire  enps_done                            ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

enps  u_enps (
    .clk                     ( clk                ),
    .rst_n                   ( rst_n              ),
    .enps_en                 ( enps_en            ),
    .IR0                     ( IR0         [7:0]  ),
    .IR1                     ( IR1         [7:0]  ),
    .IR6                     ( IR6         [7:0]  ),
    .IR7                     ( IR7         [7:0]  ),

    .leftspeed               ( leftspeed   [15:0] ),
    .rightspeed              ( rightspeed  [15:0] ),
    .enps_done               ( enps_done          )
);

initial
begin
	#(PERIOD*5) enps_en=1;
		IR0 = 8'h50;
		IR1 = 8'h32;
		IR6 = 8'h00;
		IR7 = 8'h1E;
	#(PERIOD*1)enps_en=0;
		IR0 = 8'h00;
		IR1 = 8'h00;
		IR6 = 8'h00;
		IR7 = 8'h00;
    $stop;
end

endmodule
