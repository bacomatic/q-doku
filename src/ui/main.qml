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
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import "qrc:/sudoku/"

ApplicationWindow {
    id: application
    visible: true
    title: qsTr("Q - Doku!")

    // FIXME: make resizable and more mobile-friendly
    minimumHeight: 520
    maximumHeight: 520
    minimumWidth: 640
    maximumWidth: 640

    property bool inPlay: false
    property GameSettings gameSettings: settings

//    onActiveFocusItemChanged: {
//        console.log("Active focus: " + activeFocusItem)
//    }

    Shortcut {
        sequence: StandardKey.New
        onActivated: startNewGame()
    }

    Shortcut {
        // StandardKey.Quit is not supported on Windows
        sequence: "CTRL+Q" // StandardKey.Quit
        onActivated: Qt.quit()
    }

    header: ToolBar {
        RowLayout {
            anchors.fill: parent

            ToolButton {
                id: hamburgerButton
                text: "\u2630"

                contentItem: Text {
                    text: parent.text
                    font.pointSize: 16
                    color: "#606060"
                }

                onClicked: mainMenu.open()

                Menu {
                    id: mainMenu
                    MenuItem {
                        text: qsTr("New Game")
                        onClicked: startNewGame()
                    }

                    MenuItem {
                        text: qsTr("New Game with Random Seed")
                        onClicked: reqRandomSeed()
                    }

                    MenuSeparator {}

                    MenuItem {
                        text: qsTr("Quit")
                        onClicked: Qt.quit()
                    }
                }
            }

            Label {
                text: "Q-Doku!"
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
                font.pointSize: 16
            }

            ToolButton {
                id: settingsButton
                text: "\u2699"

                contentItem: Text {
                    text: parent.text
                    font.pointSize: 16
                    color: "#606060"
                }

                onClicked: {
                    if (settingsDrawer.visible) {
                        closeSettings()
                    } else {
                        openSettings()
                    }
                }
            }
        }
    }

    MessageDialog {
        property bool dirtyBoardText: false
        id: newGameAlert
        icon: StandardIcon.Warning
        title: "Game in Progress!"
        text: dirtyBoardText ?
                  "You have changed the board settings, would you like to start a new game? This will abandon the game in progress."
                : "Starting a new game will abandon the game in progress."
        informativeText: "Are you sure you want to do this?"
        standardButtons: StandardButton.Yes | StandardButton.No

        onYes: {
            newGameAlert.close()

            inPlay = false
            application.startNewGame()
        }

        onNo: {
            newGameAlert.close()
        }
    }

    Dialog {
        id: requestRandomSeed
        visible: false
        title: qsTr("Enter random seed")
        standardButtons: StandardButton.Cancel | StandardButton.Ok

        contentItem: Item {
            implicitWidth: 400
            implicitHeight: 120

            TextArea {
                id: textArea
                x: 8
                y: 8
                width: 384
                height: 52
                text: "Please enter a random seed to be used to generate a new board."
                wrapMode: Text.WordWrap
                font.pointSize: 12
            }

            TextField {
                id: textField
                x: 139
                y: 66
                width: 253
                height: 40
                text: qsTr("0")
                validator: IntValidator {}
                horizontalAlignment: Text.AlignRight
                font.pointSize: 12
            }
        }

        onAccepted: {
            requestRandomSeed.close()
            inPlay = false

            // Generate new game with given random seed
            SudokuGame.randomSeed = Number(textField.text)
            startNewGame()

            // Reset for the next game
            textField.text = "0"
            SudokuGame.randomSeed = 0
            gamePage.takeFocus()
        }

        onRejected: {
            textField.text = "0"
            SudokuGame.randomSeed = 0
            requestRandomSeed.close()
            gamePage.takeFocus()
        }
    }

    function startNewGame(dirty) {
        if (inPlay) {
            // Pop up an alert asking to abandon the current game
            if (dirty === undefined) {
                dirty = false
            }
            newGameAlert.dirtyBoardText = dirty
            newGameAlert.open()
        } else {
            inPlay = true
            SudokuGame.newBoard(settings.boardSize, settings.randomSeed, settings.requestDemoBoards)
            gamePage.reset()
        }
    }

    function reqRandomSeed() {
        requestRandomSeed.open()
    }

    function openSettings() {
        if (!settingsDrawer.visible) {
            settingsDrawer.open()
        }
    }

   function closeSettings() {
       if (settingsDrawer.visible) {
           settingsDrawer.close()
       }
   }

    // Game settings
    GameSettings {
        id: settings
    }

    // Settings drawer
    Drawer {
        id: settingsDrawer
        width: application.width * 0.90
        height: application.height
        Settings {
            id: settingsForm
        }

        onClosed: {
            // Check if board settings changed and ask if user wants to restart
            if (gameSettings.gameDirty) {
                // ask if user wants to start new game
                gameSettings.gameDirty = false
                startNewGame(true)
            }
            gamePage.takeFocus()
        }
    }

    GamePage {
        id: gamePage

        onGameOver: {
            inPlay = false
            // TODO: Do something interesting...
        }
    }

    Component.onCompleted: {
        // test the settings interface
        var version = settings.getNamedSetting("version")
        console.log("version returned: "+version)
        if (version) {
            console.log("version is "+version)
        } else {
            version = "0.1a2"
            settings.setNamedSetting("version", version)
        }

        // Ping the server so it's alive when we want to generate a new board
        SudokuGame.pingPuzzleServer()

        // Restore game if one was in progress
        var gameData = settings.getNamedSetting("SavedGame")
        if (gameData) {
            inPlay = SudokuGame.restoreGame(gameData)
        } else {
            // Start a new game
            startNewGame()
        }
    }

    Component.onDestruction: {
        // if a game is in progress, save it
        if (inPlay) {
            var gameData = SudokuGame.saveGame()
            settings.setNamedSetting("SavedGame", gameData)
        } else {
            // make sure no game is saved
            settings.setNamedSetting("SavedGame", null)
        }
    }
}
