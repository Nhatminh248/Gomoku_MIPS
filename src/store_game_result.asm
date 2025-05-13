.data
result_filename: .asciiz "result.txt"
dot_char:        .asciiz " . "
X_char:          .asciiz " X "
O_char:          .asciiz " O "
newline:         .asciiz "\n"
player1_wins_msg: .asciiz "Player 1 (X) wins!\n"
player2_wins_msg: .asciiz "Player 2 (O) wins!\n"
tie_msg:          .asciiz "Game ended in a tie.\n"
char_buf:         .space 1

.text
.globl save_board

# Inputs:
# $a0 = board base address
# $a1 = game result
#        -1 = Player 1 wins
#         1 = Player 2 wins
#         0 = Tie

save_board:
    move $s0, $a0      # Board pointer
    move $s1, $a1      # Game result

    # Open result.txt for writing
    li $v0, 13
    la $a0, result_filename
    li $a1, 1          
    li $a2, 0          # mode (ignored because no create flag)
    syscall

    move $s2, $v0      # Save file descriptor
    bltz $s2, file_open_failed

# Write board layout (15x15)
    li $t0, 0          # Row index

row_loop:
    li $t1, 0          # Column index

col_loop:
    # offset = row * 15 + col
    li $t2, 15
    mul $t3, $t0, $t2
    add $t3, $t3, $t1

    add $t4, $s0, $t3  # Address of board[row][col]
    lb $t5, 0($t4)     # Load cell value

    # Choose the correct symbol to print
    beqz $t5, write_dot
    li $t6, 1
    beq $t5, $t6, write_O
    j write_X

write_dot:
    li $v0, 15
    move $a0, $s2
    la $a1, dot_char
    li $a2, 3
    syscall
    j continue_col

write_X:
    li $v0, 15
    move $a0, $s2
    la $a1, X_char
    li $a2, 3
    syscall
    j continue_col

write_O:
    li $v0, 15
    move $a0, $s2
    la $a1, O_char
    li $a2, 3
    syscall

continue_col:
    addi $t1, $t1, 1
    li $t7, 15
    blt $t1, $t7, col_loop

    # Write newline after each row
    li $v0, 15
    move $a0, $s2
    la $a1, newline
    li $a2, 1
    syscall

    addi $t0, $t0, 1
    blt $t0, $t7, row_loop

# Write winning message 
    beqz $s1, write_tie
    li $t8, -1
    beq $s1, $t8, write_player1
    j write_player2

write_player1:
    li $v0, 15
    move $a0, $s2
    la $a1, player1_wins_msg
    li $a2, 19
    syscall
    j close_file

write_player2:
    li $v0, 15
    move $a0, $s2
    la $a1, player2_wins_msg
    li $a2, 19
    syscall
    j close_file

write_tie:
    li $v0, 15
    move $a0, $s2
    la $a1, tie_msg
    li $a2, 22
    syscall

close_file:
    li $v0, 16
    move $a0, $s2
    syscall

    jr $ra

file_open_failed:
    li $v0, 4
    la $a0, failed_open_msg
    syscall
    jr $ra

.data
failed_open_msg: .asciiz "Failed to open result.txt\n"