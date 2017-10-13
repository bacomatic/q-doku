import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import "qrc:/sudoku/"

Item {
    width: 640
    height: 480
    property alias gameDividers: gameDividers
    property alias boardGrid: boardGrid
    property alias backButton: backButton
    property alias forfeitButton: forfeitButton
    property alias cellList: cellList

    Button {
        id: backButton
        x: 8
        y: 432
        width: 45
        height: 40
        text: qsTr("<")
        font.pointSize: 18
        ToolTip.visible: hovered
        ToolTip.delay: 1000
        ToolTip.timeout: 5000
        ToolTip.text: "Back to main menu"
    }

    Button {
        id: forfeitButton
        x: 59
        y: 432
        text: qsTr("Forfeit")
        font.pointSize: 18
    }

    GridLayout {
        id: boardGrid
        x: 120
        y: 20
        width: 400
        height: 400
        columnSpacing: 0
        rowSpacing: 0
        rows: SudokuGame.rowSize
        columns: SudokuGame.rowSize
    }

    ListModel {
        id: cellList
    }

    GameDividers {
        id: gameDividers
        x: 120
        y: 20
        width: 400
        height: 400
        z: 1
    }
}
