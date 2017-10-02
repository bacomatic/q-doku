import QtQuick 2.7
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

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

    property bool gameInProgress: false

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
        gameInProgress = true;
        swipeView.setCurrentIndex(1);
    }

    SwipeView {
        id: swipeView
        anchors.fill: parent

        MainMenu {
            onStartNewGame: {
                if (gameInProgress) {
                    // Pop up an alert asking to abandon the current game
                    newGameAlert.open();
                } else {
                    application.startNewGame();
                }
            }

            onResumeGame: {
                swipeView.setCurrentIndex(1);
            }
        }

        GamePage {
            onGoBack: {
                swipeView.setCurrentIndex(0);
            }

            onForfeit: {
                gameInProgress = false;
                swipeView.setCurrentIndex(0);
            }
        }
    }
}
