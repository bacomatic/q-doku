import QtQuick 2.7
import "qrc:/sudoku/"

GamePageForm {
    id: root

    signal goBack();
    signal forfeit();

    Component.onCompleted: {
        backButton.onClicked.connect(goBack);
        forfeitButton.onClicked.connect(forfeit);
    }
}
