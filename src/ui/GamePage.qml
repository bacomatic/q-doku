/*
 * Copyright (c) 2017, 2018, David DeHaven, All Rights Reserved.
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
import QtQuick.Layouts 1.3

import "qrc:/sudoku/"

Item {
    id: root
    width: 640
    height: 480
    property alias gridView: gridView
    property alias gameDividers: gameDividers

    signal gameOver()

    // The number we should highlight in the board
    property int highlightNumber: 0

    property int gridCellWidth: {
        gridView.width / SudokuGame.rowSize
    }

    property int gridCellHeight: {
        gridView.height / SudokuGame.rowSize
    }

    readonly property int activeRow: {
        SudokuGame.rowForCell(gridView.currentIndex)
    }

    readonly property int activeColumn: {
        SudokuGame.columnForCell(gridView.currentIndex)
    }

    readonly property int currentCellGuess: {
        if (gridView.currentIndex === -1) {
            return -1
        }
        return SudokuGame.boardModel.get(gridView.currentIndex).cellGuess
    }

    function takeFocus() {
        focus = true
        gamePage.gridView.focus = true
    }

    function reset() {
        gridView.enabled = true
        takeFocus()
        gamePage.gridView.currentIndex = -1
        highlightNumber = 0
        gamePage.gameDividers.refresh()
    }

    function endGame() {
        gridView.currentIndex = -1
        highlightNumber = -1
        gridView.enabled = false
        gameOver()
    }

    function setCellGuess(index, guess) {
        SudokuGame.setCellGuess(index, guess)
        // Highlight number if not clearing
        if (guess > 0) {
            highlightNumber = guess
        }
        if (SudokuGame.gameOverMan()) {
            endGame()
        }
    }

    GridView {
        id: gridView
        x: 120
        width: 432
        height: 432
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        clip: true
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.AutoFlickDirection
        highlightRangeMode: GridView.ApplyRange
        highlightFollowsCurrentItem: true
        cellHeight: gridCellHeight
        cellWidth: gridCellWidth

        focus: true
        keyNavigationWraps: false

        highlight: cellHighlighter
        delegate: gameCellDelegate
        model: SudokuGame.boardModel

        currentIndex: -1

        GameDividers {
            id: gameDividers
            anchors.fill: parent
            z: 1
        }
    }

    ListView {
        id: numberButtons
        x: 26
        y: 20
        width: 40
        height: 432
        spacing: 9
        clip: true
        model: SudokuGame.rowSize
        delegate: numberButtonDelegate
    }

    Rectangle {
        id: busyBox
        x: 156
        y: 165
        width: 328
        height: 150
        color: "#ffffc9"
        radius: 10
        border.width: 2
        visible: SudokuGame.requestInProgress

        BusyIndicator {
            id: busyIndicator
            x: 134
            y: 73
            running: true
            z: 1
        }

        Text {
            id: text1
            x: 8
            y: 8
            width: 312
            height: 59
            text: qsTr("Requesting puzzle from server...")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 16
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
                    return "red"
                } else if (application.gameSettings.highlightLikeNumbers &&
                           cellGuess > 0 && highlightNumber === cellGuess) {
                    return "blue"
                }
                return "black"
            }

            focus: true
            Keys.onPressed: {
                switch (event.key) {
                case Qt.Key_Escape:
                    gridView.currentIndex = -1
                    highlightNumber = 0
                    event.accepted = true
                    break

                case Qt.Key_Left:
                    // prevent wrap to previous row
                    if (cellColumn === 0) {
                        event.accepted = true
                    }
                    break

                case Qt.Key_Right:
                    // prevent wrap to next row
                    if (cellColumn === SudokuGame.rowSize-1) {
                        event.accepted = true
                    }
                    break
                default:
                    if (!cellLocked) { // can't modify locked cells
                        var numPressed = -1

                        // Handle number key entry
                        // Key_0 = 0x30, Key_9 = 0x39, so we can just do some easy math here
                        if ((event.key >= Qt.Key_0) && (event.key <= Qt.Key_9)) {
                            numPressed = event.key - Qt.Key_0
                        }
                        //  TODO: A-F for size 4 games

                        // zero key clears the current guess, so it's valid
                        if (numPressed >= 0 && numPressed <= SudokuGame.rowSize) {
                            event.accepted = true
                            setCellGuess(gridView.currentIndex, numPressed)
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
                    takeFocus()
                    gridView.currentIndex = cellIndex
                    if (cellGuess != 0) {
                        highlightNumber = cellGuess
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
