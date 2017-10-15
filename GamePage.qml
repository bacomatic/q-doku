import QtQuick 2.7
import "qrc:/sudoku/"

GamePageForm {
    id: root

    signal goBack();
    signal forfeit();

    property int gridCellWidth: {
        gridView.width / SudokuGame.rowSize;
    }

    property int gridCellHeight: {
        gridView.height / SudokuGame.rowSize;
    }

    Component.onCompleted: {
        backButton.onClicked.connect(goBack);
        forfeitButton.onClicked.connect(forfeit);
    }

    /*
     * This is a delegate of SudokuGame.boardModel
     * We have the following properties:
            cellIndex:
            cellRow:
            cellColumn:
            cellBox:

            // starting cell info
            cellValue:
            cellLocked:

            // game logic
            cellGuess:
            cellError:
     */

    Component {
        id: gameCellDelegate
        Item {
            width: gridCellWidth
            height: gridCellHeight

            MouseArea {
                id: cellTile
                anchors.fill: parent

                onClicked: {
                    SudokuGame.activeCell = cellIndex;
                }
            }

            Rectangle {
                id: tileRect
                width: parent.width
                height: parent.height
                border.color: "lightgrey"
                border.width: 1
                color: {
                    // base color = gainsboro if locked, white if not
                    var baseColor = cellLocked ? "gainsboro" : "white";

                    // highlight color:
                    if (SudokuGame.activeCell === cellIndex) {
                        // give a light blue tint
                        return Qt.tint(baseColor, "lightsteelblue");
                    } else if (SudokuGame.activeRow === cellRow
                               || SudokuGame.activeColumn === cellColumn) {
                        // row or column highlighted, darken by a small amount
                        return Qt.darker(baseColor, 1.25);
                    } // else no highlight
                    return baseColor;
                }
            }

            Text {
                width: parent.width
                height: parent.height
                text: cellGuess
                font.family: "Helvetica"
                font.pointSize: 24
                color: "black"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                visible: (cellGuess !== 0) || cellLocked
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
    }
}
