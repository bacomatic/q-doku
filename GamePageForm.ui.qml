import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import "qrc:/sudoku/"

Item {
    width: 640
    height: 480
    property alias gridView: gridView
    property alias gameDividers: gameDividers
    property alias backButton: backButton
    property alias forfeitButton: forfeitButton

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
        x: 8
        y: 385
        text: qsTr("Forfeit")
        font.pointSize: 18
    }

    GridView {
        id: gridView
        x: 120
        y: 20
        width: 432
        height: 432
        cellHeight: gridCellHeight
        cellWidth: gridCellWidth
        interactive: false
        delegate: gameCellDelegate
        model: SudokuGame.boardModel
    }

    GameDividers {
        id: gameDividers
        x: 120
        y: 20
        width: 432
        height: 432
        z: 1
    }
}
