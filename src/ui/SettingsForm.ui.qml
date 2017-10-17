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

    RadioButton {
        id: radioButton
        x: 8
        y: 291
        width: 384
        height: 40
        text: qsTr("Show Errors")
        font.pointSize: 16
        checked: true
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
            checked: SudokuGame.newSize === 2
        }

        CheckBox {
            id: size3x3
            x: 0
            y: 46
            text: qsTr("3x3")
            checked: SudokuGame.newSize === 3
        }

        CheckBox {
            id: sizeRandom
            x: 0
            y: 138
            text: qsTr("Random")
            checked: SudokuGame.newSize === 0
        }

        CheckBox {
            id: size4x4
            x: 0
            y: 92
            text: qsTr("4x4")
            checked: SudokuGame.newSize === 4
            enabled: false
        }
    }

    Connections {
        target: size2x2
        onClicked: SudokuGame.newSize = 2
    }

    Connections {
        target: size3x3
        onClicked: SudokuGame.newSize = 3
    }

    Connections {
        target: size4x4
        onClicked: SudokuGame.newSize = 4
    }

    Connections {
        target: sizeRandom
        onClicked: SudokuGame.newSize = 0
    }
}
