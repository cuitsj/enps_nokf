vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/xpm

vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap xpm questa_lib/msim/xpm

vlog -work xil_defaultlib -64 -sv "+incdir+../../../../top_enps.srcs/sources_1/ip/ila_top_enps/hdl/verilog" \
"D:/Xilinx/Vivado/2018.3/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"D:/Xilinx/Vivado/2018.3/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"D:/Xilinx/Vivado/2018.3/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib -64 "+incdir+../../../../top_enps.srcs/sources_1/ip/ila_top_enps/hdl/verilog" \
"../../../../top_enps.srcs/sources_1/ip/ila_top_enps/sim/ila_top_enps.v" \

vlog -work xil_defaultlib \
"glbl.v"

