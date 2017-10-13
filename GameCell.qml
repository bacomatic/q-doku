import QtQuick 2.7
import "qrc:/sudoku/"
import "CellLogic.js" as CellLogic

Item {
    // Index of this cell, from top-left to bottom-right
    property int cellIndex: 0

    // FIXME: needed? could just special case guessValue == 0
    property bool userGuessed: false

    // Actual value of the cell, as provided in the board
    property int cellValue: 0

    // User guessed value, if any
    property int guessValue: 0

    // if true the user cannot interact with the cell (provided value in the puzzle)
    property bool locked: false

    readonly property color cellColor: {
        // base color = gainsboro if locked, white if not
        var baseColor = locked ? "gainsboro" : "white";

        // highlight color:
        if (SudokuGame.activeCell === cellIndex) {
            // give a light blue tint
            return Qt.tint(baseColor, "lightsteelblue");
        } else if (SudokuGame.activeRow === SudokuGame.rowForCell(cellIndex)
                   || SudokuGame.activeColumn === SudokuGame.columnForCell(cellIndex)) {
            // row or column highlighted, darken by a small amount
            return Qt.darker(baseColor, 1.25);
        } // else no highlight
        return baseColor;
    }

    MouseArea {
        id: cellTile
        anchors.fill: parent

        onClicked: {
            SudokuGame.activeCell = cellIndex;
        }
    }

    Rectangle {
        id: tileRect
        x: 1
        y: 1
        width: parent.width - 2
        height: parent.height - 2
        border.color: "black"
        border.width: 1
        color: parent.cellColor
    }

    Text {
        width: parent.width
        height: parent.height
        text: parent.guessValue
        font.family: "Helvetica"
        font.pointSize: 24
        color: "black"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        visible: (parent.guessValue != 0) || parent.locked
    }

    Connections {
        target: SudokuGame
        onActiveCellChanged: {
            if (SudokuGame.activeCell === cellIndex) {
                console.log("I have been activated! (index = "+cellIndex+")");
            }
        }
    }
}
