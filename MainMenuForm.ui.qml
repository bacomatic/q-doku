import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import "qrc:/sudoku/"

Item {
    property alias startButton: startButton
    property alias resumeButton: resumeButton
    property alias sizeSelect: sizeSelect
    property alias randomSeed: randomSeed

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

        enabled: SudokuGame.inPlay
        visible: SudokuGame.inPlay

        ToolTip.visible: hovered
        ToolTip.delay: 1000
        ToolTip.timeout: 5000
        ToolTip.text: "Resume your game"
    }

    Button {
        id: startButton
        x: 270
        y: 294
        text: qsTr("Start Game")
        font.pointSize: 13

        ToolTip.visible: hovered
        ToolTip.delay: 1000
        ToolTip.timeout: 5000
        ToolTip.text: "Start a new game using the current settings"
    }

    ComboBox {
        model: ["2x2", "3x3", "Random"]
        currentIndex: 1 // default to 3x3
        id: sizeSelect
        x: 260
        y: 159
        font.pointSize: 12

        ToolTip.visible: hovered
        ToolTip.delay: 1000
        ToolTip.timeout: 5000
        ToolTip.text: "Choose the size of the board you want to play"
    }

    Text {
        id: boardSizeLabel
        x: 165
        y: 168
        text: qsTr("Board Size:")
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

    TextField {
        id: randomSeed
        x: 260
        y: 220
        text: qsTr("0")
        topPadding: 6
        padding: 6
        validator: IntValidator {bottom: 0;}

        ToolTip.visible: hovered
        ToolTip.delay: 1000
        ToolTip.timeout: 5000
        ToolTip.text: "Set the random number seed for the generator, set to 0 to use get a random board."
    }
}
