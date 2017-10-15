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

    property var gameCellComp;
    property var cellList: [];

    function startNewGame() {
        SudokuGame.inPlay = true;
        swipeView.setCurrentIndex(1);

        SudokuGame.newBoard();

        gameCellComp = Qt.createComponent("GameCell.qml");
        if (gameCellComp.status === Component.Ready) {
            buildBoard();
        } else {
            console.log("GameCell load status: " + gameCellComp.status);
            if (gameCellComp.status === Component.Error) {
                console.log(gameCellComp.errorString());
            }

            gameCellComp.statusChanged.connect(buildBoard);
        }
    }

    function buildBoard() {
//        var gameBoard = gamePage.boardGrid;

//        // FIXME: Use a delegate (?) to construct GameCell automatically?
//        var model = SudokuGame.boardModel;
//        for (var ii = 0; ii < model.count; ii++) {
//            var cellData = model.get(ii);
//            var cellItem = gameCellComp.createObject(gameBoard,
//                {
//                    cellIndex: ii,
//                    cellValue: cellData.cellValue,
//                    guessValue: (cellData.locked ? cellData.cellValue : -1), // locked cells must show cell value
//                    row: cellData.row,
//                    column: cellData.column,
//                    locked: cellData.locked
//                });

//            cellItem.Layout.fillWidth = true;
//            cellItem.Layout.fillHeight = true;
//        }
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
