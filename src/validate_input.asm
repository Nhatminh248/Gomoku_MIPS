.data
invalid_char:   .asciiz "Invalid char, please try again.\n"
invalid_coor:   .asciiz "Out of range coordinate, please try again.\n"
pre_occu:       .asciiz "Occupied cell, please try again.\n"

.text
.globl validate_input

# Inputs:
# $a0: flag from read_input (1 if invalid char, 0 otherwise)
# $a1: x coordinate (0–14)
# $a2: y coordinate (0–14)
# $a3: board address

validate_input:
    # Save registers ($s0–$s3) if you're using them outside
    addi $sp, $sp, -16
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)
    sw $s3, 12($sp)

    move $s0, $a0  # flag
    move $s1, $a1  # x
    move $s2, $a2  # y
    move $s3, $a3  # board pointer

    # === Check for invalid character input ===
    bnez $s0, flag_char   # if flag ≠ 0 → invalid character

    # === Range check: 0 ≤ x, y ≤ 14 ===
    blt $s1, 0, flag_range
    bgt $s1, 14, flag_range
    blt $s2, 0, flag_range
    bgt $s2, 14, flag_range

    # === Check if cell is occupied ===
    li $t0, 15                  # board width
    mul $t1, $s1, $t0           # x * 15
    add $t1, $t1, $s2           # x * 15 + y → offset
    add $t2, $s3, $t1           # board + offset → cell address
    lb  $t3, 0($t2)             # load value at cell

    bnez $t3, flag_occupied     # if ≠ 0, cell is taken

    # === Input is valid ===
    li $v0, 0

    # Restore saved registers
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    addi $sp, $sp, 16

    jr $ra

# === Error: cell is occupied ===
flag_occupied:
    la $a0, pre_occu
    li $v0, 4
    syscall
    li $v0, 1

    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    addi $sp, $sp, 16
    jr $ra

# === Error: out of range ===
flag_range:
    la $a0, invalid_coor
    li $v0, 4
    syscall
    li $v0, 1

    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    addi $sp, $sp, 16
    jr $ra

# === Error: invalid character ===
flag_char:
    la $a0, invalid_char
    li $v0, 4
    syscall
    li $v0, 1

    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $s3, 12($sp)
    addi $sp, $sp, 16
    jr $ra