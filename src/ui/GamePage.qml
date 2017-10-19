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

            property int currentItemX: gridView.currentItem ? gridView.currentItem.x : 0
            property int currentItemY: gridView.currentItem ? gridView.currentItem.y : 0

            Rectangle {
                anchors.fill: parent
                color: "#400020FF"
            }

            // NOTE: coordinates here are relative to parent!
            // Row highlighter
                // right
            Rectangle {
                x: -currentItemX
                y: 0
                width: currentItemX
                height: parent.height
                color: "#20808010"
            }
                // left
            Rectangle {
                x: parent.width
                y: 0
                width: gridView.width - currentItemX - parent.width
                height: parent.height
                color: "#20808010"
            }
                // top
            Rectangle {
                x: 0
                y: -currentItemY
                width: parent.width
                height: currentItemY
                color: "#20808010"
            }
                // bottom
            Rectangle {
                x: 0
                y: parent.height
                width: parent.width
                height: gridView.height - currentItemY - parent.height
                color: "#20808010"
            }
        }
    }

    Component {
        id: numberButtonDelegate
        Item {
            width: 40
            height: 40

            Rectangle {
                width: 40
                height: 40
                color: currentCellGuess === index+1
                        ? "grey"
                        : "lightgrey";
            }

            MouseArea {
                width: 40
                height: 40
                enabled: gridView.currentIndex != -1

                onClicked: {
                    if (gridView.currentIndex != -1) {
                        setCellGuess(gridView.currentIndex, index+1);
                    }
                }
            }

            Text {
                text: index+1
                font.bold: true
                font.pointSize: 16
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
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
                if (cellError && SudokuGame.showCellErrors) {
                    return "red";
                } else if (SudokuGame.highlightLikeNumbers &&
                           cellGuess > 0 && highlightNumber === cellGuess) {
                    return "blue";
                }
                return "black";
            }

            focus: true
            Keys.onPressed: {
                if (event.key === Qt.Key_Escape) {
                    gridView.currentIndex = -1;
                    highlightNumber = 0;
                }

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
