import QtQuick 2.7
import QtQuick.Controls 2.1

MainMenuForm {
    id: root

    signal startNewGame();
    signal resumeGame();
    signal selectNewSize(int size);
    signal setRandomSeed(int seed);

    sizeSelect.onCurrentIndexChanged: {
        var size = 3;
        switch (sizeSelect.currentIndex) {
        case 0: // 2x2
            size = 2;
            break;
        case 2: // Random
            size = 0;
            break;
        default:
            break; // default to 3
        }
        selectNewSize(size);
    }

    Component.onCompleted: {
        startButton.onClicked.connect(startNewGame);
        resumeButton.onClicked.connect(resumeGame);
    }

    // NOTE: Ugly workaround for https://bugreports.qt.io/browse/QTBUG-59908
    Connections {
        target: randomSeed
        onEditingFinished: {
            // The validator on the TextField guarantees we only have numbers
            setRandomSeed(randomSeed.text.parseInt());
        }
    }
}
