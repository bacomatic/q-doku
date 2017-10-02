import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

Item {
    property alias startButton: startButton
    property alias resumeButton: resumeButton
    property alias sizeSelect: sizeSelect

    RowLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 20
        anchors.top: parent.top
    }

    Button {
        id: resumeButton
        x: 587
        y: 431
        width: 45
        height: 41
        text: qsTr(">")
        font.pointSize: 18

        ToolTip.visible: hovered
        ToolTip.delay: 1000
        ToolTip.timeout: 5000
        ToolTip.text: "Resume your game"

        enabled: application.gameInProgress
        visible: application.gameInProgress
    }

    Button {
        id: startButton
        x: 270
        y: 294
        text: qsTr("Start Game")
        font.pointSize: 13
    }

    ComboBox {
        model: ["2x2", "3x3", "Random"]
        currentIndex: 1 // default to 3x3
        id: sizeSelect
        x: 260
        y: 159
        font.pointSize: 12
    }

    Text {
        id: boardSizeLabel
        x: 165
        y: 168
        text: qsTr("Board Size:")
        font.pixelSize: 18
    }

    TextEdit {
        id: randomSeed
        x: 260
        y: 230
        width: 120
        height: 21
        text: qsTr("0")
        font.pixelSize: 18
    }

    Text {
        id: randomSeedLabel
        x: 139
        y: 229
        text: qsTr("Random Seed:")
        font.pixelSize: 18
    }

    Text {
        id: titleText
        x: 84
        y: 29
        width: 487
        height: 109
        text: qsTr("Q - Doku!")
        font.pixelSize: 64
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }
}
