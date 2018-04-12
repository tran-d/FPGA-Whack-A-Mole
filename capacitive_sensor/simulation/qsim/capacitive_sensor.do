onerror {exit -code 1}
vlib work
vlog -work work capacitive_sensor.vo
vlog -work work capacitive_sensor_array.vwf.vt
vsim -novopt -c -t 1ps -L cycloneive_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate_ver -L altera_lnsim_ver work.capacitive_sensor_array_vlg_vec_tst -voptargs="+acc"
vcd file -direction capacitive_sensor.msim.vcd
vcd add -internal capacitive_sensor_array_vlg_vec_tst/*
vcd add -internal capacitive_sensor_array_vlg_vec_tst/i1/*
run -all
quit -f
