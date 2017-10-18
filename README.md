# Q-Doku!
#### Qt5 based Sudoku game that uses the sudoku-serve backend for board generation.

TODO:
- [ ] Add more docs and stuff
	- [ ] About box
	- [ ] Splash screen
- [X] Restructure project so it isn't a pile of spaghetti
- [X] Add actual backend support (fetch a puzzle)
	- [X] Remove demo puzzles
	- [ ] Request real puzzles, not demo puzzles
- [X] Add game board to GamePage
- [ ] Add game logic
	- [X] Add mouse selection and cell highlighting
	- [X] Add keyboard navigation
	- [X] Add number entry
	- [X] Add puzzle validation, error detection
	- [X] Error/Warning highlighting
	- [ ] Add game over logic
- [X] Hide main menu in a hamburger instead of goofy swipe view
- [X] License headers...
- [X] Better board grid generation
- [X] Change to use model/delegate model instead of JS array
- [ ] Start new game on startup, if none in progress
- [ ] Settings storage, remember things between launches
- [ ] Save game on exit, restore on launch
- [ ] Gameplay statistics would be nice (not available during game play)
	- [ ] Time spent each game
	- [ ] Guesses made
	- [ ] Correct guesses made
	- [ ] Guess error rate
- [ ] SaaM (SudokuGame as a Model)
- [ ] Board generator progress meter, if board/puzzle needs to be generated

Features requiring backend work:
- [ ] Actual puzzle generation
- [ ] Selectable puzzle difficulties
- [ ] Different configurations, e.g., Samurai boards

BUGS:
- [ ] Left/right arrow navigation wraps around to prev/next row
- [ ] Row/Col highlight bar doesn't animate shrinking when cell selection moves
- [ ] Random seed dialog is uuuuuuugly
