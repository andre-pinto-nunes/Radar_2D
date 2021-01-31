vlib work

vcom -93 TELEM_TRIG.vhd
vcom -93 TELEM_TRIG_tb.vhd

vsim -novopt TELEM_TRIG_tb(testbench)

view signals

add wave -position end -radix unsigned sim:/telem_trig_tb/rst
add wave -position end -radix unsigned sim:/telem_trig_tb/trig
add wave -position end -radix unsigned sim:/telem_trig_tb/uut/cpt_trig
add wave -position end -radix unsigned sim:/telem_trig_tb/uut/cpt_120ms

run -all