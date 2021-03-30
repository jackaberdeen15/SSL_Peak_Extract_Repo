onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib div_gen_1_opt

do {wave.do}

view wave
view structure
view signals

do {div_gen_1.udo}

run -all

quit -force
