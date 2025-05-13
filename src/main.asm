.data
move_counter:   .word 0
board:  .space 255  # 15 by 15 board
player1_msg:    .asciiz "\nPlayer 1 (X), please input your coordinate: "
player2_msg:    .asciiz "\nPlayer 2 (O), please input your coordinate: "
newline:	.asciiz "\n"
.text

# ================================== Main function ===================================
.globl _start 

_start:
    # Print the game instruction
    la $a0, instruction
    li $v0, 4
    syscall

    # Allocate board with 0 
	la $a0, board

    init_board:
    move $t0, $a0
    li $t1, 225
    li $t2, 0

    init_loop:  
    blez $t1, end_init
    sb $t2, 0($t0)
    addi $t0, $t0, 1
    addi $t1, $t1, -1
    j init_loop

    end_init:

    # Load parameters for the draw board function
    la $a0, board
    li $a1, 0
    li $a2, 0
    li $a3, 0
    # Print the initial board
    jal draw_board

# ================================== Start game loop ==================================
game_loop:
player1_turn:
	# Print player 1 prompt
	la $a0, player1_msg
	li $v0, 4
	syscall

    # Read input as string then parse to int 
	jal read_input 
	
    # Load the value of the parameters to check valid input or not
    move $a0, $v0   # Flag of read_input 
    move $a1, $s0   # x coor
    move $a2, $s1   # y coor
    la $a3, board   # board address

    # Check if the input is valid or not
    jal validate_input
    # if input is not valid, enter again
    bnez $v0, player1_turn     

    # Load value of the parameters to drawboard
    la $a0, board
    li $a3, -1      # -1 indicate player 1
    jal draw_board

    # After drawing the board (player1)
    lw $t0, move_counter
    addi $t0, $t0, 1
    sw $t0, move_counter

    # Check if the coordinate makes a win
    la $a0, board 
    # move $a1, $s0   # x coordinate from input
    # move $a2, $s1   # y coordinate from input
    li $a3, -1
    jal win_position

    # After checking for win
    lw $t0, move_counter
    li $t1, 225
    beq $t0, $t1, tie_game

    # If return value of win_position() == 1 then jump to game_end label
    beq $v1, 1, game_end

player2_turn:
    # Print player 2 prompt
    la $a0, player2_msg
	li $v0, 4
	syscall
	
    # Read input as string then parse to int 
    jal read_input

    # Load the value of the parameters to check valid input or not
    move $a0, $v0   # Flag of read_input 
    move $a1, $s0   # x coor
    move $a2, $s1   # y coor
    la $a3, board   # board address

    # Check if the input is valid or not
    jal validate_input
    # if input is not valid, enter again
    bnez $v0, player2_turn     # if input is invalid, enter again

    # Load value of the parameters to drawboard
    la $a0, board
    li $a3, 1      # -1 indicate player 1
    jal draw_board

    # After drawing the board (player1)
    lw $t0, move_counter
    addi $t0, $t0, 1
    sw $t0, move_counter

    # Check if the coordinate makes a win
    la $a0, board 
    # move $a1, $s0   # x coordinate from input
    # move $a2, $s1   # y coordinate from input
    li $a3, 1
    jal win_position

    # After checking for win
    lw $t0, move_counter
    li $t1, 225
    beq $t0, $t1, tie_game

    beq $v1, 1, game_end
    j game_loop

game_end:
    # Check which player wins
    beq $s6, 1, player1_win
    la $a0, win2_msg
    li $v0, 4
    syscall
    # Register $s6 store the current player (-1 for player 1,  for player 2) 
    li $s6, 1
    j save_game
    
player1_win:
    la $a0, win1_msg
    li $v0, 4
    syscall
    # Register $s6 store the current player (1 for player 1, 2 for player 2) 
    li $s6, -1
    j save_game

tie_game:
    # Print tie message
    la $a0, tie_msg
    li $v0, 4
    syscall

    # Save the game
    j save_game

save_game:
    la $a0, end_msg
    li $v0, 4
    syscall
    la $a0, board
    move $a1, $s6
    jal save_board


# ================================== End game loop ==================================

exit:
	li $v0, 10
	syscall

.data
instruction:    .asciiz "------------------ Instruction: ------------------ \nYou will play on a 15x15 grid board.\nPlayer 1 uses X, Player 2 uses O.\nPlayers take turns entering coordinates (in the format - row, column: e.g: 4,5; 1,1) to place their piece.\nFirst player to align 5 pieces in a row: horizontally, vertically, diagonally. Wins!\n\n"
win1_msg:       .asciiz "Player 1 (X) win!\n"
win2_msg:       .asciiz "Player 2 (O) win!\n"
tie_msg:        .asciiz "Tie!\n"
end_msg:        .asciiz "The game ended. The result will be stored into result.txt file.\n"