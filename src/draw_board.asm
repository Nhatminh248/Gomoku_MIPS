.data 
col_spacing:  .asciiz "   "        # Initial padding before column numbers
space:        .asciiz " "          # Two spaces for alignment
newline:      .asciiz "\n"
dot_char:     .asciiz " . "         # Cell with dot (empty)
X_char:       .asciiz " X "          # Cell with X
O_char:       .asciiz " O "          # Cell with O

.text
.globl draw_board

# Inputs:
# $a0: board address
# $a1: x coordinate
# $a2: y coordinate
# $a3: player value (-1 for X and 1 of O for the player, 0 for default value)

draw_board:
    # Save board address
    move $s0, $a0        
    move $s1, $a1
    move $s2, $a2
    move $s3, $a3 

# Update board[x][y] 
    li $t0, 15
    mul $t1, $s1, $t0     # x * 15
    add $t1, $t1, $s2     # + y

    add $t2, $s0, $t1     # board base + offset

    sb $s3, 0($t2)        # store player value into board[x][y]

# ========== Print the board with aligned headers ==========

    # Print column spacing before headers
    li $v0, 4
    la $a0, col_spacing
    syscall

    li $t0, 0              # Column index
print_col_headers:
    li $t1, 10
    blt $t0, $t1, col_leading_space
    j col_print_number

col_leading_space:
    li $v0, 4
    la $a0, space
    syscall
    j col_print_number

col_print_number:
    li $v0, 1
    move $a0, $t0
    syscall

    li $v0, 4
    la $a0, space
    syscall

    addi $t0, $t0, 1
    li $t1, 15
    blt $t0, $t1, print_col_headers

    # Newline after column numbers
    li $v0, 4
    la $a0, newline
    syscall

    # Start printing rows
    li $t7, 0              # Row index

# ========== Print the board with aligned headers ==========

print_row_loop:
    # Print row number
    blt $t7, 10, print_row_space
    j print_row_digit

print_row_space:
    li $v0, 4
    la $a0, space
    syscall

print_row_digit:
    li $v0, 1
    move $a0, $t7
    syscall

    li $v0, 4
    la $a0, space
    syscall

    li $t2, 0              # Column index

print_cell_loop:
    # calculate offset: offset = row * 15 + col
    li $t3, 15
    mul $t4, $t7, $t3      # row * 15
    add $t4, $t4, $t2      # + col

    add $t5, $s0, $t4      # board base + offset
    lb $t6, 0($t5)         # load board[row][col] value

    # Print according to value
    beqz $t6, print_dot
    li $t8, 1
    beq $t6, $t8, print_O   # If 1 → O
    j print_X              # Otherwise (expect -1) → X

print_dot:
    li $v0, 4
    la $a0, dot_char
    syscall
    j continue_cell

print_X:
    li $v0, 4
    la $a0, X_char
    syscall
    j continue_cell

print_O:
    li $v0, 4
    la $a0, O_char
    syscall

continue_cell:
    addi $t2, $t2, 1
    li $t3, 15
    blt $t2, $t3, print_cell_loop

    # Newline after each row
    li $v0, 4
    la $a0, newline
    syscall

    addi $t7, $t7, 1
    li $t2, 0
    li $t9, 15
    blt $t7, $t9, print_row_loop

    jr $ra
