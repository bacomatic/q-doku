import QtQuick 2.4
import QtQuick.Controls 2.2
import "qrc:/sudoku/"

Item {
    width: 400
    height: 400

    Flow {
        id: flow1
        anchors.fill: parent
    }

    GroupBox {
        id: groupBox
        x: 8
        y: 8
        width: 384
        height: 234
        font.pointSize: 16
        title: qsTr("Game Size")

        CheckBox {
            id: size2x2
            x: 0
            y: 0
            text: qsTr("2x2")
            checked: application.gameSettings.boardSize === 2
        }

        CheckBox {
            id: size3x3
            x: 0
            y: 46
            text: qsTr("3x3")
            checked: application.gameSettings.boardSize === 3
        }

        CheckBox {
            id: sizeRandom
            x: 0
            y: 138
            text: qsTr("Random")
            checked: application.gameSettings.boardSize === 0
        }

        CheckBox {
            id: size4x4
            x: 0
            y: 92
            text: qsTr("4x4")
            checked: application.gameSettings.boardSize === 4
            enabled: false
        }
    }

    Connections {
        target: size2x2
        onClicked: application.gameSettings.boardSize = 2
    }

    Connections {
        target: size3x3
        onClicked: application.gameSettings.boardSize = 3
    }

    Connections {
        target: size4x4
        onClicked: application.gameSettings.boardSize = 4
    }

    Connections {
        target: sizeRandom
        onClicked: application.gameSettings.boardSize = 0
    }

    CheckBox {
        id: checkBox
        x: 8
        y: 248
        width: 384
        height: 40
        text: qsTr("Show Errors")
        checked: application.gameSettings.showCellErrors
        font.pointSize: 16
    }

    CheckBox {
        id: checkBox1
        x: 8
        y: 294
        width: 384
        height: 40
        text: qsTr("Highlight Like Numbers")
        checked: application.gameSettings.highlightLikeNumbers
        font.pointSize: 16
    }

    Connections {
        target: checkBox
        onClicked: application.gameSettings.showCellErrors = !application.gameSettings.showCellErrors
    }

    Connections {
        target: checkBox1
        onClicked: application.gameSettings.highlightLikeNumbers = !application.gameSettings.highlightLikeNumbers
    }
}
