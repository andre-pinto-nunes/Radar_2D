vlib work

vcom -93 TELEM_MES.vhd
vcom -93 TELEM_MES_tb.vhd

vsim -novopt TELEM_MES_tb(testbench)

view signals

add wave -position end -radix unsigned sim:/telem_mes_tb/echo
add wave -position end -radix unsigned sim:/telem_mes_tb/dist
add wave -position end -radix unsigned sim:/telem_mes_tb/uut/temp
add wave -position end -radix unsigned sim:/telem_mes_tb/uut/cpt

run -all