# if sensor touched
# $t0 holds threshold value of current index
# 0-44: moles {index, state, time_elapsed, time_limit_on, time_limit_off}

# init time off and on

addi $t9, $r0, 8

while: nop

beq $t1, $t9 1 
addi $t1, $t1, 1					# current mole index
j next
addi $t1, $r0, 0

next: nop
lw $t7, 2($t1)						# time_elasped += 1
addi $t7, $t7, 1
sw $t7, 2($t1)

blt 3000, $t0, 1					# 3000 < sensor_value
j not_touched
j touched

not_touched: nop
lw $t2, 2($t1) 						# $t2 = time_elasped 
lw $t3, 3($t1) 						# $t3 = time_limit_on
blt $t3, $t2, 1						# time_limit_on < time_elasped

j check_time_off
j check_active


check_time_off: nop
lw $t2, 2($t1) 						# $t2 = time_elasped 
lw $t3, 4($t1) 						# $t3 = time_limit_off
blt $t3, $t2, 1						# time_limit_off < time_elasped
j while
j check_not_active

check_not_active: nop
addi $t5, $r0, 0					# $t5 = 0
lw $t4, 1($t1) 						# $t4 = mole.state 
beq $t4, $t5, 1
j while								# continue
j set_led_on

check_active: nop
addi $t5, $r0, 1					# $t5 = 1
lw $t4, 1($t1) 						# $t4 = mole.state 
beq $t4, $t5, 1
j while								# continue
j set_led_off


set_led_on: nop



set_led_off: nop
led $t1, 65535
addi $t6, $r0, 100000000
sw $t6, 2($t1)
						mole.time_limit_off = random_time()
						mole.time_elapsed = 0


touched: nop
bne $r0

