import QtQuick 2.7

GamePageForm {
    id: root

    signal goBack();
    signal forfeit();

    Component.onCompleted: {
        backButton.onClicked.connect(goBack);
        forfeitButton.onClicked.connect(forfeit);
    }
}
