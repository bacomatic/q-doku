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

import QtQuick 2.7
import QtQuick.Controls 2.2

import "qrc:/sudoku/"

GamePageForm {
    id: root

    signal gameOver();

    // The number we should highlight in the board
    property int highlightNumber: 0

    property int gridCellWidth: {
        gridView.width / SudokuGame.rowSize;
    }

    property int gridCellHeight: {
        gridView.height / SudokuGame.rowSize;
    }

    readonly property int activeRow: {
        SudokuGame.rowForCell(gridView.currentIndex);
    }

    readonly property int activeColumn: {
        SudokuGame.columnForCell(gridView.currentIndex);
    }

    readonly property int currentCellGuess: {
        if (gridView.currentIndex === -1) {
            return -1;
        }
        return SudokuGame.boardModel.get(gridView.currentIndex).cellGuess;
    }

    function takeFocus() {
        focus = true;
        gamePage.gridView.focus = true;
    }

    function reset() {
        gridView.enabled = true;
        takeFocus();
        gamePage.gridView.currentIndex = -1;
        highlightNumber = 0;
        gamePage.gameDividers.refresh();
    }

    function endGame() {
        gridView.currentIndex = -1;
        highlightNumber = -1;
        gridView.enabled = false;
        gameOver();
    }

    function setCellGuess(index, guess) {
        SudokuGame.setCellGuess(index, guess);
        // Highlight number if not clearing
        if (guess > 0) {
            highlightNumber = guess;
        }
        if (SudokuGame.gameOverMan()) {
            endGame();
        }
    }

    Component {
        id: cellHighlighter
        Item {
            // x, y, width and height will be set to the current item coordinates and size
            z: 1

            Rectangle {
                anchors.fill: parent
                color: "#400020FF"
            }

            // NOTE: coordinates here are relative to parent!
            // Row highlighter
                // left
            Rectangle {
                x: -parent.x
                y: 0
                width: parent.x
                height: parent.height
                color: "#20808010"
            }
                // right
            Rectangle {
                x: parent.width
                y: 0
                width: gridView.width - parent.x - parent.width
                height: parent.height
                color: "#20808010"
            }
                // top
            Rectangle {
                x: 0
                y: -parent.y
                width: parent.width
                height: parent.y
                color: "#20808010"
            }
                // bottom
            Rectangle {
                x: 0
                y: parent.height
                width: parent.width
                height: gridView.height - parent.y - parent.height
                color: "#20808010"
            }
        }
    }

    Component {
        id: numberButtonDelegate
        Item {
            width: parent.width
            height: 40

            Button {
                anchors.fill: parent

                text: index+1
                font.bold: true
                font.pointSize: 16

                enabled: gridView.currentItem != null && !gridView.currentItem.cellLocked

                onClicked: {
                    setCellGuess(gridView.currentIndex, index+1)
                }
            }
        }
    }

    /*
     * This is a delegate of SudokuGame.boardModel
     * We have the following properties:
            cellIndex:
            cellRow:
            cellColumn:
            cellBox:

            // starting cell info
            cellValue:
            cellLocked:

            // game logic
            cellGuess:
            cellError:
     */

    Component {
        id: gameCellDelegate
        Item {
            width: gridCellWidth
            height: gridCellHeight

            property color numberColor: {
                if (cellError && application.gameSettings.showCellErrors) {
                    return "red";
                } else if (application.gameSettings.highlightLikeNumbers &&
                           cellGuess > 0 && highlightNumber === cellGuess) {
                    return "blue";
                }
                return "black";
            }

            focus: true
            Keys.onPressed: {
                switch (event.key) {
                case Qt.Key_Escape:
                    gridView.currentIndex = -1;
                    highlightNumber = 0;
                    event.accepted = true;
                    break;

                case Qt.Key_Left:
                    // prevent wrap to previous row
                    if (cellColumn === 0) {
                        event.accepted = true;
                    }
                    break;

                case Qt.Key_Right:
                    // prevent wrap to next row
                    if (cellColumn === SudokuGame.rowSize-1) {
                        event.accepted = true;
                    }
                    break;
                default:
                    if (!cellLocked) { // can't modify locked cells
                        var numPressed = -1;

                        // Handle number key entry
                        // Key_0 = 0x30, Key_9 = 0x39, so we can just do some easy math here
                        if ((event.key >= Qt.Key_0) && (event.key <= Qt.Key_9)) {
                            numPressed = event.key - Qt.Key_0;
                        }
                        //  TODO: A-F for size 4 games

                        // zero key clears the current guess, so it's valid
                        if (numPressed >= 0 && numPressed <= SudokuGame.rowSize) {
                            event.accepted = true;
                            setCellGuess(gridView.currentIndex, numPressed);
                        }
                    }
                }
            }

            MouseArea {
                id: cellTile
                anchors.fill: parent

                onClicked: {
                    // make sure GridView has active focus when
                    // we click on it, otherwise subsequent key
                    // presses won't work
                    takeFocus();
                    gridView.currentIndex = cellIndex;
                    if (cellGuess != 0) {
                        highlightNumber = cellGuess;
                    }
                }
            }

            Rectangle {
                id: tileRect
                width: parent.width
                height: parent.height
                border.color: "lightgrey"
                border.width: 1
                color: cellLocked ? "gainsboro" : "white"
            }

            Text {
                width: parent.width
                height: parent.height
                text: cellGuess
                font.family: "Helvetica"
                font.pointSize: 24
                color: numberColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                visible: (cellGuess !== 0) || cellLocked
            }
        }
    }
}
