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

    signal goBack();
    signal forfeit();

    property int gridCellWidth: {
        gridView.width / SudokuGame.rowSize;
    }

    property int gridCellHeight: {
        gridView.height / SudokuGame.rowSize;
    }

    Component.onCompleted: {
        backButton.onClicked.connect(goBack);
        forfeitButton.onClicked.connect(forfeit);
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

            MouseArea {
                id: cellTile
                anchors.fill: parent

                onClicked: {
                    SudokuGame.activeCell = cellIndex;
                }
            }

            Rectangle {
                id: tileRect
                width: parent.width
                height: parent.height
                border.color: "lightgrey"
                border.width: 1
                color: {
                    // base color = gainsboro if locked, white if not
                    var baseColor = cellLocked ? "gainsboro" : "white";

                    // highlight color:
                    if (SudokuGame.activeCell === cellIndex) {
                        // give a light blue tint
                        return Qt.tint(baseColor, "lightsteelblue");
                    } else if (SudokuGame.activeRow === cellRow
                               || SudokuGame.activeColumn === cellColumn) {
                        // row or column highlighted, darken by a small amount
                        return Qt.darker(baseColor, 1.25);
                    } // else no highlight
                    return baseColor;
                }
            }

            Text {
                width: parent.width
                height: parent.height
                text: cellGuess
                font.family: "Helvetica"
                font.pointSize: 24
                color: "black"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                visible: (cellGuess !== 0) || cellLocked
            }

            Connections {
                target: SudokuGame
                onActiveCellChanged: {
                    if (SudokuGame.activeCell === cellIndex) {
                        console.log("I have been activated! (index = "+cellIndex+")");
                    }
                }
            }
        }
    }
}
