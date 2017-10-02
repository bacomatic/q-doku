import QtQuick 2.7

MainMenuForm {
    id: root

    signal startNewGame();
    signal resumeGame();

    startButton.onClicked: {
        console.log("Starting game...");
    }

    resumeButton.onClicked: {
        console.log("Resuming game...");
    }

    sizeSelect.onCurrentIndexChanged: {
        console.log("Size changed: " + sizeSelect.currentIndex);
    }

    Component.onCompleted: {
        startButton.onClicked.connect(startNewGame);
        resumeButton.onClicked.connect(resumeGame);
    }
}
