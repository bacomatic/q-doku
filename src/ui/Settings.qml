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

import QtQuick 2.4
import QtQuick.Controls 2.2
import "qrc:/sudoku/"

Item {
    id: settingsForm
    width: 400
    height: 400
    anchors.fill: parent

    GroupBox {
        id: groupBox
        x: 8
        y: 8
        width: 384
        height: 234
        font.pointSize: 16
        title: qsTr("Game Size")

        Repeater {
            anchors.fill: parent

            model: [
                {label: "2x2", size: 2, enabled: true},
                {label: "3x3", size: 3, enabled: true},
                // FIXME: remove enabled property when we fix 4x4
                {label: "4x4", size: 4, enabled: false},
                {label: "Random", size: 0, enabled: true},
            ]

            CheckBox {
                function isChecked() {
                    return application.gameSettings.boardSize === modelData.size
                }

                x: 0
                y: 46 * index
                text: modelData.label
                font.pointSize: 16
                enabled: modelData.enabled
                checked: isChecked()
                onClicked: {
                    application.gameSettings.setBoardSize(modelData.size)
                    // Restore binding, otherwise it gets overwritten by a boolean value
                    checked = Qt.binding(isChecked)
                }
            }
        }
    }

    CheckBox {
        id: checkBox
        x: 8
        y: 248
        width: 384
        height: 40
        text: qsTr("Show Errors")
        checked: application.gameSettings.showCellErrors
        font.pointSize: 16

        onClicked: {
            application.gameSettings.showCellErrors
                   = !application.gameSettings.showCellErrors
        }
    }

    CheckBox {
        id: checkBox1
        x: 8
        y: 294
        width: 384
        height: 40
        text: qsTr("Highlight Like Numbers")
        checked: application.gameSettings.highlightLikeNumbers
        font.pointSize: 16

        onClicked: {
            application.gameSettings.highlightLikeNumbers
               = !application.gameSettings.highlightLikeNumbers
        }
    }

    CheckBox {
        id: demoCB
        x: 8
        y: 340
        width: 384
        height: 40
        text: qsTr("Use demo boards (DEVELOPMENT)")
        checked: application.gameSettings.requestDemoBoards
        font.pointSize: 16

        onClicked: {
            application.gameSettings.requestDemoBoards
                = !application.gameSettings.requestDemoBoards
        }
    }

    Button {
        id: okButton
        x: 292
        y: 352
        text: qsTr("Close")
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        anchors.right: parent.right
        anchors.rightMargin: 8
        font.pointSize: 16

        onClicked: application.closeSettings()
    }
}
