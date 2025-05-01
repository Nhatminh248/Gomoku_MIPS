# Gomoku_MIPS

This repository contains both the implementation and description of the classic board game **Gomoku**, also known as **"Cờ Caro"** in Vietnamese. The project includes a detailed specification of the program, the underlying algorithm, and the complete source code.

- The `Assignment_sem_242` folder provides the project description and requirement details.
- The `README.md` outlines the program specification and algorithmic approach.
- The source code can be found in the `source_code` directory.

---

## 📁 Project Structure

- `Assignment_sem_242/` – Project description and requirements  
- `source_code/` – Complete MIPS assembly implementation  
- `README.md` – This document  

---

## 🔁 Program Flow


---

## ⚙️ Function Definitions



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