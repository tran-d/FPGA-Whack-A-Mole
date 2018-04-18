#  David Tran [dht9]
# ECE 250 HW2, Problem 6
	.text

main:
	li $s0,0            	# list_head = NULL

loop:
	#prompt for NAME
	la $a0, PROMPT_NAME
	jal print_string

	# read in NAME from user
	jal read_string

	#save string ptr
	move $s1, $v0			# could use la $s1, 0($v0)

	# delete newline
	move $a0, $s1			# $a0 has malloc'd memory address (NAME)
	jal del_newline

	move $a0, $s1			# print name (check)
	#jal print_string

	la $a1, str_DONE 		# check for DONE
	jal strcmp
	beqz $v0, print_list

	# ask for NUMBER
	la $a0, PROMPT_NUMBER	# ask
	li $v0, 4
	syscall
	jal read_int

	#store number
	la $t2, 0($v0)
	# jal print_int

	# ask for NUMBER
	la $a0, PROMPT_YEAR		# ask
	li $v0, 4
	syscall
	jal read_int

	#store number
	la $t3, 0($v0)

	jal insert				# insert into node in linked list
	j loop

read_string:
	addi    $sp,$sp,-8
    sw      $ra,0($sp)
    sw      $s0,4($sp)

    lw $a1, MAX_NAME_LEN

    move $a0, $a1			# $a0 gets MAX_NAME_LEN
    jal malloc
    move $a0, $v0			# $a0 points to malloc'd memory

    lw $a1, MAX_NAME_LEN
    jal get_string			# store NAME into $a0 --> malloc'd memory

    move $v0, $a0			# $v0 points to malloc'd memory (NAME)

    lw      $s0,4($sp)		# restore the frame ($v0 is returned)
    lw      $ra,0($sp)
    addi    $sp,$sp,8
    jr      $ra

read_int:
	addi    $sp,$sp,-4
    sw      $ra,0($sp)
	li $a1, 4				# 4 bytes max length
	move $a0, $a1
	jal malloc				# malloc space for NUMBER
	move $a0, $v0			# $a0 points to NUMBER memory
	li      $v0,5			# read NUMBER
    syscall
    sw $v0, 0($a0)
    move $a0, $v0
    lw      $ra,0($sp)		# restore frame
    addi    $sp,$sp,4
    jr      $ra

strcmp:
    lb      $t0,0($a0)              # get byte of first char in string s
    lb      $t1,0($a1)              # get byte of first char in string t

    sub     $v0,$t0,$t1             # compare them
    bnez    $v0,strcmp_done         # mismatch? if yes, fly

    addi    $a0,$a0,1               # advance s pointer
    addi    $a1,$a1,1               # advance t pointer

    bnez    $t0,strcmp              # at EOS? no=loop, otherwise v0 == 0

strcmp_done:
    jr      $ra                     # return

numcmp:
	move $t0, $a0
	move $t1, $a1
	sub $v0, $t0, $t1
	jr $ra
check_last:
	lw $a0, 0($s2)				# $a0 gets year/memory address from $s2
	lw $a1, 0($s4)				# $a1 gets year/memory address from $s4
	jal strcmp
	bltz $v0, insert_curr		# if new->NAME < curr->NAME, insert HERE
	j insert_loop2
get_string:
    li      $v0,8
    syscall
    jr      $ra

malloc:
	li $v0, 9
	syscall
	jr $ra


insert:
	addi    $sp, $sp,-4			# stack frame
    sw      $ra, 0($sp)

    li      $a0, 44           	# 44 = node size
    jal     malloc				# malloc memory for node
    move    $s2,$v0  			# store memory address in $s2

    sw      $s1,0($s2)       	# new->node_str = strptr (byte 0)
    sw 		$t2,32($s2)
    sw      $zero,40($s2)    	# new->node_next = NULL (byte 40)
    sw 		$t3,36($s2)

    li      $s3,0               # $s3 = prev = NULL
    move    $s4,$s0             # $s4 = cur = list_head
    j       insert_empty_list

insert_loop:
	lw $a0, 36($s2)				# $a0 gets year/memory address from $s2
	lw $a1, 36($s4)				# $a1 gets year/memory address from $s4
	jal numcmp 					# $v0 < 0 if new<curr
	bltz $v0, insert_curr		# if new->YEAR < curr->YEAR, insert HERE
	
	#IF $v0 = 0, CHECK LAST NAMES
	beqz $v0, check_last
insert_loop2:
	move $s3, $s4				# PREV = CURR
	lw $s4, 40($s4)				# CURR = CURR->NEXT (load next node address)

insert_empty_list:
	bnez $s4, insert_loop		# go to loop if CURR is NOT NULL

insert_curr:
	sw $s4, 40($s2)				# $s2 has NEXT field pointing to $s4 (CURR)
	beqz $s3, insert_head		# check if $s3 (PREV) is NULL
	sw $s2, 40($s3)				# $s3 (PREV) points to $s2
	j insert_done
insert_head:
	move $s0, $s2				# $s2 is now the head
insert_done:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

del_newline:
	li $t0,0x0A 			# $t0 contains newline ASCII value

del_newline_loop:
	lb $t1, 0($a0)			# load next byte into $t1
	beq $t1, $t0, replace_newline
	beqz $t1, del_newline_done
	addi $a0, $a0, 1		# $a0 points to next byte
	j del_newline_loop

replace_newline:
	sb $zero, 0($a0)		# replace newline with null character
del_newline_done:	
	jr $ra

print_string:
	li $v0, 4
	syscall
	jr $ra
print_integer:
	li $v0, 1
	syscall
	jr $ra
print_list:
	move $a0, $s0
	# addi $sp, $sp, 8
	# sw $ra, 0($sp)
	# sw $s0, 4($sp)

	beq $s0, $zero, main_exit

print_loop:
	lw $a0, 0($s0)			# print NAME
	jal print_string
	jal print_space
	lw $a0 32($s0)			# print NUMBER
	jal print_integer
	jal print_nln
	# lw $a0, 36($s0)
	# jal print_integer
	# jal print_nln
	lw $s0, 40($s0)
	bnez $s0, print_loop
print_exit:
	# lw $ra, 0($sp)
	# lw $s0, 4($sp)
	# addi $sp, $sp, 8
	# jr $ra
# print_done_reached:
# 	la $a0, done_reached
# 	li $v0, 4
# 	syscall
# 	move $a0, $s0
# 	jal print_list
main_exit:
	# la $a0, exit 			# print "exit"
	# li $v0, 4
	# syscall
	li      $v0,10
    syscall
print_nln:
	la $a0, nln
	li $v0, 4
	syscall
	jr $ra
print_space:
	la $a0, space
	li $v0, 4
	syscall
	jr $ra
print_int:
	move $a0, $t2
	li $v0, 1
	syscall
	jr $ra

	.data
MAX_NAME_LEN:    .word   32
STR_NEWLINE:    .asciiz "\n"
PROMPT_NAME:
		.asciiz "Please enter a name:\n"
PROMPT_NUMBER:
		.asciiz "Please enter a number:\n"
PROMPT_YEAR:
		.asciiz "Please enter a year:\n"
str_DONE:
		.asciiz "DONE"
done_reached:
		.asciiz "DONE has been reached\n"
done_not_reached:
		.asciiz "DONE has NOT been reached\n"
input_name:
		.space 32
input_number:
		.space 4
input_year:
		.space 4
nln:
	.asciiz "\n"
tab:
	.asciiz "\t"
space:
	.asciiz " "
exit:
	.asciiz "exit\n"