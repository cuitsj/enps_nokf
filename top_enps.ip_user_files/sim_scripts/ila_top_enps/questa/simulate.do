onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib ila_top_enps_opt

do {wave.do}

view wave
view structure
view signals

do {ila_top_enps.udo}

run -all

quit -force
