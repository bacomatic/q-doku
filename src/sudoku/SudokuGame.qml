/*
 * Copyright (c) 2017, David DeHaven, All Rights Reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */

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

    property int size: 3
    readonly property int rowSize: {size * size}
    readonly property int cellCount: {rowSize * rowSize}

    readonly property ListModel boardModel: ListModel {}

    // two dimensional arrays, these contain indices only
    readonly property var rowList: []
    readonly property var columnList: []
    readonly property var boxList: []

    function newBoard() {
        // reset game state
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

        // rebuild row, column, box lists
        while (rowList.pop() !== undefined) {}
        while (columnList.pop() !== undefined) {}
        while (boxList.pop() !== undefined) {}

        // initialize each with empty arrays
        for (var index = 0; index < rowSize; index++) {
            rowList[index] = [];
            columnList[index] = [];
            boxList[index] = [];
        }

        for (var index = 0; index < cellCount; index++) {
            var locked = puzzle[index] === 1;
            var guess = locked ? board[index] : 0;

            var newCell = {
                // board layout
                cellIndex: index,
                cellRow: rowForCell(index),
                cellColumn: columnForCell(index),
                cellBox: boxForCell(index),

                // starting cell info
                cellValue: board[index],
                cellLocked: locked,

                // game logic
                cellGuess: guess,
                cellError: false
            };
            boardModel.append(newCell);

            rowList[newCell.cellRow].push(index);
            columnList[newCell.cellColumn].push(index);
            boxList[newCell.cellBox].push(index);
        }
    }

    function setCellGuess(index, guess) {
        if (index < 0 || index > cellCount) {
            console.log("Error: cell index out of bounds: " + index);
            return;
        }
        if (guess < 0 || guess > rowSize) {
            console.log("Error: guess value out of bounds: " + guess);
            return;
        }

        boardModel.setProperty(index, "cellGuess", guess);
        validatePuzzle();
    }

    // Check if the two given cells match, set error on match
    // false if both cells have the same index
    // false if either cell has no guess (0)
    // else true if cell guesses match
    function checkGuessMatch(aIndex) {
        // second cell is passed as "this" arg to forEach
        var a = boardModel.get(aIndex);
        var b = this;

        // check if the cells match, if they do set error on both
        if ((a.cellIndex === b.cellIndex) || (a.cellGuess === 0) || (b.cellGuess === 0)) {
            return;
        }
        if (a.cellGuess === b.cellGuess) {
            a.cellError = b.cellError = true;
        }
    }

    // Validate the entire puzzle board
    function validatePuzzle() {
        // clear error flags
        for (var index = 0; index < boardModel.count; index++) {
            boardModel.get(index).cellError = false;
        }

        // for each entry in boardModel
        // FIXME: Can be optimized...
        for (var index = 0; index < boardModel.count; index++) {
            var cell = boardModel.get(index);
            // if already has error or has no guessed value, just skip it
            if (cell.cellError || cell.cellGuess < 1) continue;

            // TODO: We could just put these in the cell object itself for easier access
            var row = rowList[cell.cellRow];
            var col = columnList[cell.cellColumn];
            var box = boxList[cell.cellBox];

            row.forEach(checkGuessMatch, cell);
            col.forEach(checkGuessMatch, cell);
            box.forEach(checkGuessMatch, cell);
        }
    }

    function rowForCell(index) {
        if (index < 0 || index > cellCount) {
            return -1;
        }
        return Math.floor(index / rowSize);
    }

    function columnForCell(index) {
        if (index < 0 || index > cellCount) {
            return -1;
        }
        return Math.floor(index % rowSize);
    }

    function boxForCell(index) {
        if (index < 0 || index > cellCount) {
            return -1;
        }
        var boxY = Math.floor(rowForCell(index) / size);
        var boxX = Math.floor(columnForCell(index) / size);
        return boxX + boxY * size;
    }
}
