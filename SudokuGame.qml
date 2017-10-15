pragma Singleton

import QtQuick 2.7
import QtQml.Models 2.2
import "BoardData.js" as BoardData

/*
 * This object handles game state and some game logic. Mostly used to centralize game state.
 *
 * FIXME: Can't do this as a singleton if we implement more complex games, like Samurai
 *        (five boards overlayed). But this works for now
 */

QtObject {
    // New game settings, will not take effect until newBoard is called
    // new board size, 0 = random size, otherwise explicit size
    property int newSize: 3
    // random seed, 0 for random random seed
    property int randomSeed: 0

    property bool inPlay: false
    property int size: 3
    readonly property int rowSize: {size * size}
    readonly property int cellCount: {rowSize * rowSize}

    // Which cell is currently selected, -1 is none (zero is valid)
    property int activeCell: -1

    // The row, column and box of the currently selected cell
    readonly property int activeRow: (activeCell == -1 ? -1 : rowForCell(activeCell))
    readonly property int activeColumn: (activeCell == -1 ? -1 : columnForCell(activeCell))
    readonly property int activeBox: (activeCell == -1 ? -1 : boxForCell(activeCell))

    readonly property ListModel boardModel: ListModel {}

    // container is the parent container to add the cells to
    // cellList is expected to be ListModel
    function newBoard() {
        // reset game state
        activeCell = -1;
        if (newSize === 0) {
            size = Math.floor(Math.random() * 2) + 2; // should choose 2-3 inclusively
        } else {
            size = newSize;
        }
        console.log("Generating board size = " + size + " cellCount = " + cellCount);
        var gameBoard = BoardData.getBoard(size, randomSeed);

        boardModel.clear();
        boardModel.columnCount(rowSize);
        boardModel.rowCount(rowSize);

        var board = gameBoard.board;
        var puzzle = gameBoard.puzzle;

        for (var index = 0; index < cellCount; index++) {
            var locked = puzzle[index] === 1;
            boardModel.append({
                                  // board layout
                                  cellIndex: index,
                                  cellRow: rowForCell(index),
                                  cellColumn: columnForCell(index),
                                  cellBox: boxForCell(index),

                                  // starting cell info
                                  cellValue: board[index],
                                  cellLocked: locked,

                                  // game logic
                                  cellGuess: (locked ? board[index] : 0),
                                  cellError: false
                              });
        }
    }

    function rowForCell(index) {
        return Math.floor(index / rowSize);
    }

    function columnForCell(index) {
        return Math.floor(index % rowSize);
    }

    function boxForCell(index) {
        // box length is size cubed, so box index is cell index / size^3
        return Math.floor(index / cellCount);
    }
}
