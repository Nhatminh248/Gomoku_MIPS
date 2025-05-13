.data
input_buffer:   .space 10
newline:		.asciiz "\n"
.text
.globl read_input

# Inputs: (Handle internally by the function)
# 

# Outputs:
# $v0: flag result (0 for success, 1 for invalid char)
# $s0: the x coordinate
# $s1: the y coordinate

read_input:
    # Step 1: Read string from user
    li $v0, 8              # syscall for reading a string
    la $a0, input_buffer         # address of buffer
    li $a1, 10            # max number of characters
    syscall                # read the string into buffer

    # Step 2: Print the string back to check
    # li $v0, 4              # syscall for printing a string
    # la $a0, input_buffer         # address of buffer
    # syscall                # print the string
    
    # Start the parsing input
    la $a0, input_buffer

    read_coordinates:
	la $t0, input_buffer   # pointer to current char
	li $t1, 0              # final result = 0

    loop:
	lb $t2, 0($t0)		# load the first char to $t2
	
	li $t4, 44  # ASCII code for ','
	beq $t2, $t4, parse_y  # jump to parse y when you hit comma
	
	# Check if input is out of range (>9 or <0)
	blt $t2, 48, invalid_input
	bgt $t2, 57, invalid_input
	
	li $t3, 48          # ASCII of char '0'
	sub $t2, $t2, $t3   # $t2 now holds the actual digit
	
	li $t3, 10
	mul $t1, $t1, $t3   # result *= 10
	add $t1, $t1, $t2   # result += digit
	
	addi $t0, $t0, 1
	j loop
	
    parse_y:
	addi $t0, $t0, 1
	li $t5, 0
	loop_y:
	lb $t2, 0($t0)
	beqz $t2, done_parsing         # NULL terminator
	li $t4, 10
	beq $t2, $t4, done_parsing     # newline

	blt $t2, 48, invalid_input
	bgt $t2, 57, invalid_input
	
	li $t3, 48
	sub $t2, $t2, $t3
	li $t3, 10
	mul $t5, $t5, $t3
	add $t5, $t5, $t2
	
	addi $t0, $t0, 1
	j loop_y
	
    done_parsing:
    move $s0, $t1    # Store x1
    move $s1, $t5    # Store y1
    
    li $v0, 0
    jr $ra

invalid_input:
	li $v0, 1
    jr $ra 
