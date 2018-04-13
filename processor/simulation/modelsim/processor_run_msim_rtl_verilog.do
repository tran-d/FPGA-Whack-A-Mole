transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/multdiv {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/multdiv/cla8.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/multdiv {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/multdiv/adder32.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/multdiv {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/multdiv/alu.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/multdiv {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/multdiv/multctrl.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/multdiv {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/multdiv/divctrl.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/multdiv {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/multdiv/multdiv.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/skeleton_ta.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/stage_write.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/stage_memory.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/stage_fetch.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/stage_execute.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/stage_decode.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/signextender_16to32.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/selectors.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/registers.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/regfile.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/processor.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/latches.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/imem.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/dmem.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/dflipflop_neg.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/dflipflop.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/decoder5to32.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/decoder3to8.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/ALU_operations.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/alu.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/adders.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/adder32.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/bypass.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/bypass_stall.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/multdiv_controller.v}

vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/processor_tb_auto.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  processor_tb_auto

add wave *
view structure
view signals
run -all
