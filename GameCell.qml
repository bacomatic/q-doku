import QtQuick 2.7
import "qrc:/sudoku/"

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

    Rectangle {
        x: 1
        y: 1
        width: parent.width - 2
        height: parent.height - 2
        border.color: "black"
        border.width: 1
        color: locked ? "gainsboro" : "white"
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
}
