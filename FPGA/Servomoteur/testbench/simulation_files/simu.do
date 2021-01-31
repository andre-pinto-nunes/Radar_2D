vlib work

vcom -93 Servomoteur.vhd
vcom -93 Servomoteur_tb.vhd

vsim -novopt Servomoteur_TEST(test_bench)

view signals

add wave -position end -radix unsigned sim:/servomoteur_test/rst
add wave -position end -radix unsigned sim:/servomoteur_test/clk
add wave -position end -radix unsigned sim:/servomoteur_test/position
add wave -position end -radix unsigned sim:/servomoteur_test/servomoteur/cpt
add wave -position end -radix unsigned sim:/servomoteur_test/servomoteur/commande

run -all