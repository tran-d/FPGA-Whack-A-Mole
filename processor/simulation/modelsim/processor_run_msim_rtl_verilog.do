transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d/skeleton_ta.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d/stage_write.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d/stage_memory.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d/stage_fetch.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d/stage_execute.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d/stage_decode.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d/signextender_16to32.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d/selectors.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d/registers.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d/regfile.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d/processor.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d/latches.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d/imem.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d/dmem.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d/dflipflop_neg.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d/dflipflop.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d/decoder5to32.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d/decoder3to8.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d/ALU_operations.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d/alu.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d/adders.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d/adder32.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d/bypass.v}
vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d/bypass_stall.v}

vlog -vlog01compat -work work +incdir+C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d {C:/Users/David/Documents/final-project-s18-trusttheprocessor-1/processor/pc4-tran-d/processor_tb_auto.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  processor_tb_auto

add wave *
view structure
view signals
run -all
