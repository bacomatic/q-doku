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
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import "qrc:/sudoku/"

ApplicationWindow {
    id: application
    visible: true
    width: 640
    height: 480
    title: qsTr("Q - Doku!")
    minimumHeight: 480
    maximumHeight: 480
    minimumWidth: 640
    maximumWidth: 640

    MessageDialog {
        id: newGameAlert
        icon: StandardIcon.Warning
        title: "Game in Progress!"
        text: "Starting a new game will abandon the game in progress."
        informativeText: "Are you sure you want to do this?"
        standardButtons: StandardButton.Yes | StandardButton.No

        onYes: {
            console.log("User *really* wants to start a new game, let them.");
            application.startNewGame();
            newGameAlert.close();
        }
        onNo: {
            console.log("Phew... user does NOT want to abandon their current game!");
            newGameAlert.close();
        }
    }

    function startNewGame() {
        SudokuGame.inPlay = true;
        swipeView.setCurrentIndex(1);

        SudokuGame.newBoard();
        // FIXME: there has to be a better way to do this...
        gamePage.focus = true;
        gamePage.gridView.focus = true;
        gamePage.gameDividers.refresh();
    }

    SwipeView {
        id: swipeView
        anchors.fill: parent
        interactive: false // disable swipe by mouse/gesture as it breaks app logic

        MainMenu {
            onStartNewGame: {
                if (SudokuGame.inPlay) {
                    // Pop up an alert asking to abandon the current game
                    newGameAlert.open();
                } else {
                    application.startNewGame();
                }
            }

            onResumeGame: {
                swipeView.setCurrentIndex(1);
            }

            onSelectNewSize: {
                console.log("New size: " + size);
                SudokuGame.newSize = size;
            }

            onSetRandomSeed: {
                console.log("New seed: " + seed);
                SudokuGame.randomSeed = seed;
            }
        }

        GamePage {
            id: gamePage

            onGoBack: {
                swipeView.setCurrentIndex(0);
            }

            onForfeit: {
                SudokuGame.inPlay = false;
                swipeView.setCurrentIndex(0);
            }
        }
    }
}
