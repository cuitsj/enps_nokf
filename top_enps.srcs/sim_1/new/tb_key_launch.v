`timescale  1ns / 1ns

module tb_key_launch;

// key_launch Parameters
parameter PERIOD  = 10;


// key_launch Inputs
reg   clk                                  = 0 ;
reg   rst                                  = 0 ;
reg   key                                  = 0 ;

// key_launch Outputs
wire  launch_flag                          ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst  =  1;
end

key_launch  u_key_launch (
    .clk                     ( clk           ),
    .rst                     ( rst           ),
    .key                     ( key           ),

    .launch_flag             ( launch_flag   )
);

initial
begin
	#(PERIOD*5) key  =  1;
	#(PERIOD*3) key  =  0;

	#(PERIOD*10) key  =  1;
	#(PERIOD*3) key  =  0;

	#(PERIOD*10);
    $stop;
end

endmodule
