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
import QtQuick.Layouts 1.3
import "qrc:/sudoku/"

Item {
    id: item1
    width: 640
    height: 480
    property alias gridView: gridView
    property alias gameDividers: gameDividers

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
        color: "#ffffff"
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
}
