transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/dhruv/ECE350/final-project-s18-trusttheprocessor-1/capacitive_sensor {/home/dhruv/ECE350/final-project-s18-trusttheprocessor-1/capacitive_sensor/capacitive_sensor.v}

