# Gomoku_MIPS

This repository contains both the implementation and description of the classic board game **Gomoku**, also known as **"Cờ Caro"** in Vietnamese. The project includes a detailed specification of the program, the underlying algorithm, and the complete source code.

- The folder provides the project description and requirement details.
- The `README.md` outlines the program specification and algorithmic approach.
- The source code can be found in the `src` folder.

---

## 📁 Project Structure

- `Gomoku_MIPS/` – Project description and requirements  
- `src/` – Complete MIPS assembly implementation  
- `README.md` – The documentation  

---

## 🔁 Program Flow
```python
1.  initialize board[15][15] to EMPTY
2.  draw_board(board)
3.  move_counter = 0
4.
5.  while (win_position != true):
6.      # player1:
7.      read_input()
8.      validate_input()
9.      draw_board()
10.     win_position()
11.     move_counter++
12.
13.     # player2:
14.     read_input()
15.     validate_input()
16.     draw_board()
17.     win_position()
18.     move_counter++
19.
20.     if (move_counter == max_move)
21.         jump save_game_result()
22.     else
23.         jump player1
24.
25. save_game_result(board, winner)
26. exit()
```
---

## ⚙️ Function Definitions

### draw_board
**Inputs:**
- $a0: Board base address
- $a1: X coordinate
- $a2: Y coordinate
- $a3: Player value (-1 for X, 1 for O, 0 for empty)

**Outputs:** None (prints board to console)

**Description:** 
Updates the specified board position with the player’s symbol and displays the entire 15×15 board with row and column headers. 
Empty cells are shown as dots (.), and player symbols are drawn accordingly.
### read_input
**Inputs:** None (reads from console)

**Outputs:**
- $v0: Flag (0 for success, 1 for invalid input)
- $s0: Parsed X coordinate
- $s1: Parsed Y coordinate

**Description:** 
Reads user input in "x,y" format, parses the coordinates, and validates the input format. 
Returns the coordinates and a flag indicating if the input was valid.
### validate_input
**Inputs:**
- $a0: Flag from `read_input`
- $a1: X coordinate
- $a2: Y coordinate
- $a3: Board address

**Outputs:** 
- $v0: Validation result (0 for valid, 1 for invalid)

**Description:** 
Checks if input coordinates are:
- Numeric
- Within 0–14 range
- Pointing to an unoccupied cell

Prints appropriate error messages for invalid inputs.
### win_posit**Inputs:**
- $a0: Board address
- $a1: X coordinate
- $a2: Y coordinate
- $a3: Player value (-1 or 1)

**Outputs:**
- $v1: 1 if win detected, 0 otherwise

**Description:** 
Checks if the last move created a line of 5 consecutive identical symbols (horizontal, vertical, or diagonal) using delta steps from the last move.ion

### save_board
**Inputs:**
- $a0: Board address
- $a1: Game result (-1 for Player 1 win, 1 for Player 2 win, 0 for tie)

**Outputs:** None (writes to file)

**Description:** 
Saves the final board state and game outcome message to "result.txt", including:
- 15×15 board state
- Victory or tie message



---

## 📝 Additional Notes

- The game board is stored in memory as a 225-byte array (`15×15`) using the `.space` directive.
- Player markers:
  - **Player 1**: `-1` (represented as **X**)
  - **Player 2**: `1` (represented as **O**)
  - **Empty Cell**: `0`
- The program robustly handles all edge cases, including:
  - Invalid input values  
  - Out-of-bound coordinates  
  - Attempts to place a marker on an occupied cell  
- A tie is detected by tracking the number of moves made while no player has met the win condition.
- **To run the game in MARS MIPS:**
  - Enable the **"Run all files in directory"** option.
  - Ensure the program is placed in the same directory as the MARS MIPS executable to allow the `save_state` function to work correctly.

---
