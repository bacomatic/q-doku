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
        var cellList = gamePage.cellList;
        var gameBoard = gamePage.boardGrid;

        // Clear the existing cell list, this should also remove all cells
        // from the board grid
        while (cellList.count > 0) {
            var cell = cellList.get(0);
            cell.item.parent = null;
            cellList.remove(cell);
        }
        cellList.clear();


        var board = SudokuGame.board.board;
        var puzzle = SudokuGame.board.puzzle;

        for (var ii = 0; ii < SudokuGame.cellCount; ii++) {
            var row = SudokuGame.rowForCell(ii);
            var column =  SudokuGame.columnForCell(ii);
            var box = SudokuGame.boxForCell(ii);
            var locked = (puzzle[ii] === 1)

            var cellItem = gameCellComp.createObject(gameBoard,
                {
                    cellIndex: ii,
                    cellValue: board[ii],
                    guessValue: (locked ? board[ii] : 0), // locked cells must show cell value
                    row: row,
                    column: column,
                    locked: locked
                });

            cellItem.Layout.fillWidth = true;
            cellItem.Layout.fillHeight = true;

            cellList.append({
                                index: ii,
                                row: row,
                                column: column,
                                box: box,
                                item: cellItem
                            });
        }
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
