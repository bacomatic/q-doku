import QtQuick 2.7
import "qrc:/sudoku/"

Item {
    id: container

    function refresh() {
        canvas.requestPaint();
    }

    // This will be overlayed on top of the game board
    Canvas {
        id: canvas
        width: parent.width
        height: parent.height
        antialiasing: false

        onPaint: {
            var ctx = getContext("2d");
            var gameSize = SudokuGame.size;
            var boxWidth = width / gameSize;
            var boxHeight = height / gameSize;

            ctx.save();

            // clear first
            ctx.clearRect(0, 0, width, height);
            ctx.lineWidth = 2.0;

            // number of dividers in each direction is size - 1
            for (var ii = 1; ii <= gameSize; ii++) {
                // horizontal divider
                ctx.beginPath();
                ctx.moveTo(0, boxHeight * ii);
                ctx.lineTo(width, boxHeight * ii);
                ctx.closePath();
                ctx.stroke();

                // vertical divider
                ctx.beginPath();
                ctx.moveTo(boxWidth * ii, 0);
                ctx.lineTo(boxWidth * ii, height);
                ctx.closePath();
                ctx.stroke();
            }
            ctx.restore();
        }
    }
}
