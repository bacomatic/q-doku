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

    function reset() {
        gamePage.focus = true;
        gamePage.gridView.focus = true;
        gamePage.gridView.currentIndex = -1;
        gamePage.gameDividers.refresh();
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
                color: "#40404040"
            }
                // left
            Rectangle {
                x: parent.width
                y: 0
                width: gridView.width - currentItemX - parent.width
                height: parent.height
                color: "#40404040"
            }
                // top
            Rectangle {
                x: 0
                y: -currentItemY
                width: parent.width
                height: currentItemY
                color: "#40404040"
            }
                // bottom
            Rectangle {
                x: 0
                y: parent.height
                width: parent.width
                height: gridView.height - currentItemY - parent.height
                color: "#40404040"
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

            focus: true
            Keys.onPressed: {
                if (event.key === Qt.Key_Escape) {
                    gridView.currentIndex = -1;
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
                        SudokuGame.setCellGuess(cellIndex, numPressed);
                    }
                }
            }

            MouseArea {
                id: cellTile
                anchors.fill: parent

                onClicked: {
                    gridView.currentIndex = cellIndex;
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
                color: cellError ? "red" : "black"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                visible: (cellGuess !== 0) || cellLocked
            }
        }
    }
}
