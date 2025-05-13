.data
rowDelta:   .byte 0, 1, 1, 1

colDelta:   .byte 1, 0, 1, -1

.text
.globl win_position

# Inputs:
# $a0: board base address
# $a1: row
# $a2: col
# $a3: player value
# Output:
# $v0: 1 if win, 0 if not

win_position:
    move $s0, $a0      # board base address
    move $s1, $a1      # row
    move $s2, $a2      # col
    move $s3, $a3      # player

    li $t8, 0          # direction index = 0

direction_loop:
    li $t9, 4
    beq $t8, $t9, not_winning  # if all directions tried, no win

    # Load rowDelta and colDelta from table
    la $t0, rowDelta
    add $t0, $t0, $t8
    lb $s5, 0($t0)   # $s5 = rowDelta[dir]

    la $t1, colDelta
    add $t1, $t1, $t8
    lb $s6, 0($t1)   # $s6 = colDelta[dir]

    li $t6, 15       # Prepare 15 for bounds check

    move $t0, $s5    # Now $t0 = rowDelta
    move $t1, $s6    # Now $t1 = colDelta

    li $s4, 1           # count = 1 (count the current position)

# --------- Forward scan ---------
    add $t2, $s1, $t0   # r = row + rowDelta
    add $t3, $s2, $t1   # c = col + colDelta

forward_loop:
    # bounds check r and c
    bltz $t2, backward_setup
    li $t6, 15
    bge $t2, $t6, backward_setup
    bltz $t3, backward_setup
    li $t6, 15
    bge $t3, $t6, backward_setup

    # calculate board[r][c]
    li $t4, 15
    mul $t5, $t2, $t4    # row * 15
    add $t5, $t5, $t3    # + col
    add $t5, $s0, $t5    # + base address

    lb $t7, 0($t5)       # board[r][c]

    # check if match player value
    bne $t7, $s3, backward_setup

    # If match then increase the counter
    addi $s4, $s4, 1
    add $t2, $t2, $t0
    add $t3, $t3, $t1
    j forward_loop

# --------- Backward scan ---------
backward_setup:
    sub $t2, $s1, $t0   # r = row - rowDelta
    sub $t3, $s2, $t1   # c = col - colDelta

backward_loop:
    bltz $t2, check_count
    li $t6, 15
    bge $t2, $t6, check_count
    bltz $t3, check_count
    li $t6, 15
    bge $t3, $t6, check_count

    li $t4, 15
    mul $t5, $t2, $t4
    add $t5, $t5, $t3
    add $t5, $s0, $t5

    lb $t7, 0($t5)

    bne $t7, $s3, check_count

    addi $s4, $s4, 1
    sub $t2, $t2, $t0
    sub $t3, $t3, $t1
    j backward_loop

# --------- Check result ---------
check_count:
    li $t9, 5
    bge $s4, $t9, winning

    addi $t8, $t8, 1     # direction++
    j direction_loop

winning:
    li $v1, 1
    jr $ra

not_winning:
    li $v1, 0
    jr $ra
